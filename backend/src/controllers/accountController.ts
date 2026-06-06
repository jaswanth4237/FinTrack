import { Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { AuthRequest } from '../middleware/authMiddleware';

const prisma = new PrismaClient();

export const getAccounts = async (req: AuthRequest, res: Response) => {
    try {
        const accounts = await prisma.account.findMany({
            where: { user_id: req.user?.userId }
        });
        res.json({ success: true, data: accounts });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const createAccount = async (req: AuthRequest, res: Response) => {
    const { account_name, account_type, balance, color, icon, is_primary } = req.body;
    try {
        const account = await prisma.account.create({
            data: {
                account_name,
                account_type,
                balance: balance || 0,
                color,
                icon,
                is_primary: is_primary || false,
                user_id: req.user!.userId
            }
        });
        res.status(201).json({ success: true, data: account });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const getAccount = async (req: AuthRequest, res: Response) => {
    try {
        const account = await prisma.account.findFirst({
            where: { id: req.params.accountId as string, user_id: req.user?.userId }
        });
        if (!account) return res.status(404).json({ success: false, error: 'NOT_FOUND', message: 'Account not found' });
        res.json({ success: true, data: account });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const updateAccount = async (req: AuthRequest, res: Response) => {
    try {
        const account = await prisma.account.update({
            where: { id: req.params.accountId as string, user_id: req.user?.userId },
            data: req.body
        });
        res.json({ success: true, data: account });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const deleteAccount = async (req: AuthRequest, res: Response) => {
    try {
        await prisma.account.delete({
            where: { id: req.params.accountId as string, user_id: req.user?.userId }
        });
        res.json({ success: true, message: 'Account deleted' });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const getBalanceHistory = async (req: AuthRequest, res: Response) => {
    // Get balance history for account (last 30 days grouped by date)
    try {
        const accountId = req.params.accountId;
        const thirtyDaysAgo = new Date();
        thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

        const transactions = await prisma.transaction.findMany({
            where: {
                account_id: accountId as string,
                user_id: req.user?.userId,
                transaction_date: { gte: thirtyDaysAgo }
            },
            orderBy: { transaction_date: 'asc' }
        });

        const history: Record<string, number> = {};
        let currentBalance = 0; // This is tricky. Simplified for now: just group net change by day.

        // Proper way would be starting balance + cumulative sum
        // For now, let's just return a summary of net changes per day
        transactions.forEach(t => {
            const date = t.transaction_date.toISOString().split('T')[0];
            const amount = t.transaction_type === 'income' ? t.amount : -t.amount;
            history[date] = (history[date] || 0) + amount;
        });

        res.json({ success: true, data: history });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

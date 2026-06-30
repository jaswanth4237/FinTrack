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
    try {
        const accountId = req.params.accountId;
        const thirtyDaysAgo = new Date();
        thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 29);
        thirtyDaysAgo.setHours(0, 0, 0, 0);

        const transactions = await prisma.transaction.findMany({
            where: {
                account_id: accountId as string,
                user_id: req.user?.userId
            },
            orderBy: { transaction_date: 'asc' }
        });

        // Compute starting balance before thirty days ago
        let balance = 0;
        const beforeTransactions = transactions.filter(t => new Date(t.transaction_date) < thirtyDaysAgo);
        beforeTransactions.forEach(t => {
            balance += t.transaction_type === 'income' ? t.amount : -t.amount;
        });

        const history: Record<string, number> = {};

        // Compute balance daily for the last 30 days
        for (let i = 29; i >= 0; i--) {
            const d = new Date();
            d.setDate(d.getDate() - i);
            const dateStr = d.toISOString().split('T')[0];

            const dayTransactions = transactions.filter(t => {
                const tDateStr = new Date(t.transaction_date).toISOString().split('T')[0];
                return tDateStr === dateStr;
            });

            dayTransactions.forEach(t => {
                balance += t.transaction_type === 'income' ? t.amount : -t.amount;
            });

            history[dateStr] = balance;
        }

        res.json({ success: true, data: history });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

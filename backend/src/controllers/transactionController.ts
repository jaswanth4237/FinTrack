import { Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { AuthRequest } from '../middleware/authMiddleware';
import { calculateAccountBalance } from '../services/transactionService';

const prisma = new PrismaClient();

export const getTransactions = async (req: AuthRequest, res: Response) => {
    const { account_id, category_id, transaction_type, start_date, end_date, page = 1, limit = 20 } = req.query;
    const skip = (Number(page) - 1) * Number(limit);

    try {
        const where: any = { user_id: req.user?.userId };
        if (account_id) where.account_id = String(account_id);
        if (category_id) where.category_id = String(category_id);
        if (transaction_type) where.transaction_type = String(transaction_type);
        if (start_date || end_date) {
            where.transaction_date = {};
            if (start_date) where.transaction_date.gte = new Date(String(start_date));
            if (end_date) where.transaction_date.lte = new Date(String(end_date));
        }

        const transactions = await prisma.transaction.findMany({
            where,
            skip,
            take: Number(limit),
            orderBy: { transaction_date: 'desc' },
            include: { category: true, account: true }
        });

        const total = await prisma.transaction.count({ where });

        res.json({
            success: true,
            data: {
                transactions,
                pagination: {
                    total,
                    page: Number(page),
                    limit: Number(limit),
                    pages: Math.ceil(total / Number(limit))
                }
            }
        });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const createTransaction = async (req: AuthRequest, res: Response) => {
    const { account_id, category_id, amount, transaction_type, description, transaction_date, is_recurring, recurrence_rule } = req.body;

    if (transaction_type !== 'income' && transaction_type !== 'expense') {
        return res.status(400).json({ success: false, error: 'BAD_REQUEST', message: 'Transaction type must be income or expense' });
    }

    try {
        const transaction = await prisma.$transaction(async (tx) => {
            const t = await tx.transaction.create({
                data: {
                    amount: Number(amount),
                    transaction_type,
                    description,
                    transaction_date: new Date(transaction_date),
                    is_recurring: is_recurring || false,
                    recurrence_rule,
                    user_id: req.user!.userId,
                    account_id,
                    category_id
                }
            });

            const newBalance = await calculateAccountBalance(account_id);
            await tx.account.update({
                where: { id: account_id },
                data: { balance: newBalance }
            });

            return t;
        });

        res.status(201).json({ success: true, data: transaction });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const getTransaction = async (req: AuthRequest, res: Response) => {
    try {
        const transaction = await prisma.transaction.findFirst({
            where: { id: req.params.transactionId as string, user_id: req.user?.userId },
            include: { category: true, account: true }
        });
        if (!transaction) return res.status(404).json({ success: false, error: 'NOT_FOUND', message: 'Transaction not found' });
        res.json({ success: true, data: transaction });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const updateTransaction = async (req: AuthRequest, res: Response) => {
    try {
        const transaction = await prisma.$transaction(async (tx) => {
            const t = await tx.transaction.update({
                where: { id: req.params.transactionId as string, user_id: req.user?.userId },
                data: req.body
            });

            const newBalance = await calculateAccountBalance(t.account_id);
            await tx.account.update({
                where: { id: t.account_id },
                data: { balance: newBalance }
            });

            return t;
        });
        res.json({ success: true, data: transaction });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const deleteTransaction = async (req: AuthRequest, res: Response) => {
    try {
        const transaction = await prisma.transaction.findUnique({
            where: { id: req.params.transactionId as string, user_id: req.user?.userId }
        });
        if (!transaction) return res.status(404).json({ success: false, error: 'NOT_FOUND', message: 'Transaction not found' });

        await prisma.$transaction(async (tx) => {
            await tx.transaction.delete({
                where: { id: req.params.transactionId as string }
            });

            const newBalance = await calculateAccountBalance(transaction.account_id);
            await tx.account.update({
                where: { id: transaction.account_id },
                data: { balance: newBalance }
            });
        });

        res.json({ success: true, message: 'Transaction deleted' });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const getMonthlySummary = async (req: AuthRequest, res: Response) => {
    const { month } = req.query; // YYYY-MM
    if (!month) return res.status(400).json({ success: false, error: 'BAD_REQUEST', message: 'Month is required in YYYY-MM format' });

    try {
        const startDate = new Date(`${month}-01`);
        const endDate = new Date(startDate.getFullYear(), startDate.getMonth() + 1, 0);

        const transactions = await prisma.transaction.findMany({
            where: {
                user_id: req.user?.userId,
                transaction_date: { gte: startDate, lte: endDate }
            }
        });

        let total_income = 0;
        let total_expense = 0;

        transactions.forEach(t => {
            if (t.transaction_type === 'income') total_income += t.amount;
            else if (t.transaction_type === 'expense') total_expense += t.amount;
        });

        res.json({
            success: true,
            data: {
                total_income,
                total_expense,
                net_savings: total_income - total_expense
            }
        });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const getCategoryBreakdown = async (req: AuthRequest, res: Response) => {
    const { start_date, end_date } = req.query;
    try {
        const transactions = await prisma.transaction.findMany({
            where: {
                user_id: req.user?.userId,
                transaction_type: 'expense',
                transaction_date: {
                    gte: start_date ? new Date(String(start_date)) : undefined,
                    lte: end_date ? new Date(String(end_date)) : undefined
                }
            },
            include: { category: true }
        });

        const breakdown: Record<string, { total: number, color: string, icon: string, name: string }> = {};

        transactions.forEach(t => {
            if (!breakdown[t.category_id]) {
                breakdown[t.category_id] = {
                    total: 0,
                    color: t.category.color,
                    icon: t.category.icon,
                    name: t.category.category_name
                };
            }
            breakdown[t.category_id].total += t.amount;
        });

        res.json({ success: true, data: Object.values(breakdown) });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

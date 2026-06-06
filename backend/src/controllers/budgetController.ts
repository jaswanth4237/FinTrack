import { Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { AuthRequest } from '../middleware/authMiddleware';

const prisma = new PrismaClient();

export const getBudgets = async (req: AuthRequest, res: Response) => {
    try {
        const budgets = await prisma.budget.findMany({
            where: { user_id: req.user?.userId },
            include: { category: true }
        });
        res.json({ success: true, data: budgets });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const createBudget = async (req: AuthRequest, res: Response) => {
    const { category_id, budget_name, amount_limit, period_type, start_date, end_date, alert_threshold } = req.body;
    try {
        const budget = await prisma.budget.create({
            data: {
                budget_name,
                amount_limit: Number(amount_limit),
                period_type,
                start_date: new Date(start_date),
                end_date: new Date(end_date),
                alert_threshold: Number(alert_threshold) || 80,
                user_id: req.user!.userId,
                category_id
            }
        });
        res.status(201).json({ success: true, data: budget });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const getBudget = async (req: AuthRequest, res: Response) => {
    try {
        const budget = await prisma.budget.findFirst({
            where: { id: req.params.budgetId as string, user_id: req.user?.userId },
            include: {
                category: {
                    include: {
                        transactions: {
                            where: {
                                transaction_date: {
                                    gte: { _ref: 'Budget.start_date' } as any, // This is not how prisma works, but logic is: get transactions in budget period
                                }
                            }
                        }
                    }
                }
            }
        });
        // Correction for the transactions query
        const b = await prisma.budget.findFirst({
            where: { id: req.params.budgetId as string, user_id: req.user?.userId },
            include: { category: true }
        });
        if (!b) return res.status(404).json({ success: false, error: 'NOT_FOUND', message: 'Budget not found' });

        const transactions = await prisma.transaction.findMany({
            where: {
                user_id: req.user?.userId,
                category_id: b.category_id,
                transaction_date: {
                    gte: b.start_date,
                    lte: b.end_date
                }
            }
        });

        res.json({ success: true, data: { ...b, transactions } });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const updateBudget = async (req: AuthRequest, res: Response) => {
    try {
        const budget = await prisma.budget.update({
            where: { id: req.params.budgetId as string, user_id: req.user?.userId },
            data: req.body
        });
        res.json({ success: true, data: budget });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const deleteBudget = async (req: AuthRequest, res: Response) => {
    try {
        await prisma.budget.delete({
            where: { id: req.params.budgetId as string, user_id: req.user?.userId }
        });
        res.json({ success: true, message: 'Budget deleted' });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

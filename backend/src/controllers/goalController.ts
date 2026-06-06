import { Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { AuthRequest } from '../middleware/authMiddleware';

const prisma = new PrismaClient();

export const getGoals = async (req: AuthRequest, res: Response) => {
    try {
        const goals = await prisma.financialGoal.findMany({
            where: { user_id: req.user?.userId }
        });
        res.json({ success: true, data: goals });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const createGoal = async (req: AuthRequest, res: Response) => {
    const { goal_name, target_amount, saved_amount, target_date, goal_color, goal_icon } = req.body;
    try {
        const goal = await prisma.financialGoal.create({
            data: {
                goal_name,
                target_amount: Number(target_amount),
                saved_amount: Number(saved_amount) || 0,
                target_date: new Date(target_date),
                goal_color,
                goal_icon,
                user_id: req.user!.userId
            }
        });
        res.status(201).json({ success: true, data: goal });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const getGoal = async (req: AuthRequest, res: Response) => {
    try {
        const goal = await prisma.financialGoal.findFirst({
            where: { id: req.params.goalId as string, user_id: req.user?.userId }
        });
        if (!goal) return res.status(404).json({ success: false, error: 'NOT_FOUND', message: 'Goal not found' });
        res.json({ success: true, data: goal });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const updateGoal = async (req: AuthRequest, res: Response) => {
    try {
        const goal = await prisma.financialGoal.update({
            where: { id: req.params.goalId as string, user_id: req.user?.userId },
            data: req.body
        });
        res.json({ success: true, data: goal });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const deleteGoal = async (req: AuthRequest, res: Response) => {
    try {
        await prisma.financialGoal.delete({
            where: { id: req.params.goalId as string, user_id: req.user?.userId }
        });
        res.json({ success: true, message: 'Goal deleted' });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const contributeToGoal = async (req: AuthRequest, res: Response) => {
    const { amount } = req.body;
    try {
        const goal = await prisma.financialGoal.update({
            where: { id: req.params.goalId as string, user_id: req.user?.userId },
            data: {
                saved_amount: { increment: Number(amount) }
            }
        });

        if (goal.saved_amount >= goal.target_amount) {
            await prisma.financialGoal.update({
                where: { id: goal.id },
                data: { is_completed: true }
            });
        }

        res.json({ success: true, data: goal, message: 'Contribution added successfully' });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

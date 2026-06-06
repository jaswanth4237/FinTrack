import { Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { AuthRequest } from '../middleware/authMiddleware';

const prisma = new PrismaClient();

export const getCategories = async (req: AuthRequest, res: Response) => {
    try {
        const categories = await prisma.category.findMany({
            where: {
                OR: [
                    { user_id: req.user?.userId },
                    { is_default: true }
                ]
            }
        });
        res.json({ success: true, data: categories });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const createCategory = async (req: AuthRequest, res: Response) => {
    const { category_name, category_type, color, icon } = req.body;
    try {
        const category = await prisma.category.create({
            data: {
                category_name,
                category_type,
                color,
                icon,
                user_id: req.user!.userId,
                is_default: false
            }
        });
        res.status(201).json({ success: true, data: category });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const updateCategory = async (req: AuthRequest, res: Response) => {
    try {
        const category = await prisma.category.update({
            where: { id: req.params.categoryId as string, user_id: req.user?.userId, is_default: false },
            data: req.body
        });
        res.json({ success: true, data: category });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const deleteCategory = async (req: AuthRequest, res: Response) => {
    try {
        await prisma.category.delete({
            where: { id: req.params.categoryId as string, user_id: req.user?.userId, is_default: false }
        });
        res.json({ success: true, message: 'Category deleted' });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

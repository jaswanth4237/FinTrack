import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';
import { generateAccessToken, generateRefreshToken } from '../utils/tokenUtils';
import { z } from 'zod';
import { AuthRequest } from '../middleware/authMiddleware';

const prisma = new PrismaClient();

const registerSchema = z.object({
    email: z.string().email(),
    password: z.string().min(8),
    full_name: z.string().min(2),
    currency_code: z.string().optional()
});

const defaultCategories = [
    { category_name: 'Food & Dining', category_type: 'expense', icon: 'restaurant', color: '#FF6B6B' },
    { category_name: 'Transportation', category_type: 'expense', icon: 'car', color: '#4ECDC4' },
    { category_name: 'Shopping', category_type: 'expense', icon: 'shopping-bag', color: '#45B7D1' },
    { category_name: 'Entertainment', category_type: 'expense', icon: 'film', color: '#96CEB4' },
    { category_name: 'Healthcare', category_type: 'expense', icon: 'heart', color: '#FF8B94' },
    { category_name: 'Utilities', category_type: 'expense', icon: 'zap', color: '#DDA0DD' },
    { category_name: 'Salary', category_type: 'income', icon: 'briefcase', color: '#88D8A4' },
    { category_name: 'Freelance', category_type: 'income', icon: 'code', color: '#F7DC6F' },
    { category_name: 'Investment', category_type: 'income', icon: 'trending-up', color: '#82E0AA' },
];

export const register = async (req: Request, res: Response) => {
    try {
        const validatedData = registerSchema.parse(req.body);
        const existingUser = await prisma.user.findUnique({ where: { email: validatedData.email } });

        if (existingUser) {
            return res.status(400).json({ success: false, error: 'BAD_REQUEST', message: 'Email already exists' });
        }

        const passwordHash = await bcrypt.hash(validatedData.password, 12);

        const user = await prisma.user.create({
            data: {
                email: validatedData.email,
                password_hash: passwordHash,
                full_name: validatedData.full_name,
                currency_code: validatedData.currency_code || 'INR',
                categories: {
                    create: defaultCategories.map(cat => ({ ...cat, is_default: true }))
                }
            }
        });

        const accessToken = generateAccessToken(user.id);
        const refreshToken = generateRefreshToken();

        await prisma.refreshToken.create({
            data: {
                token: refreshToken,
                user_id: user.id,
                expires_at: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000) // 7 days
            }
        });

        res.status(201).json({
            success: true,
            data: {
                user: {
                    id: user.id,
                    email: user.email,
                    full_name: user.full_name,
                    currency_code: user.currency_code
                },
                access_token: accessToken,
                refresh_token: refreshToken
            },
            message: 'User registered successfully'
        });
    } catch (error: any) {
        res.status(400).json({ success: false, error: 'VALIDATION_ERROR', message: error.message });
    }
};

export const login = async (req: Request, res: Response) => {
    const { email, password } = req.body;
    try {
        const user = await prisma.user.findUnique({ where: { email } });
        if (!user || !(await bcrypt.compare(password, user.password_hash))) {
            return res.status(401).json({ success: false, error: 'UNAUTHORIZED', message: 'Invalid credentials' });
        }

        const accessToken = generateAccessToken(user.id);
        const refreshToken = generateRefreshToken();

        await prisma.refreshToken.create({
            data: {
                token: refreshToken,
                user_id: user.id,
                expires_at: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000)
            }
        });

        res.json({
            success: true,
            data: {
                user: {
                    id: user.id,
                    email: user.email,
                    full_name: user.full_name,
                    currency_code: user.currency_code
                },
                access_token: accessToken,
                refresh_token: refreshToken
            },
            message: 'Login successful'
        });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const refresh = async (req: Request, res: Response) => {
    const { refresh_token } = req.body;
    if (!refresh_token) {
        return res.status(400).json({ success: false, error: 'BAD_REQUEST', message: 'Refresh token is required' });
    }

    try {
        const tokenRecord = await prisma.refreshToken.findUnique({
            where: { token: refresh_token },
            include: { user: true }
        });

        if (!tokenRecord || tokenRecord.expires_at < new Date()) {
            return res.status(401).json({ success: false, error: 'UNAUTHORIZED', message: 'Invalid or expired refresh token' });
        }

        const newAccessToken = generateAccessToken(tokenRecord.user_id);
        res.json({
            success: true,
            data: {
                access_token: newAccessToken
            },
            message: 'Token refreshed'
        });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const logout = async (req: AuthRequest, res: Response) => {
    const { refresh_token } = req.body;
    try {
        if (refresh_token) {
            await prisma.refreshToken.deleteMany({
                where: { token: refresh_token, user_id: req.user?.userId }
            });
        }
        res.json({ success: true, message: 'Logout successful' });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const getMe = async (req: AuthRequest, res: Response) => {
    try {
        const user = await prisma.user.findUnique({ where: { id: req.user?.userId } });
        if (!user) {
            return res.status(404).json({ success: false, error: 'NOT_FOUND', message: 'User not found' });
        }
        res.json({
            success: true,
            data: {
                user: {
                    id: user.id,
                    email: user.email,
                    full_name: user.full_name,
                    currency_code: user.currency_code,
                    monthly_income: user.monthly_income,
                    avatar_url: user.avatar_url,
                    is_verified: user.is_verified
                }
            }
        });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const updateMe = async (req: AuthRequest, res: Response) => {
    const { full_name, monthly_income, currency_code } = req.body;
    try {
        const user = await prisma.user.update({
            where: { id: req.user?.userId },
            data: {
                full_name,
                monthly_income,
                currency_code
            }
        });
        res.json({
            success: true,
            data: { user },
            message: 'Profile updated'
        });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

export const updatePushToken = async (req: AuthRequest, res: Response) => {
    const { push_token } = req.body;
    try {
        await prisma.user.update({
            where: { id: req.user?.userId },
            data: { push_token }
        });
        res.json({ success: true, message: 'Push token updated' });
    } catch (error: any) {
        res.status(500).json({ success: false, error: 'SERVER_ERROR', message: error.message });
    }
};

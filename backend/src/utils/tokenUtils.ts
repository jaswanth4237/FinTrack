import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';
import crypto from 'crypto';

dotenv.config();

const ACCESS_TOKEN_SECRET = process.env.JWT_ACCESS_SECRET || 'access_secret';
const REFRESH_TOKEN_SECRET = process.env.JWT_REFRESH_SECRET || 'refresh_secret';

export function generateAccessToken(userId: string): string {
    return jwt.sign({ userId }, ACCESS_TOKEN_SECRET, { expiresIn: '15m' });
}

export function generateRefreshToken(): string {
    return crypto.randomBytes(40).toString('hex');
}

export function verifyAccessToken(token: string): { userId: string } | null {
    try {
        const payload = jwt.verify(token, ACCESS_TOKEN_SECRET) as { userId: string };
        return payload;
    } catch (error) {
        return null;
    }
}

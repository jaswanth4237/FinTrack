import { generateAccessToken, verifyAccessToken } from '../utils/tokenUtils';
import jwt from 'jsonwebtoken';

describe('tokenUtils', () => {
    const userId = 'user123';

    it('generateAccessToken should return a non-empty string', () => {
        const token = generateAccessToken(userId);
        expect(token).toBeDefined();
        expect(typeof token).toBe('string');
        expect(token.length).toBeGreaterThan(0);
    });

    it('verifyAccessToken should return an object containing the correct userId for a valid token', () => {
        const token = generateAccessToken(userId);
        const payload = verifyAccessToken(token);
        expect(payload).toBeDefined();
        expect(payload?.userId).toBe(userId);
    });

    it('verifyAccessToken should return null for an expired token', () => {
        const token = jwt.sign({ userId }, process.env.JWT_ACCESS_SECRET || 'access_secret', { expiresIn: '-1s' });
        const payload = verifyAccessToken(token);
        expect(payload).toBeNull();
    });

    it('verifyAccessToken should return null for a tampered token', () => {
        const token = generateAccessToken(userId) + 'tampered';
        const payload = verifyAccessToken(token);
        expect(payload).toBeNull();
    });
});

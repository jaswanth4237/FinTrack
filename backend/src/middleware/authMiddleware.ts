import { Request, Response, NextFunction } from 'express';
import { verifyAccessToken } from '../utils/tokenUtils';

export interface AuthRequest extends Request {
    user?: {
        userId: string;
    };
}

const authenticate = (req: AuthRequest, res: Response, next: NextFunction) => {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return res.status(401).json({
            success: false,
            error: 'UNAUTHORIZED',
            message: 'Access token is missing or invalid'
        });
    }

    const token = authHeader.split(' ')[1];
    const payload = verifyAccessToken(token);

    if (!payload) {
        return res.status(401).json({
            success: false,
            error: 'UNAUTHORIZED',
            message: 'Access token is expired or invalid'
        });
    }

    req.user = payload;
    next();
};

export default authenticate;

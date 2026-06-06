import { Router } from 'express';
import * as authController from '../controllers/authController';
import authenticate from '../middleware/authMiddleware';

const router = Router();

router.post('/register', authController.register);
router.post('/login', authController.login);
router.post('/refresh', authController.refresh);
router.post('/logout', authenticate, authController.logout);
router.get('/me', authenticate, authController.getMe);
router.patch('/me', authenticate, authController.updateMe);
router.post('/push-token', authenticate, authController.updatePushToken);

export default router;

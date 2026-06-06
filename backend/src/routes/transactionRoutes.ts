import { Router } from 'express';
import * as transactionController from '../controllers/transactionController';
import authenticate from '../middleware/authMiddleware';

const router = Router();

router.use(authenticate);

router.get('/', transactionController.getTransactions);
router.post('/', transactionController.createTransaction);
router.get('/summary/monthly', transactionController.getMonthlySummary);
router.get('/summary/category-breakdown', transactionController.getCategoryBreakdown);
router.get('/:transactionId', transactionController.getTransaction);
router.patch('/:transactionId', transactionController.updateTransaction);
router.delete('/:transactionId', transactionController.deleteTransaction);

export default router;

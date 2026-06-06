import { Router } from 'express';
import * as budgetController from '../controllers/budgetController';
import authenticate from '../middleware/authMiddleware';

const router = Router();

router.use(authenticate);

router.get('/', budgetController.getBudgets);
router.post('/', budgetController.createBudget);
router.get('/:budgetId', budgetController.getBudget);
router.patch('/:budgetId', budgetController.updateBudget);
router.delete('/:budgetId', budgetController.deleteBudget);

export default router;

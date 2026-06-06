import { Router } from 'express';
import * as goalController from '../controllers/goalController';
import authenticate from '../middleware/authMiddleware';

const router = Router();

router.use(authenticate);

router.get('/', goalController.getGoals);
router.post('/', goalController.createGoal);
router.get('/:goalId', goalController.getGoal);
router.patch('/:goalId', goalController.updateGoal);
router.delete('/:goalId', goalController.deleteGoal);
router.post('/:goalId/contribute', goalController.contributeToGoal);

export default router;

import { Router } from 'express';
import * as accountController from '../controllers/accountController';
import authenticate from '../middleware/authMiddleware';

const router = Router();

router.use(authenticate);

router.get('/', accountController.getAccounts);
router.post('/', accountController.createAccount);
router.get('/:accountId', accountController.getAccount);
router.patch('/:accountId', accountController.updateAccount);
router.delete('/:accountId', accountController.deleteAccount);
router.get('/:accountId/balance-history', accountController.getBalanceHistory);

export default router;

import { Router } from 'express';
import * as categoryController from '../controllers/categoryController';
import authenticate from '../middleware/authMiddleware';

const router = Router();

router.use(authenticate);

router.get('/', categoryController.getCategories);
router.post('/', categoryController.createCategory);
router.patch('/:categoryId', categoryController.updateCategory);
router.delete('/:categoryId', categoryController.deleteCategory);

export default router;

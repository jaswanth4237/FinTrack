import { calculateAccountBalance } from '../services/transactionService';
import { PrismaClient } from '@prisma/client';

jest.mock('@prisma/client', () => {
    const mPrisma = {
        transaction: {
            findMany: jest.fn(),
        },
    };
    return { PrismaClient: jest.fn(() => mPrisma) };
});

const prisma = new PrismaClient();

describe('transactionService', () => {
    it('should return 0 for an account with no transactions', async () => {
        (prisma.transaction.findMany as jest.Mock).mockResolvedValue([]);
        const balance = await calculateAccountBalance('acc1');
        expect(balance).toBe(0);
    });

    it('should correctly sum income transactions only', async () => {
        (prisma.transaction.findMany as jest.Mock).mockResolvedValue([
            { amount: 100, transaction_type: 'income' },
            { amount: 200, transaction_type: 'income' },
        ]);
        const balance = await calculateAccountBalance('acc1');
        expect(balance).toBe(300);
    });

    it('should correctly subtract expense transactions from income', async () => {
        (prisma.transaction.findMany as jest.Mock).mockResolvedValue([
            { amount: 500, transaction_type: 'income' },
            { amount: 200, transaction_type: 'expense' },
        ]);
        const balance = await calculateAccountBalance('acc1');
        expect(balance).toBe(300);
    });

    it('should return correct balance with a mix of income and expense transactions', async () => {
        (prisma.transaction.findMany as jest.Mock).mockResolvedValue([
            { amount: 1000, transaction_type: 'income' },
            { amount: 200, transaction_type: 'expense' },
            { amount: 300, transaction_type: 'income' },
            { amount: 100, transaction_type: 'expense' },
        ]);
        const balance = await calculateAccountBalance('acc1');
        expect(balance).toBe(1000);
    });
});

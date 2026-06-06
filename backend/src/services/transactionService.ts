import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function calculateAccountBalance(accountId: string): Promise<number> {
    const transactions = await prisma.transaction.findMany({
        where: { account_id: accountId }
    });

    const balance = transactions.reduce((acc, transaction) => {
        if (transaction.transaction_type === 'income') {
            return acc + transaction.amount;
        } else if (transaction.transaction_type === 'expense') {
            return acc - transaction.amount;
        }
        return acc;
    }, 0);

    return balance;
}

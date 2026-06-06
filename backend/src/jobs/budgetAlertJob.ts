import cron from 'node-cron';
import { PrismaClient } from '@prisma/client';
import admin from 'firebase-admin';

const prisma = new PrismaClient();

export function scheduleBudgetAlerts(): void {
    cron.schedule('0 0 * * *', async () => {
        console.log('Running budget alert job...');
        const budgets = await prisma.budget.findMany({
            where: { is_active: true },
            include: { user: true }
        });

        for (const budget of budgets) {
            const percentage = (budget.spent_amount / budget.amount_limit) * 100;
            if (percentage >= budget.alert_threshold) {
                if (budget.user.push_token) {
                    try {
                        const roundedPercentage = Math.round(percentage);
                        await admin.messaging().send({
                            token: budget.user.push_token,
                            notification: {
                                title: 'Budget Alert',
                                body: `Your ${budget.budget_name} budget has reached ${roundedPercentage}% of the limit`
                            },
                            data: {
                                type: 'budget_alert',
                                budgetId: budget.id
                            }
                        });
                    } catch (error) {
                        console.error(`Failed to send notification to user ${budget.user_id}:`, error);
                    }
                }
            }
        }
    });
}

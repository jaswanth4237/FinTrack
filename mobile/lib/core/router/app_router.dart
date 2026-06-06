
import 'package:go_router/go_router.dart';
import 'package:mobile/core/router/route_names.dart';
import 'package:mobile/features/auth/cubit/auth_cubit.dart';
import 'package:mobile/core/di/injection.dart';
import 'package:mobile/features/auth/screens/login_screen.dart';
import 'package:mobile/features/auth/screens/register_screen.dart';
import 'package:mobile/features/dashboard/screens/dashboard_screen.dart';
import 'package:mobile/features/transactions/screens/transactions_screen.dart';
import 'package:mobile/features/transactions/screens/add_transaction_screen.dart';
import 'package:mobile/features/budgets/screens/budgets_screen.dart';
import 'package:mobile/features/goals/screens/goals_screen.dart';
import 'package:mobile/features/profile/screens/profile_screen.dart';
import 'package:mobile/features/profile/screens/analytics_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: kDashboardRoute,
  redirect: (context, state) {
    final authCubit = getIt<AuthCubit>();
    final isAuthenticated = authCubit.state.isAuthenticated;
    final isLoggingIn = state.matchedLocation == kLoginRoute || state.matchedLocation == kRegisterRoute;

    if (!isAuthenticated && !isLoggingIn) return kLoginRoute;
    if (isAuthenticated && isLoggingIn) return kDashboardRoute;
    return null;
  },
  routes: [
    GoRoute(path: kLoginRoute, builder: (context, state) => const LoginScreen()),
    GoRoute(path: kRegisterRoute, builder: (context, state) => const RegisterScreen()),
    GoRoute(path: kDashboardRoute, builder: (context, state) => const DashboardScreen()),
    GoRoute(path: kTransactionsRoute, builder: (context, state) => const TransactionsScreen()),
    GoRoute(path: kAddTransactionRoute, builder: (context, state) => const AddTransactionScreen()),
    GoRoute(path: kBudgetsRoute, builder: (context, state) => const BudgetsScreen()),
    GoRoute(path: kGoalsRoute, builder: (context, state) => const GoalsScreen()),
    GoRoute(path: kProfileRoute, builder: (context, state) => const ProfileScreen()),
    GoRoute(path: kAnalyticsRoute, builder: (context, state) => const AnalyticsScreen()),
  ],
);

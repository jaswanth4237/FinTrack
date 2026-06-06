import 'package:drift/drift.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/database/tables/budgets_table.dart';

part 'budgets_dao.g.dart';

@DriftAccessor(tables: [BudgetsTable])
class BudgetsDao extends DatabaseAccessor<AppDatabase> with _$BudgetsDaoMixin {
  BudgetsDao(super.db);

  Future<List<BudgetsTableData>> getAllBudgets() => select(budgetsTable).get();
  Future<int> insertBudget(BudgetsTableData data) => into(budgetsTable).insert(data);
}

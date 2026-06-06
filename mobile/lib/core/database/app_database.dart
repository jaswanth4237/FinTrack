import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:mobile/core/database/tables/transactions_table.dart';
import 'package:mobile/core/database/tables/accounts_table.dart';
import 'package:mobile/core/database/tables/categories_table.dart';
import 'package:mobile/core/database/tables/budgets_table.dart';
import 'package:mobile/core/database/tables/goals_table.dart';
import 'package:mobile/core/database/daos/transactions_dao.dart';
import 'package:mobile/core/database/daos/accounts_dao.dart';
import 'package:mobile/core/database/daos/categories_dao.dart';
import 'package:mobile/core/database/daos/budgets_dao.dart';
import 'package:mobile/core/database/daos/goals_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    TransactionsTable,
    AccountsTable,
    CategoriesTable,
    BudgetsTable,
    GoalsTable,
  ],
  daos: [
    TransactionsDao,
    AccountsDao,
    CategoriesDao,
    BudgetsDao,
    GoalsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'fintrack.sqlite'));
    return NativeDatabase(file);
  });
}

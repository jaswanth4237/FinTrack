import 'package:drift/drift.dart';

class BudgetsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get categoryId => text()();
  TextColumn get budgetName => text()();
  RealColumn get amountLimit => real()();
  RealColumn get spentAmount => real().withDefault(const Constant(0))();
  TextColumn get periodType => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  RealColumn get alertThreshold => real().withDefault(const Constant(80))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  TextColumn get syncStatus => text().withDefault(const Constant('synced'))();
  IntColumn get syncedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

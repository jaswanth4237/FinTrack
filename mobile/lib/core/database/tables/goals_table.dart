import 'package:drift/drift.dart';

class GoalsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get goalName => text()();
  RealColumn get targetAmount => real()();
  RealColumn get savedAmount => real().withDefault(const Constant(0))();
  DateTimeColumn get targetDate => dateTime()();
  TextColumn get goalColor => text()();
  TextColumn get goalIcon => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  TextColumn get syncStatus => text().withDefault(const Constant('synced'))();
  IntColumn get syncedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

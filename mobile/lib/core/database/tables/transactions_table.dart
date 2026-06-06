import 'package:drift/drift.dart';

class TransactionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get accountId => text()();
  TextColumn get categoryId => text()();
  RealColumn get amount => real()();
  TextColumn get transactionType => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get transactionDate => dateTime()();
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  TextColumn get recurrenceRule => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  
  // Sync columns
  TextColumn get syncStatus => text().withDefault(const Constant('synced'))(); // synced, pending, failed
  IntColumn get syncedAt => integer().nullable()(); // Unix timestamp in ms

  @override
  Set<Column> get primaryKey => {id};
}

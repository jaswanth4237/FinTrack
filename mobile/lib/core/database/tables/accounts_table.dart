import 'package:drift/drift.dart';

class AccountsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get accountName => text()();
  TextColumn get accountType => text()();
  RealColumn get balance => real().withDefault(const Constant(0))();
  TextColumn get color => text()();
  TextColumn get icon => text()();
  BoolColumn get isPrimary => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  TextColumn get syncStatus => text().withDefault(const Constant('synced'))();
  IntColumn get syncedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

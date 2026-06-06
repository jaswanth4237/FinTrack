import 'package:drift/drift.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/database/tables/transactions_table.dart';

part 'transactions_dao.g.dart';

@DriftAccessor(tables: [TransactionsTable])
class TransactionsDao extends DatabaseAccessor<AppDatabase> with _$TransactionsDaoMixin {
  TransactionsDao(super.db);

  Future<List<TransactionsTableData>> getAllTransactions() => select(transactionsTable).get();
  Future<int> insertTransaction(TransactionsTableData data) => into(transactionsTable).insert(data);
  Future updateTransaction(TransactionsTableData data) => update(transactionsTable).replace(data);
  Future deleteTransaction(String id) => (delete(transactionsTable)..where((t) => t.id.equals(id))).go();
  Future<List<TransactionsTableData>> getPendingTransactions() => 
    (select(transactionsTable)..where((t) => t.syncStatus.equals('pending'))).get();
}

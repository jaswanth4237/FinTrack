import 'package:drift/drift.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/database/tables/accounts_table.dart';

part 'accounts_dao.g.dart';

@DriftAccessor(tables: [AccountsTable])
class AccountsDao extends DatabaseAccessor<AppDatabase> with _$AccountsDaoMixin {
  AccountsDao(super.db);

  Future<List<AccountsTableData>> getAllAccounts() => select(accountsTable).get();
  Future<int> insertAccount(AccountsTableData data) => into(accountsTable).insert(data);
  Future updateAccount(AccountsTableData data) => update(accountsTable).replace(data);
  Future deleteAccount(String id) => (delete(accountsTable)..where((t) => t.id.equals(id))).go();
}

import 'package:drift/drift.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/database/tables/categories_table.dart';

part 'categories_dao.g.dart';

@DriftAccessor(tables: [CategoriesTable])
class CategoriesDao extends DatabaseAccessor<AppDatabase> with _$CategoriesDaoMixin {
  CategoriesDao(super.db);

  Future<List<CategoriesTableData>> getAllCategories() => select(categoriesTable).get();
  Future<int> insertCategory(CategoriesTableData data) => into(categoriesTable).insert(data);
}

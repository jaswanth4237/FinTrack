import 'package:drift/drift.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/database/tables/goals_table.dart';

part 'goals_dao.g.dart';

@DriftAccessor(tables: [GoalsTable])
class GoalsDao extends DatabaseAccessor<AppDatabase> with _$GoalsDaoMixin {
  GoalsDao(super.db);

  Future<List<GoalsTableData>> getAllGoals() => select(goalsTable).get();
  Future<int> insertGoal(GoalsTableData data) => into(goalsTable).insert(data);
}

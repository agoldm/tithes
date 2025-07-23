import 'package:tithes/data/models/income.dart';

abstract class IncomeRepository {
  Future<void> addIncome(Income income);
  Future<void> updateIncome(Income income);
  Future<void> deleteIncome(String id);
  List<Income> getAllIncomes();
  List<Income> getIncomesByMonth(DateTime month);
  double getTotalIncomeForMonth(DateTime month);
  double getTotalIncome();
}
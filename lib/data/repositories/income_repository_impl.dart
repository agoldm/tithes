import 'package:tithes/core/extensions/date_extensions.dart';
import 'package:tithes/data/datasources/local_data_source.dart';
import 'package:tithes/data/models/income.dart';
import 'package:tithes/domain/repositories/income_repository.dart';

class IncomeRepositoryImpl implements IncomeRepository {
  @override
  Future<void> addIncome(Income income) async {
    await LocalDataSource.addIncome(income);
  }

  @override
  Future<void> updateIncome(Income income) async {
    await LocalDataSource.updateIncome(income);
  }

  @override
  Future<void> deleteIncome(String id) async {
    await LocalDataSource.deleteIncome(id);
  }

  @override
  List<Income> getAllIncomes() {
    return LocalDataSource.getAllIncomes();
  }

  @override
  List<Income> getIncomesByMonth(DateTime month) {
    final allIncomes = getAllIncomes();
    return allIncomes.where((income) => income.date.isSameMonth(month)).toList();
  }

  @override
  double getTotalIncomeForMonth(DateTime month) {
    final monthlyIncomes = getIncomesByMonth(month);
    return monthlyIncomes.fold(0.0, (total, income) => total + income.amount);
  }

  @override
  double getTotalIncome() {
    final allIncomes = getAllIncomes();
    return allIncomes.fold(0.0, (total, income) => total + income.amount);
  }
}
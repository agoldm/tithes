import 'package:equatable/equatable.dart';
import 'package:tithes/data/models/income.dart';

abstract class IncomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadIncomes extends IncomeEvent {}

class AddIncome extends IncomeEvent {
  final Income income;

  AddIncome(this.income);

  @override
  List<Object?> get props => [income];
}

class UpdateIncome extends IncomeEvent {
  final Income income;

  UpdateIncome(this.income);

  @override
  List<Object?> get props => [income];
}

class DeleteIncome extends IncomeEvent {
  final String id;

  DeleteIncome(this.id);

  @override
  List<Object?> get props => [id];
}

class FilterIncomesByMonth extends IncomeEvent {
  final DateTime? month;

  FilterIncomesByMonth(this.month);

  @override
  List<Object?> get props => [month];
}
import 'package:equatable/equatable.dart';
import 'package:tithes/data/models/income.dart';

abstract class IncomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class IncomeInitial extends IncomeState {}

class IncomeLoading extends IncomeState {}

class IncomeLoaded extends IncomeState {
  final List<Income> incomes;
  final List<Income> filteredIncomes;
  final DateTime? selectedMonth;
  final double totalIncome;
  final double monthlyIncome;

  IncomeLoaded({
    required this.incomes,
    required this.filteredIncomes,
    this.selectedMonth,
    required this.totalIncome,
    required this.monthlyIncome,
  });

  @override
  List<Object?> get props => [
    incomes,
    filteredIncomes,
    selectedMonth,
    totalIncome,
    monthlyIncome,
  ];

  IncomeLoaded copyWith({
    List<Income>? incomes,
    List<Income>? filteredIncomes,
    DateTime? selectedMonth,
    double? totalIncome,
    double? monthlyIncome,
    bool clearSelectedMonth = false,
  }) {
    return IncomeLoaded(
      incomes: incomes ?? this.incomes,
      filteredIncomes: filteredIncomes ?? this.filteredIncomes,
      selectedMonth: clearSelectedMonth ? null : (selectedMonth ?? this.selectedMonth),
      totalIncome: totalIncome ?? this.totalIncome,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
    );
  }
}

class IncomeError extends IncomeState {
  final String message;

  IncomeError(this.message);

  @override
  List<Object?> get props => [message];
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tithes/core/extensions/date_extensions.dart';
import 'package:tithes/domain/repositories/income_repository.dart';
import 'income_event.dart';
import 'income_state.dart';

class IncomeBloc extends Bloc<IncomeEvent, IncomeState> {
  final IncomeRepository incomeRepository;

  IncomeBloc({required this.incomeRepository}) : super(IncomeInitial()) {
    on<LoadIncomes>(_onLoadIncomes);
    on<AddIncome>(_onAddIncome);
    on<UpdateIncome>(_onUpdateIncome);
    on<DeleteIncome>(_onDeleteIncome);
    on<FilterIncomesByMonth>(_onFilterIncomesByMonth);
  }

  void _onLoadIncomes(LoadIncomes event, Emitter<IncomeState> emit) {
    try {
      emit(IncomeLoading());
      final incomes = incomeRepository.getAllIncomes();
      final totalIncome = incomeRepository.getTotalIncome();
      
      emit(IncomeLoaded(
        incomes: incomes,
        filteredIncomes: incomes,
        totalIncome: totalIncome,
        monthlyIncome: totalIncome,
      ));
    } catch (e) {
      emit(IncomeError(e.toString()));
    }
  }

  void _onAddIncome(AddIncome event, Emitter<IncomeState> emit) async {
    try {
      await incomeRepository.addIncome(event.income);
      add(LoadIncomes());
    } catch (e) {
      emit(IncomeError(e.toString()));
    }
  }

  void _onUpdateIncome(UpdateIncome event, Emitter<IncomeState> emit) async {
    try {
      await incomeRepository.updateIncome(event.income);
      add(LoadIncomes());
    } catch (e) {
      emit(IncomeError(e.toString()));
    }
  }

  void _onDeleteIncome(DeleteIncome event, Emitter<IncomeState> emit) async {
    try {
      await incomeRepository.deleteIncome(event.id);
      add(LoadIncomes());
    } catch (e) {
      emit(IncomeError(e.toString()));
    }
  }

  void _onFilterIncomesByMonth(FilterIncomesByMonth event, Emitter<IncomeState> emit) {
    if (state is IncomeLoaded) {
      final currentState = state as IncomeLoaded;
      
      if (event.month == null) {
        emit(currentState.copyWith(
          filteredIncomes: currentState.incomes,
          monthlyIncome: currentState.totalIncome,
          clearSelectedMonth: true,
        ));
      } else {
        final filteredIncomes = currentState.incomes
            .where((income) => income.date.isSameMonth(event.month!))
            .toList();
        final monthlyIncome = incomeRepository.getTotalIncomeForMonth(event.month!);
        
        emit(currentState.copyWith(
          filteredIncomes: filteredIncomes,
          selectedMonth: event.month,
          monthlyIncome: monthlyIncome,
        ));
      }
    }
  }
}
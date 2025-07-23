import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tithes/core/services/currency_service.dart';
import 'currency_event.dart';
import 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final CurrencyService currencyService;

  CurrencyBloc({required this.currencyService}) : super(CurrencyInitial()) {
    on<LoadCurrency>(_onLoadCurrency);
    on<ChangeCurrency>(_onChangeCurrency);
  }

  void _onLoadCurrency(LoadCurrency event, Emitter<CurrencyState> emit) async {
    try {
      emit(CurrencyLoading());
      await currencyService.initialize();
      emit(CurrencyLoaded(selectedCurrency: currencyService.currentCurrency));
    } catch (e) {
      emit(CurrencyError(e.toString()));
    }
  }

  void _onChangeCurrency(ChangeCurrency event, Emitter<CurrencyState> emit) async {
    try {
      await currencyService.setCurrency(event.currency);
      if (state is CurrencyLoaded) {
        emit((state as CurrencyLoaded).copyWith(selectedCurrency: event.currency));
      } else {
        emit(CurrencyLoaded(selectedCurrency: event.currency));
      }
    } catch (e) {
      emit(CurrencyError(e.toString()));
    }
  }
}
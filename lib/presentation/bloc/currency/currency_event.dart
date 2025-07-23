import 'package:equatable/equatable.dart';
import 'package:tithes/core/constants/currency_constants.dart';

abstract class CurrencyEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCurrency extends CurrencyEvent {}

class ChangeCurrency extends CurrencyEvent {
  final Currency currency;

  ChangeCurrency(this.currency);

  @override
  List<Object?> get props => [currency];
}
import 'package:equatable/equatable.dart';
import 'package:tithes/core/constants/currency_constants.dart';

abstract class CurrencyState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CurrencyInitial extends CurrencyState {}

class CurrencyLoading extends CurrencyState {}

class CurrencyLoaded extends CurrencyState {
  final Currency selectedCurrency;

  CurrencyLoaded({required this.selectedCurrency});

  @override
  List<Object?> get props => [selectedCurrency];

  CurrencyLoaded copyWith({Currency? selectedCurrency}) {
    return CurrencyLoaded(
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
    );
  }
}

class CurrencyError extends CurrencyState {
  final String message;

  CurrencyError(this.message);

  @override
  List<Object?> get props => [message];
}
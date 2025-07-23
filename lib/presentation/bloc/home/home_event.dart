import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMaaserSummary extends HomeEvent {}

class SelectMonth extends HomeEvent {
  final DateTime month;

  SelectMonth(this.month);

  @override
  List<Object?> get props => [month];
}

class RefreshData extends HomeEvent {}
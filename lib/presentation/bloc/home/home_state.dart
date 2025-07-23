import 'package:equatable/equatable.dart';
import 'package:tithes/domain/entities/maaser_summary.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final MaaserSummary summary;

  HomeLoaded({required this.summary});

  @override
  List<Object?> get props => [summary];
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
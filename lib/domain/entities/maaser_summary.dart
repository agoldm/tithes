import 'package:equatable/equatable.dart';

class MaaserSummary extends Equatable {
  final double totalIncome;
  final double totalDonations;
  final double maaserRequired;
  final double maaserRemaining;
  final DateTime month;

  const MaaserSummary({
    required this.totalIncome,
    required this.totalDonations,
    required this.maaserRequired,
    required this.maaserRemaining,
    required this.month,
  });

  @override
  List<Object?> get props => [
    totalIncome,
    totalDonations,
    maaserRequired,
    maaserRemaining,
    month,
  ];
}
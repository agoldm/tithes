import 'package:equatable/equatable.dart';
import 'package:tithes/data/models/donation.dart';

abstract class DonationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DonationInitial extends DonationState {}

class DonationLoading extends DonationState {}

class DonationLoaded extends DonationState {
  final List<Donation> donations;
  final List<Donation> filteredDonations;
  final DateTime? selectedMonth;
  final double totalDonations;
  final double monthlyDonations;

  DonationLoaded({
    required this.donations,
    required this.filteredDonations,
    this.selectedMonth,
    required this.totalDonations,
    required this.monthlyDonations,
  });

  @override
  List<Object?> get props => [
    donations,
    filteredDonations,
    selectedMonth,
    totalDonations,
    monthlyDonations,
  ];

  DonationLoaded copyWith({
    List<Donation>? donations,
    List<Donation>? filteredDonations,
    DateTime? selectedMonth,
    double? totalDonations,
    double? monthlyDonations,
    bool clearSelectedMonth = false,
  }) {
    return DonationLoaded(
      donations: donations ?? this.donations,
      filteredDonations: filteredDonations ?? this.filteredDonations,
      selectedMonth: clearSelectedMonth ? null : (selectedMonth ?? this.selectedMonth),
      totalDonations: totalDonations ?? this.totalDonations,
      monthlyDonations: monthlyDonations ?? this.monthlyDonations,
    );
  }
}

class DonationError extends DonationState {
  final String message;

  DonationError(this.message);

  @override
  List<Object?> get props => [message];
}
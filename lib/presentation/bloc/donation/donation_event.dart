import 'package:equatable/equatable.dart';
import 'package:tithes/data/models/donation.dart';

abstract class DonationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDonations extends DonationEvent {}

class AddDonation extends DonationEvent {
  final Donation donation;

  AddDonation(this.donation);

  @override
  List<Object?> get props => [donation];
}

class UpdateDonation extends DonationEvent {
  final Donation donation;

  UpdateDonation(this.donation);

  @override
  List<Object?> get props => [donation];
}

class DeleteDonation extends DonationEvent {
  final String id;

  DeleteDonation(this.id);

  @override
  List<Object?> get props => [id];
}

class FilterDonationsByMonth extends DonationEvent {
  final DateTime? month;

  FilterDonationsByMonth(this.month);

  @override
  List<Object?> get props => [month];
}
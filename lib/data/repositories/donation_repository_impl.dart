import 'package:tithes/core/extensions/date_extensions.dart';
import 'package:tithes/data/datasources/local_data_source.dart';
import 'package:tithes/data/models/donation.dart';
import 'package:tithes/domain/repositories/donation_repository.dart';

class DonationRepositoryImpl implements DonationRepository {
  @override
  Future<void> addDonation(Donation donation) async {
    await LocalDataSource.addDonation(donation);
  }

  @override
  Future<void> updateDonation(Donation donation) async {
    await LocalDataSource.updateDonation(donation);
  }

  @override
  Future<void> deleteDonation(String id) async {
    await LocalDataSource.deleteDonation(id);
  }

  @override
  List<Donation> getAllDonations() {
    return LocalDataSource.getAllDonations();
  }

  @override
  List<Donation> getDonationsByMonth(DateTime month) {
    final allDonations = getAllDonations();
    return allDonations.where((donation) => donation.date.isSameMonth(month)).toList();
  }

  @override
  double getTotalDonationsForMonth(DateTime month) {
    final monthlyDonations = getDonationsByMonth(month);
    return monthlyDonations.fold(0.0, (total, donation) => total + donation.amount);
  }

  @override
  double getTotalDonations() {
    final allDonations = getAllDonations();
    return allDonations.fold(0.0, (total, donation) => total + donation.amount);
  }
}
import 'package:tithes/data/models/donation.dart';

abstract class DonationRepository {
  Future<void> addDonation(Donation donation);
  Future<void> updateDonation(Donation donation);
  Future<void> deleteDonation(String id);
  List<Donation> getAllDonations();
  List<Donation> getDonationsByMonth(DateTime month);
  double getTotalDonationsForMonth(DateTime month);
  double getTotalDonations();
}
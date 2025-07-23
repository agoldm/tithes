import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tithes/core/extensions/date_extensions.dart';
import 'package:tithes/domain/repositories/donation_repository.dart';
import 'donation_event.dart';
import 'donation_state.dart';

class DonationBloc extends Bloc<DonationEvent, DonationState> {
  final DonationRepository donationRepository;

  DonationBloc({required this.donationRepository}) : super(DonationInitial()) {
    on<LoadDonations>(_onLoadDonations);
    on<AddDonation>(_onAddDonation);
    on<UpdateDonation>(_onUpdateDonation);
    on<DeleteDonation>(_onDeleteDonation);
    on<FilterDonationsByMonth>(_onFilterDonationsByMonth);
  }

  void _onLoadDonations(LoadDonations event, Emitter<DonationState> emit) {
    try {
      emit(DonationLoading());
      final donations = donationRepository.getAllDonations();
      final totalDonations = donationRepository.getTotalDonations();
      
      emit(DonationLoaded(
        donations: donations,
        filteredDonations: donations,
        totalDonations: totalDonations,
        monthlyDonations: totalDonations,
      ));
    } catch (e) {
      emit(DonationError(e.toString()));
    }
  }

  void _onAddDonation(AddDonation event, Emitter<DonationState> emit) async {
    try {
      await donationRepository.addDonation(event.donation);
      add(LoadDonations());
    } catch (e) {
      emit(DonationError(e.toString()));
    }
  }

  void _onUpdateDonation(UpdateDonation event, Emitter<DonationState> emit) async {
    try {
      await donationRepository.updateDonation(event.donation);
      add(LoadDonations());
    } catch (e) {
      emit(DonationError(e.toString()));
    }
  }

  void _onDeleteDonation(DeleteDonation event, Emitter<DonationState> emit) async {
    try {
      await donationRepository.deleteDonation(event.id);
      add(LoadDonations());
    } catch (e) {
      emit(DonationError(e.toString()));
    }
  }

  void _onFilterDonationsByMonth(FilterDonationsByMonth event, Emitter<DonationState> emit) {
    if (state is DonationLoaded) {
      final currentState = state as DonationLoaded;
      
      if (event.month == null) {
        emit(currentState.copyWith(
          filteredDonations: currentState.donations,
          monthlyDonations: currentState.totalDonations,
          clearSelectedMonth: true,
        ));
      } else {
        final filteredDonations = currentState.donations
            .where((donation) => donation.date.isSameMonth(event.month!))
            .toList();
        final monthlyDonations = donationRepository.getTotalDonationsForMonth(event.month!);
        
        emit(currentState.copyWith(
          filteredDonations: filteredDonations,
          selectedMonth: event.month,
          monthlyDonations: monthlyDonations,
        ));
      }
    }
  }
}
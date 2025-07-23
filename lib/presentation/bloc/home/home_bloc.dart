import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tithes/core/constants/app_constants.dart';
import 'package:tithes/domain/entities/maaser_summary.dart';
import 'package:tithes/domain/repositories/income_repository.dart';
import 'package:tithes/domain/repositories/donation_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IncomeRepository incomeRepository;
  final DonationRepository donationRepository;
  DateTime _selectedMonth = DateTime.now();

  HomeBloc({
    required this.incomeRepository,
    required this.donationRepository,
  }) : super(HomeInitial()) {
    on<LoadMaaserSummary>(_onLoadMaaserSummary);
    on<SelectMonth>(_onSelectMonth);
    on<RefreshData>(_onRefreshData);
  }

  void _onLoadMaaserSummary(LoadMaaserSummary event, Emitter<HomeState> emit) {
    try {
      emit(HomeLoading());
      final summary = _calculateMaaserSummary(_selectedMonth);
      emit(HomeLoaded(summary: summary));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void _onSelectMonth(SelectMonth event, Emitter<HomeState> emit) {
    _selectedMonth = event.month;
    add(LoadMaaserSummary());
  }

  void _onRefreshData(RefreshData event, Emitter<HomeState> emit) {
    add(LoadMaaserSummary());
  }

  MaaserSummary _calculateMaaserSummary(DateTime month) {
    final totalIncome = incomeRepository.getTotalIncomeForMonth(month);
    final totalDonations = donationRepository.getTotalDonationsForMonth(month);
    final maaserRequired = totalIncome * AppConstants.maaserPercentage;
    final maaserRemaining = maaserRequired - totalDonations;

    return MaaserSummary(
      totalIncome: totalIncome,
      totalDonations: totalDonations,
      maaserRequired: maaserRequired,
      maaserRemaining: maaserRemaining,
      month: month,
    );
  }
}
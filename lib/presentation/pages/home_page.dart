import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tithes/core/services/currency_service.dart';
import 'package:tithes/presentation/bloc/currency/currency_bloc.dart';
import 'package:tithes/presentation/bloc/currency/currency_state.dart';
import 'package:tithes/core/extensions/date_extensions.dart';
import 'package:tithes/presentation/bloc/home/home_bloc.dart';
import 'package:tithes/presentation/bloc/home/home_event.dart';
import 'package:tithes/presentation/bloc/home/home_state.dart';
import 'package:tithes/presentation/widgets/month_selector.dart';
import 'package:tithes/presentation/widgets/summary_card.dart';
import 'package:tithes/presentation/widgets/language_selection_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('app_title'.tr()),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _showSettings(context),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => context.read<HomeBloc>().add(RefreshData()),
              ),
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, HomeState state) {
    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
    
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeBloc>().add(RefreshData());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MonthSelector(
              onMonthSelected: (month) {
                context.read<HomeBloc>().add(SelectMonth(month));
              },
            ),
            const SizedBox(height: 16),
            if (state is HomeLoading)
              const Center(child: CircularProgressIndicator())
            else if (state is HomeLoaded)
              _buildSummaryCards(context, state, isTablet)
            else if (state is HomeError)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '${'error'.tr()}: ${state.message}',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('welcome_maaser'.tr()),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, HomeLoaded state, bool isTablet) {
    final summary = state.summary;
    
    return BlocBuilder<CurrencyBloc, CurrencyState>(
      builder: (context, currencyState) {
        final currencyService = CurrencyService.instance;
        
        final cards = [
          SummaryCard(
            title: 'monthly_income'.tr(),
            value: currencyService.formatAmount(summary.totalIncome),
            icon: Icons.trending_up,
            color: Colors.green,
          ),
          SummaryCard(
            title: 'maaser_required'.tr(),
            value: currencyService.formatAmount(summary.maaserRequired),
            icon: Icons.calculate,
            color: Colors.blue,
          ),
          SummaryCard(
            title: 'donations_made'.tr(),
            value: currencyService.formatAmount(summary.totalDonations),
            icon: Icons.volunteer_activism,
            color: Colors.purple,
          ),
          SummaryCard(
            title: 'remaining_to_donate'.tr(),
            value: currencyService.formatAmount(summary.maaserRemaining),
            subtitle: summary.maaserRemaining <= 0 
              ? 'goal_achieved'.tr() 
              : 'keep_going'.tr(),
            icon: Icons.flag,
            color: summary.maaserRemaining <= 0 ? Colors.green : Colors.orange,
          ),
        ];

        if (isTablet) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: cards[0]),
                  Expanded(child: cards[1]),
                ],
              ),
              Row(
                children: [
                  Expanded(child: cards[2]),
                  Expanded(child: cards[3]),
                ],
              ),
            ],
          );
        } else {
          return Column(children: cards);
        }
      },
    );
  }

  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const SettingsDialog(),
    );
  }
}
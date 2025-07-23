import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tithes/core/extensions/date_extensions.dart';
import 'package:tithes/presentation/bloc/home/home_bloc.dart';
import 'package:tithes/presentation/bloc/home/home_event.dart';
import 'package:tithes/presentation/bloc/home/home_state.dart';
import 'package:tithes/presentation/widgets/month_selector.dart';
import 'package:tithes/presentation/widgets/summary_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Maaser Tracker'),
            actions: [
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
                    'Error: ${state.message}',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              )
            else
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Welcome to Maaser Tracker'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, HomeLoaded state, bool isTablet) {
    final summary = state.summary;
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    
    final cards = [
      SummaryCard(
        title: 'Monthly Income',
        value: currencyFormat.format(summary.totalIncome),
        icon: Icons.trending_up,
        color: Colors.green,
      ),
      SummaryCard(
        title: 'Maaser Required (10%)',
        value: currencyFormat.format(summary.maaserRequired),
        icon: Icons.calculate,
        color: Colors.blue,
      ),
      SummaryCard(
        title: 'Donations Made',
        value: currencyFormat.format(summary.totalDonations),
        icon: Icons.volunteer_activism,
        color: Colors.purple,
      ),
      SummaryCard(
        title: 'Remaining to Donate',
        value: currencyFormat.format(summary.maaserRemaining),
        subtitle: summary.maaserRemaining <= 0 
          ? 'Goal achieved! 🎉' 
          : 'Keep going! 💪',
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
  }
}
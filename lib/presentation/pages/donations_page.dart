import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tithes/core/extensions/date_extensions.dart';
import 'package:tithes/data/models/donation.dart';
import 'package:tithes/data/models/category.dart';
import 'package:tithes/presentation/bloc/donation/donation_bloc.dart';
import 'package:tithes/presentation/bloc/donation/donation_event.dart';
import 'package:tithes/presentation/bloc/donation/donation_state.dart';
import 'package:tithes/presentation/bloc/category/category_bloc.dart';
import 'package:tithes/presentation/bloc/category/category_state.dart';
import 'package:tithes/presentation/widgets/month_selector.dart';
import 'package:tithes/presentation/widgets/donation_form_dialog.dart';

class DonationsPage extends StatefulWidget {
  const DonationsPage({super.key});

  @override
  State<DonationsPage> createState() => _DonationsPageState();
}

class _DonationsPageState extends State<DonationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<DonationBloc>().add(LoadDonations());
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<DonationBloc>().add(LoadDonations()),
          ),
        ],
      ),
      body: BlocBuilder<DonationBloc, DonationState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
                child: Column(
                  children: [
                    MonthSelector(
                      onMonthSelected: (month) {
                        context.read<DonationBloc>().add(FilterDonationsByMonth(month));
                      },
                    ),
                    const SizedBox(height: 16),
                    if (state is DonationLoaded) _buildSummaryRow(context, state),
                  ],
                ),
              ),
              Expanded(
                child: _buildBody(context, state),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDonationForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, DonationLoaded state) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  'Total Donations',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  currencyFormat.format(state.monthlyDonations),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Count',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  state.filteredDonations.length.toString(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, DonationState state) {
    if (state is DonationLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is DonationLoaded) {
      if (state.filteredDonations.isEmpty) {
        return const Center(
          child: Text(
            'No donation records found.\nTap + to add your first donation.',
            textAlign: TextAlign.center,
          ),
        );
      }
      return _buildDonationList(context, state);
    } else if (state is DonationError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${state.message}',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            ElevatedButton(
              onPressed: () => context.read<DonationBloc>().add(LoadDonations()),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else {
      return const Center(child: Text('Welcome! Add your first donation record.'));
    }
  }

  Widget _buildDonationList(BuildContext context, DonationLoaded state) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, categoryState) {
        final categories = categoryState is CategoryLoaded 
          ? categoryState.donationCategories 
          : <Category>[];
        
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: state.filteredDonations.length,
          itemBuilder: (context, index) {
            final donation = state.filteredDonations[index];
            final category = categories.firstWhere(
              (c) => c.id == donation.categoryId,
              orElse: () => Category(
                id: donation.categoryId,
                name: 'Unknown Category',
                type: CategoryType.donation,
              ),
            );
            
            return _buildDonationListItem(context, donation, category);
          },
        );
      },
    );
  }

  Widget _buildDonationListItem(BuildContext context, Donation donation, Category category) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final dateFormat = DateFormat('MMM dd, yyyy');
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.volunteer_activism,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          currencyFormat.format(donation.amount),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category.name),
            Text(dateFormat.format(donation.date)),
            if (donation.description?.isNotEmpty == true)
              Text(
                donation.description!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showDonationForm(context, donation),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmDelete(context, donation),
            ),
          ],
        ),
      ),
    );
  }

  void _showDonationForm(BuildContext context, [Donation? donation]) {
    showDialog(
      context: context,
      builder: (context) => DonationFormDialog(donation: donation),
    );
  }

  void _confirmDelete(BuildContext context, Donation donation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Donation'),
        content: const Text('Are you sure you want to delete this donation record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<DonationBloc>().add(DeleteDonation(donation.id));
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
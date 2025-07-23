import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tithes/core/extensions/date_extensions.dart';
import 'package:tithes/data/models/income.dart';
import 'package:tithes/data/models/category.dart';
import 'package:tithes/presentation/bloc/income/income_bloc.dart';
import 'package:tithes/presentation/bloc/income/income_event.dart';
import 'package:tithes/presentation/bloc/income/income_state.dart';
import 'package:tithes/presentation/bloc/category/category_bloc.dart';
import 'package:tithes/presentation/bloc/category/category_state.dart';
import 'package:tithes/presentation/widgets/month_selector.dart';
import 'package:tithes/presentation/widgets/income_form_dialog.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  @override
  void initState() {
    super.initState();
    context.read<IncomeBloc>().add(LoadIncomes());
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Income'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<IncomeBloc>().add(LoadIncomes()),
          ),
        ],
      ),
      body: BlocBuilder<IncomeBloc, IncomeState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
                child: Column(
                  children: [
                    MonthSelector(
                      onMonthSelected: (month) {
                        context.read<IncomeBloc>().add(FilterIncomesByMonth(month));
                      },
                    ),
                    const SizedBox(height: 16),
                    if (state is IncomeLoaded) _buildSummaryRow(context, state),
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
        onPressed: () => _showIncomeForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, IncomeLoaded state) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final maaserAmount = state.monthlyIncome * 0.1;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  'Total Income',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  currencyFormat.format(state.monthlyIncome),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Maaser (10%)',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  currencyFormat.format(maaserAmount),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.blue,
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

  Widget _buildBody(BuildContext context, IncomeState state) {
    if (state is IncomeLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is IncomeLoaded) {
      if (state.filteredIncomes.isEmpty) {
        return const Center(
          child: Text(
            'No income records found.\nTap + to add your first income.',
            textAlign: TextAlign.center,
          ),
        );
      }
      return _buildIncomeList(context, state);
    } else if (state is IncomeError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${state.message}',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            ElevatedButton(
              onPressed: () => context.read<IncomeBloc>().add(LoadIncomes()),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else {
      return const Center(child: Text('Welcome! Add your first income record.'));
    }
  }

  Widget _buildIncomeList(BuildContext context, IncomeLoaded state) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, categoryState) {
        final categories = categoryState is CategoryLoaded 
          ? categoryState.incomeCategories 
          : <Category>[];
        
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: state.filteredIncomes.length,
          itemBuilder: (context, index) {
            final income = state.filteredIncomes[index];
            final category = categories.firstWhere(
              (c) => c.id == income.categoryId,
              orElse: () => Category(
                id: income.categoryId,
                name: 'Unknown Category',
                type: CategoryType.income,
              ),
            );
            
            return _buildIncomeListItem(context, income, category);
          },
        );
      },
    );
  }

  Widget _buildIncomeListItem(BuildContext context, Income income, Category category) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final dateFormat = DateFormat('MMM dd, yyyy');
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.trending_up,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          currencyFormat.format(income.amount),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category.name),
            Text(dateFormat.format(income.date)),
            if (income.description?.isNotEmpty == true)
              Text(
                income.description!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showIncomeForm(context, income),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmDelete(context, income),
            ),
          ],
        ),
      ),
    );
  }

  void _showIncomeForm(BuildContext context, [Income? income]) {
    showDialog(
      context: context,
      builder: (context) => IncomeFormDialog(income: income),
    );
  }

  void _confirmDelete(BuildContext context, Income income) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Income'),
        content: const Text('Are you sure you want to delete this income record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<IncomeBloc>().add(DeleteIncome(income.id));
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
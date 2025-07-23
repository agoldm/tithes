import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tithes/core/extensions/date_extensions.dart';

class MonthSelector extends StatefulWidget {
  final Function(DateTime) onMonthSelected;

  const MonthSelector({
    super.key,
    required this.onMonthSelected,
  });

  @override
  State<MonthSelector> createState() => _MonthSelectorState();
}

class _MonthSelectorState extends State<MonthSelector> {
  DateTime _selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            IconButton(
              onPressed: _previousMonth,
              icon: const Icon(Icons.chevron_left),
            ),
            Expanded(
              child: Center(
                child: InkWell(
                  onTap: _showMonthPicker,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Text(
                      DateFormat.yMMMM(context.locale.languageCode).format(_selectedMonth),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: _nextMonth,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
    widget.onMonthSelected(_selectedMonth);
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
    widget.onMonthSelected(_selectedMonth);
  }

  Future<void> _showMonthPicker() async {
    final now = DateTime.now();
    final result = await showDatePicker(
      context: context,
      locale: context.locale,
      initialDate: _selectedMonth,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (result != null) {
      setState(() {
        _selectedMonth = DateTime(result.year, result.month);
      });
      widget.onMonthSelected(_selectedMonth);
    }
  }
}
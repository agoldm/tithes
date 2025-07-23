import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tithes/core/services/currency_service.dart';
import 'package:tithes/presentation/bloc/currency/currency_bloc.dart';
import 'package:tithes/presentation/bloc/currency/currency_state.dart';
import 'package:tithes/data/models/income.dart';
import 'package:tithes/data/models/category.dart';
import 'package:tithes/presentation/bloc/income/income_bloc.dart';
import 'package:tithes/presentation/bloc/income/income_event.dart';
import 'package:tithes/presentation/bloc/category/category_bloc.dart';
import 'package:tithes/presentation/bloc/category/category_state.dart';

class IncomeFormDialog extends StatefulWidget {
  final Income? income;

  const IncomeFormDialog({super.key, this.income});

  @override
  State<IncomeFormDialog> createState() => _IncomeFormDialogState();
}

class _IncomeFormDialogState extends State<IncomeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.income != null) {
      _amountController.text = widget.income!.amount.toString();
      _descriptionController.text = widget.income!.description ?? '';
      _selectedCategoryId = widget.income!.categoryId;
      _selectedDate = widget.income!.date;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.income == null ? 'add_income'.tr() : 'edit_income'.tr()),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocBuilder<CurrencyBloc, CurrencyState>(
                  builder: (context, currencyState) {
                    final currencyService = CurrencyService.instance;
                    return TextFormField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: '${'amount'.tr()} *',
                        prefixText: '${currencyService.currencySymbol} ',
                      ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'amount_required'.tr();
                        }
                        final amount = double.tryParse(value);
                        if (amount == null || amount <= 0) {
                          return 'amount_invalid'.tr();
                        }
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoaded) {
                      final categories = state.incomeCategories;
                      if (categories.isEmpty) {
                        return Text('no_income_categories'.tr());
                      }
                      
                      return DropdownButtonFormField<String>(
                        value: _selectedCategoryId,
                        decoration: InputDecoration(
                          labelText: '${'category'.tr()} *',
                        ),
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category.id,
                            child: Text('income_categories.${category.name}'.tr()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoryId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'category_required'.tr();
                          }
                          return null;
                        },
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text('date'.tr()),
                  subtitle: Text(DateFormat.yMMMd(context.locale.languageCode).format(_selectedDate)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: _selectDate,
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'description'.tr(),
                  ),
                  maxLines: 3,
                  maxLength: 200,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: Text('cancel'.tr()),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitForm,
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.income == null ? 'add'.tr() : 'save'.tr()),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      locale: context.locale,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      final amount = double.parse(_amountController.text);
      final description = _descriptionController.text.trim();
      
      final income = Income(
        id: widget.income?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        amount: amount,
        categoryId: _selectedCategoryId!,
        date: _selectedDate,
        description: description.isEmpty ? null : description,
      );

      if (widget.income == null) {
        context.read<IncomeBloc>().add(AddIncome(income));
      } else {
        context.read<IncomeBloc>().add(UpdateIncome(income));
      }

      Navigator.of(context).pop();
    }
  }
}
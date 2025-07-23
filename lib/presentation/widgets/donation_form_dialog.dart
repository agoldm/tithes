import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tithes/core/services/currency_service.dart';
import 'package:tithes/presentation/bloc/currency/currency_bloc.dart';
import 'package:tithes/presentation/bloc/currency/currency_state.dart';
import 'package:tithes/data/models/donation.dart';
import 'package:tithes/data/models/category.dart';
import 'package:tithes/presentation/bloc/donation/donation_bloc.dart';
import 'package:tithes/presentation/bloc/donation/donation_event.dart';
import 'package:tithes/presentation/bloc/category/category_bloc.dart';
import 'package:tithes/presentation/bloc/category/category_state.dart';

class DonationFormDialog extends StatefulWidget {
  final Donation? donation;

  const DonationFormDialog({super.key, this.donation});

  @override
  State<DonationFormDialog> createState() => _DonationFormDialogState();
}

class _DonationFormDialogState extends State<DonationFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.donation != null) {
      _amountController.text = widget.donation!.amount.toString();
      _descriptionController.text = widget.donation!.description ?? '';
      _selectedCategoryId = widget.donation!.categoryId;
      _selectedDate = widget.donation!.date;
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
      title: Text(widget.donation == null ? 'add_donation'.tr() : 'edit_donation'.tr()),
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
                      final categories = state.donationCategories;
                      if (categories.isEmpty) {
                        return Text('no_donation_categories'.tr());
                      }
                      
                      return DropdownButtonFormField<String>(
                        value: _selectedCategoryId,
                        decoration: InputDecoration(
                          labelText: '${'category'.tr()} *',
                        ),
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category.id,
                            child: Text('donation_categories.${category.name}'.tr()),
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
              : Text(widget.donation == null ? 'add'.tr() : 'save'.tr()),
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
      
      final donation = Donation(
        id: widget.donation?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        amount: amount,
        categoryId: _selectedCategoryId!,
        date: _selectedDate,
        description: description.isEmpty ? null : description,
      );

      if (widget.donation == null) {
        context.read<DonationBloc>().add(AddDonation(donation));
      } else {
        context.read<DonationBloc>().add(UpdateDonation(donation));
      }

      Navigator.of(context).pop();
    }
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tithes/core/constants/currency_constants.dart';
import 'package:tithes/presentation/bloc/currency/currency_bloc.dart';
import 'package:tithes/presentation/bloc/currency/currency_event.dart';
import 'package:tithes/presentation/bloc/currency/currency_state.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('settings'.tr()),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Section
            Text(
              'language'.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Text('🇺🇸'),
              title: Text('english'.tr()),
              trailing: context.locale.languageCode == 'en' 
                ? const Icon(Icons.check, color: Colors.green) 
                : null,
              onTap: () {
                context.setLocale(const Locale('en'));
              },
            ),
            ListTile(
              leading: const Text('🇮🇱'),
              title: Text('hebrew'.tr()),
              trailing: context.locale.languageCode == 'he' 
                ? const Icon(Icons.check, color: Colors.green) 
                : null,
              onTap: () {
                context.setLocale(const Locale('he'));
              },
            ),
            const Divider(),
            const SizedBox(height: 8),
            
            // Currency Section
            Text(
              'currency'.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            BlocBuilder<CurrencyBloc, CurrencyState>(
              builder: (context, state) {
                final currentCurrency = state is CurrencyLoaded 
                  ? state.selectedCurrency 
                  : CurrencyConstants.defaultCurrency;
                
                return Column(
                  children: [
                    ListTile(
                      leading: const Text('🇺🇸'),
                      title: Text('usd'.tr()),
                      subtitle: Text('\$ - ${'dollar'.tr()}'),
                      trailing: currentCurrency == Currency.usd
                        ? const Icon(Icons.check, color: Colors.green) 
                        : null,
                      onTap: () {
                        context.read<CurrencyBloc>().add(ChangeCurrency(Currency.usd));
                      },
                    ),
                    ListTile(
                      leading: const Text('🇮🇱'),
                      title: Text('nis'.tr()),
                      subtitle: Text('₪ - ${'shekel'.tr()}'),
                      trailing: currentCurrency == Currency.nis
                        ? const Icon(Icons.check, color: Colors.green) 
                        : null,
                      onTap: () {
                        context.read<CurrencyBloc>().add(ChangeCurrency(Currency.nis));
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('cancel'.tr()),
        ),
      ],
    );
  }
}
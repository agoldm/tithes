import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tithes/core/constants/currency_constants.dart';

class CurrencyService {
  static CurrencyService? _instance;
  static CurrencyService get instance => _instance ??= CurrencyService._();
  
  CurrencyService._();
  
  Currency _currentCurrency = CurrencyConstants.defaultCurrency;
  
  Currency get currentCurrency => _currentCurrency;
  
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final currencyIndex = prefs.getInt(CurrencyConstants.currencyPreferenceKey);
    
    if (currencyIndex != null && currencyIndex < Currency.values.length) {
      _currentCurrency = Currency.values[currencyIndex];
    }
  }
  
  Future<void> setCurrency(Currency currency) async {
    _currentCurrency = currency;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(CurrencyConstants.currencyPreferenceKey, currency.index);
  }
  
  String formatAmount(double amount) {
    final symbol = CurrencyConstants.currencySymbols[_currentCurrency]!;
    
    // Create NumberFormat with appropriate locale and symbol
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: 2,
      locale: CurrencyConstants.currencyLocales[_currentCurrency],
    );
    
    return formatter.format(amount);
  }
  
  String get currencySymbol => CurrencyConstants.currencySymbols[_currentCurrency]!;
  
  String get currencyName => CurrencyConstants.currencyNames[_currentCurrency]!;
}
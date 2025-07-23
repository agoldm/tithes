enum Currency {
  usd,
  nis,
}

class CurrencyConstants {
  static const Map<Currency, String> currencySymbols = {
    Currency.usd: '\$',
    Currency.nis: '₪',
  };
  
  static const Map<Currency, String> currencyNames = {
    Currency.usd: 'USD',
    Currency.nis: 'NIS',
  };
  
  static const Map<Currency, String> currencyLocales = {
    Currency.usd: 'en_US',
    Currency.nis: 'he_IL',
  };
  
  static const String currencyPreferenceKey = 'selected_currency';
  static const Currency defaultCurrency = Currency.usd;
}
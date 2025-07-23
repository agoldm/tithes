import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tithes/core/theme/app_theme.dart';
import 'package:tithes/core/services/currency_service.dart';
import 'package:tithes/data/datasources/local_data_source.dart';
import 'package:tithes/data/repositories/income_repository_impl.dart';
import 'package:tithes/data/repositories/donation_repository_impl.dart';
import 'package:tithes/data/repositories/category_repository_impl.dart';
import 'package:tithes/presentation/bloc/home/home_bloc.dart';
import 'package:tithes/presentation/bloc/home/home_event.dart';
import 'package:tithes/presentation/bloc/income/income_bloc.dart';
import 'package:tithes/presentation/bloc/donation/donation_bloc.dart';
import 'package:tithes/presentation/bloc/category/category_bloc.dart';
import 'package:tithes/presentation/bloc/category/category_event.dart';
import 'package:tithes/presentation/bloc/currency/currency_bloc.dart';
import 'package:tithes/presentation/bloc/currency/currency_event.dart';
import 'package:tithes/presentation/navigation/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  
  await LocalDataSource.initialize();
  await CurrencyService.instance.initialize();
  
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('he'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MaaserApp(),
    ),
  );
}

class MaaserApp extends StatelessWidget {
  const MaaserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoryBloc(
            categoryRepository: CategoryRepositoryImpl(),
          )..add(LoadCategories()),
        ),
        BlocProvider(
          create: (context) => IncomeBloc(
            incomeRepository: IncomeRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (context) => DonationBloc(
            donationRepository: DonationRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (context) => CurrencyBloc(
            currencyService: CurrencyService.instance,
          )..add(LoadCurrency()),
        ),
        BlocProvider(
          create: (context) => HomeBloc(
            incomeRepository: IncomeRepositoryImpl(),
            donationRepository: DonationRepositoryImpl(),
          )..add(LoadMaaserSummary()),
        ),
      ],
      child: MaterialApp(
        title: 'app_title'.tr(),
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: ResponsiveBreakpoints.builder(
          child: const MainLayout(),
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

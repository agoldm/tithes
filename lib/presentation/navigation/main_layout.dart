import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tithes/presentation/pages/home_page.dart';
import 'package:tithes/presentation/pages/income_page.dart';
import 'package:tithes/presentation/pages/donations_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    IncomePage(),
    DonationsPage(),
  ];

  List<NavigationDestination> get _destinations => [
    NavigationDestination(
      icon: const Icon(Icons.home_outlined),
      selectedIcon: const Icon(Icons.home),
      label: 'home'.tr(),
    ),
    NavigationDestination(
      icon: const Icon(Icons.trending_up_outlined),
      selectedIcon: const Icon(Icons.trending_up),
      label: 'income'.tr(),
    ),
    NavigationDestination(
      icon: const Icon(Icons.volunteer_activism_outlined),
      selectedIcon: const Icon(Icons.volunteer_activism),
      label: 'donations'.tr(),
    ),
  ];

  List<NavigationRailDestination> get _railDestinations => [
    NavigationRailDestination(
      icon: const Icon(Icons.home_outlined),
      selectedIcon: const Icon(Icons.home),
      label: Text('home'.tr()),
    ),
    NavigationRailDestination(
      icon: const Icon(Icons.trending_up_outlined),
      selectedIcon: const Icon(Icons.trending_up),
      label: Text('income'.tr()),
    ),
    NavigationRailDestination(
      icon: const Icon(Icons.volunteer_activism_outlined),
      selectedIcon: const Icon(Icons.volunteer_activism),
      label: Text('donations'.tr()),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              destinations: _railDestinations,
            ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: _destinations,
            ),
    );
  }
}
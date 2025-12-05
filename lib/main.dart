import 'dart:async';

import 'package:flutter/material.dart';

import 'package:southern_money/pages/login_page.dart';
import 'package:southern_money/pages/setting.dart';
import 'package:southern_money/setting/ensure_initialized.dart';
import 'pages/home_page.dart';
import 'pages/community_page.dart';
import 'pages/market_page.dart';
import 'pages/profile_page.dart';
import 'setting/app_config.dart';
import 'widgets/common_widget.dart';

// 导航项数据模型
class NavigationItemData {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final Widget page;

  const NavigationItemData({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.page,
  });
}

void main() async {
  await ensureInitialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final appConfigService = getIt<AppConfigService>();

  Widget _build() {
    final colorSeed = appConfigService.appSetting.value[theme_color];
    return MaterialApp(
      title: '南方财富',
      theme: ThemeData(colorSchemeSeed: colorSeed, useMaterial3: true),
      darkTheme: ThemeData(
        colorSchemeSeed: colorSeed,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    //app setting
    return ListenableBuilder(
      listenable: appConfigService.appSetting,
      builder: (context, _) {
        //session key
        return _build();
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final appConfigService = getIt<AppConfigService>();
  final PageController _pageController = PageController();

  // 导航项数据模型
  static final List<NavigationItemData> _navigationItems = [
    NavigationItemData(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: '首页',
      page: HomePage(),
    ),
    NavigationItemData(
      icon: Icons.forum_outlined,
      selectedIcon: Icons.forum,
      label: '社区',
      page: CommunityPage(),
    ),
    NavigationItemData(
      icon: Icons.trending_up_outlined,
      selectedIcon: Icons.trending_up,
      label: '行情',
      page: MarketPage(),
    ),
    NavigationItemData(
      icon: Icons.person_outlined,
      selectedIcon: Icons.person,
      label: '我的',
      page: ProfilePage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    logicRootContext = context;
    return ListenableBuilder(
      listenable: appConfigService.tokenService.sessionToken,
      builder: (context, _) {
        if (appConfigService.tokenService.sessionToken.value == null) {
          return const LoginPage();
        }
        return _buildMainScreen();
      },
    );
  }

  Widget _buildMainScreen() {
    scheduleMicrotask(() {
      if (_pageController.hasClients &&
          _currentIndex != _pageController.page?.round()) {
        _pageController.jumpToPage(_currentIndex);
      }
    });
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          // 横屏模式：使用左侧导航栏
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _currentIndex = index;
                      _pageController.jumpToPage(_currentIndex);
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: _navigationItems
                      .map(
                        (item) => NavigationRailDestination(
                          icon: Icon(item.icon),
                          selectedIcon: Icon(item.selectedIcon),
                          label: Text(item.label),
                        ),
                      )
                      .toList(),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    children: _navigationItems
                        .map((item) => item.page)
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        } else {
          // 竖屏模式：使用底部导航栏
          return Scaffold(
            body: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: _navigationItems.map((item) => item.page).toList(),
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _currentIndex = index;
                  _pageController.jumpToPage(index);
                });
              },
              destinations: _navigationItems
                  .map(
                    (item) => NavigationDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.selectedIcon),
                      label: item.label,
                    ),
                  )
                  .toList(),
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
          );
        }
      },
    );
  }
}

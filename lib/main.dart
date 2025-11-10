import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
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
  final String label;
  final Widget page;

  const NavigationItemData({
    required this.icon,
    required this.label,
    required this.page,
  });
}

void main() async {
  await ensureInitialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appSetting,
      builder: (context, _) {
        final colorSeed = appSetting.value[theme_color];
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

  // 导航项数据模型
  static const List<NavigationItemData> _navigationItems = [
    NavigationItemData(icon: Icons.home, label: '首页', page: HomePage()),
    NavigationItemData(icon: Icons.people, label: '社区', page: CommunityPage()),
    NavigationItemData(
      icon: Icons.trending_up,
      label: '行情',
      page: MarketPage(),
    ),
    NavigationItemData(icon: Icons.person, label: '我的', page: ProfilePage()),
  ];

  @override
  Widget build(BuildContext context) {
    logicRootContext = context;
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
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: _navigationItems
                      .map(
                        (item) => NavigationRailDestination(
                          icon: Icon(item.icon),
                          label: Text(item.label),
                        ),
                      )
                      .toList(),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: _navigationItems[_currentIndex].page),
              ],
            ),
          );
        } else {
          // 竖屏模式：使用底部导航栏
          return Scaffold(
            body: _navigationItems[_currentIndex].page,
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 8,
                  ),
                  child: GNav(
                    gap: 8,
                    iconSize: 24,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    duration: Duration(milliseconds: 350),
                    tabBackgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    tabs: _navigationItems
                        .map(
                          (item) => GButton(icon: item.icon, text: item.label),
                        )
                        .toList(),
                    selectedIndex: _currentIndex,
                    onTabChange: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

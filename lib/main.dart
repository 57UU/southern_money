import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/community_page.dart';
import 'pages/market_page.dart';
import 'pages/profile_page.dart';

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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Southern Money',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
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
                  selectedIconTheme: const IconThemeData(color: Colors.blue),
                  unselectedIconTheme: const IconThemeData(color: Colors.grey),
                  selectedLabelTextStyle: const TextStyle(color: Colors.blue),
                  unselectedLabelTextStyle: const TextStyle(color: Colors.grey),
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
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              items: _navigationItems
                  .map(
                    (item) => BottomNavigationBarItem(
                      icon: Icon(item.icon),
                      label: item.label,
                    ),
                  )
                  .toList(),
            ),
          );
        }
      },
    );
  }
}

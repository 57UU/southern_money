import 'package:flutter/material.dart';
import 'package:southern_money/pages/admin_censor_forum.dart';
import 'package:southern_money/pages/admin_manage_user.dart';
import 'package:southern_money/pages/admin_statistics.dart';
import 'package:southern_money/widgets/common_widget.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  static final List<NavigationItemData> _navigationItem = [
    NavigationItemData(
      icon: Icons.forum_outlined,
      selectedIcon: Icons.forum,
      label: '审查帖子',
      page: AdminCensorForum(),
    ),
    NavigationItemData(
      icon: Icons.manage_accounts_outlined,
      selectedIcon: Icons.manage_accounts,
      label: '管理用户',
      page: AdminManageUser(),
    ),
    NavigationItemData(
      icon: Icons.analytics_outlined,
      selectedIcon: Icons.analytics,
      label: '统计分析',
      page: AdminStatistics(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('管理员中心')),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            // 横屏模式：使用左侧导航栏
            return Row(
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
                  destinations: _navigationItem
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
                    children: _navigationItem.map((item) => item.page).toList(),
                  ),
                ),
              ],
            );
          } else {
            // 竖屏模式：使用底部导航栏
            return Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    children: _navigationItem.map((item) => item.page).toList(),
                  ),
                ),
                NavigationBar(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _currentIndex = index;
                      _pageController.jumpToPage(index);
                    });
                  },
                  destinations: _navigationItem
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
              ],
            );
          }
        },
      ),
    );
  }
}

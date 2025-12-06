import 'package:flutter/material.dart';

Widget TitleText(String title) {
  return Text(
    title,
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  );
}

late BuildContext logicRootContext;

class PlaceholderImage extends StatelessWidget {
  const PlaceholderImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/avatar.png');
  }
}

class AdminIdentifier extends StatelessWidget {
  const AdminIdentifier({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shield_outlined,
            size: 12,
            color: colorScheme.onSecondaryContainer,
          ),
          SizedBox(width: 4),
          Text(
            '管理员',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}


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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:southern_money/pages/about_us_page.dart';
import 'package:southern_money/pages/debug_page.dart';

import 'theme_color_page.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    final body = Column(
      children: [
        _buildMenuItem(context, '主题颜色', Icons.color_lens_outlined, () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => const ChangeThemeColorPage(),
            ),
          );
        }),
        _buildMenuItem(context, '关于我们', Icons.info_outline, () {
          Navigator.of(
            context,
          ).push(CupertinoPageRoute(builder: (context) => const AboutUsPage()));
        }),
        _buildMenuItem(context, '测试页面', Icons.category_outlined, () {
          Navigator.of(
            context,
          ).push(CupertinoPageRoute(builder: (context) => const DebugPage()));
        }),
      ],
    );
    return Scaffold(
      appBar: AppBar(title: const Text('设置'), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: body,
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool showBadge = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[700]),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
            if (showBadge)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 8),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}

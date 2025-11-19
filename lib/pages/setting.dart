import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:southern_money/data/local_store.dart';
import 'package:southern_money/pages/about_us_page.dart';
import 'package:southern_money/pages/debug_page.dart';
import 'package:southern_money/setting/app_config.dart';
import 'package:southern_money/setting/version.dart';
import 'package:southern_money/widgets/common_widget.dart';
import 'package:southern_money/widgets/dialog.dart';
import 'package:southern_money/widgets/profile_menu_item.dart';

import 'setting_duration.dart';
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
        ProfileMenuItem(
          title: '主题颜色',
          icon: Icons.color_lens_outlined,
          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => const ChangeThemeColorPage(),
              ),
            );
          },
        ),
        ProfileMenuItem(
          title: '动画时长',
          icon: Icons.timer_outlined,
          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(builder: (context) => const SettingDuration()),
            );
          },
        ),
        ProfileMenuItem(
          title: '关于我们',
          icon: Icons.info_outline,
          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(builder: (context) => const AboutUsPage()),
            );
          },
        ),
        ProfileMenuItem(
          title: '测试页面',
          icon: Icons.category_outlined,
          onTap: () {
            Navigator.of(
              context,
            ).push(CupertinoPageRoute(builder: (context) => const DebugPage()));
          },
        ),
        ProfileMenuItem(
          title: "清除全部数据",
          icon: Icons.delete_outline,
          onTap: () async {
            final confirm = await showYesNoDialog(
              context: context,
              title: '确认清除',
              content: '您确定要清除全部数据吗？',
            );
            if (confirm == true) {
              await LocalStore.instance.clearAll();
              await clearAllData();
            }
          },
          foreColor: Colors.red.withValues(alpha: 0.7),
        ),
        ProfileMenuItem(
          title: '当前版本: ${currentVersion}',
          icon: Icons.info_outline,
          onTap: () async {
            await showInfoDialog(
              context: context,
              title: '版本信息',
              content: getVersionInfo(),
            );
          },
        ),
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
}

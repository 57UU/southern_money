import 'package:flutter/material.dart';
import 'package:southern_money/setting/ensure_initialized.dart';

import '../setting/app_config.dart';

class JewelryPage extends StatefulWidget {
  const JewelryPage({super.key});

  @override
  State<JewelryPage> createState() => _JewelryPageState();
}

class _JewelryPageState extends State<JewelryPage> {
  bool openFilter = false;
  final appConfigService = getIt<AppConfigService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CSGO饰品'),
        actions: [
          Row(
            children: [
              Text('筛选器'),
              IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () {
                  setState(() {
                    openFilter = !openFilter;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 过滤器区域，根据openFilter状态显示或隐藏，移到顶部
          AnimatedContainer(
            duration: Duration(milliseconds: appConfigService.animationTime),
            curve: Curves.easeOutQuart,
            height: openFilter ? 200 : 0,
            child: SingleChildScrollView(
              // 设置物理滚动以防止在收起时滚动冲突
              physics: openFilter
                  ? AlwaysScrollableScrollPhysics()
                  : NeverScrollableScrollPhysics(),
              child: JewelryFilter(),
            ),
          ),
          // 饰品列表内容区域
          Expanded(child: Center(child: Text('饰品列表'))),
        ],
      ),
    );
  }
}

class JewelryFilter extends StatefulWidget {
  const JewelryFilter({super.key});

  @override
  State<JewelryFilter> createState() => _JewelryFilterState();
}

// 定义饰品类型枚举
enum JewelryCategory {
  rifle('步枪'),
  pistol('手枪'),
  knife('刀具'),
  glove('手套'),
  helmet('头盔');

  final String label;
  const JewelryCategory(this.label);
}

class _JewelryFilterState extends State<JewelryFilter> {
  // 使用Set存储选中的类别
  Set<JewelryCategory> selectedCategories = {};

  // 应用按钮处理函数
  void applyFilter() {
    // 实际应用过滤器的逻辑，这里暂时不实现
    print('应用过滤器: $selectedCategories');
  }

  // 取消按钮处理函数
  void cancelFilter() {
    // 取消选中所有类别
    setState(() {
      selectedCategories.clear();
    });
    print('取消过滤器');
  }

  @override
  Widget build(BuildContext context) {
    final segmentButtons = SegmentedButton<JewelryCategory>(
      segments: const <ButtonSegment<JewelryCategory>>[
        ButtonSegment<JewelryCategory>(
          value: JewelryCategory.rifle,
          label: Text('步枪'),
        ),
        ButtonSegment<JewelryCategory>(
          value: JewelryCategory.pistol,
          label: Text('手枪'),
        ),
        ButtonSegment<JewelryCategory>(
          value: JewelryCategory.knife,
          label: Text('刀具'),
        ),
        ButtonSegment<JewelryCategory>(
          value: JewelryCategory.glove,
          label: Text('手套'),
        ),
        ButtonSegment<JewelryCategory>(
          value: JewelryCategory.helmet,
          label: Text('头盔'),
        ),
      ],
      selected: selectedCategories,
      onSelectionChanged: (Set<JewelryCategory> newSelection) {
        setState(() {
          selectedCategories = newSelection;
        });
      },
      multiSelectionEnabled: true,
      // 允许全部取消选择
      emptySelectionAllowed: true,
    );
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '选择饰品类型',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          SizedBox(width: double.infinity, child: segmentButtons),
          SizedBox(height: 24),
          // 按钮区域
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: cancelFilter, child: Text('取消')),
              ElevatedButton(
                onPressed: applyFilter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                ),
                child: Text('应用'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

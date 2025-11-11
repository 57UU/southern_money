import 'package:flutter/material.dart';
import '../setting/app_config.dart';

class SettingDuration extends StatefulWidget {
  const SettingDuration({super.key});

  @override
  State<SettingDuration> createState() => _SettingDurationState();
}

class _SettingDurationState extends State<SettingDuration> {
  late int _currentAnimationTime; // 用于实时预览的值
  late int _tempAnimationTime; // 临时存储未确认的值
  bool _isAnimating = false; // 动画状态

  @override
  void initState() {
    super.initState();
    // 初始化当前动画时长为配置中的值
    _currentAnimationTime = animationTime;
    _tempAnimationTime = animationTime;

    // 启动预览动画
    _startAnimation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isAnimating = true;
        });

        Future.delayed(Duration(milliseconds: _currentAnimationTime + 500), () {
          if (mounted) {
            setState(() {
              _isAnimating = false;
            });
            _startAnimation(); // 循环动画
          }
        });
      }
    });
  }

  void _updateAnimationTime(double value) {
    setState(() {
      _tempAnimationTime = value.round();
      _currentAnimationTime = _tempAnimationTime; // 实时更新预览动画时长
    });
  }

  void _confirmChanges() {
    // 只有在确认时才真正更新appSetting中的值

    appSetting.value[animation_time] = _tempAnimationTime;
    appSetting.notifyListeners();

    Navigator.pop(context);
    // 显示成功提示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('动画时长已更新为 $_tempAnimationTime ms'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('动画时长'),
        actions: [
          TextButton(
            onPressed: _confirmChanges,
            child: Text(
              '确认',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 当前值显示
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                '当前动画时长: $_tempAnimationTime ms',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),

            // 滑块控件
            Slider(
              value: _tempAnimationTime.toDouble(),
              min: 0,
              max: 1000,
              divisions: 20,
              label: '$_tempAnimationTime ms',
              onChanged: _updateAnimationTime,
              activeColor: Theme.of(context).colorScheme.primary,
              inactiveColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
            ),

            // 动画预览区域
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: AnimatedContainer(
                    width: _isAnimating ? 150 : 100,
                    height: _isAnimating ? 150 : 100,
                    decoration: BoxDecoration(
                      color: _isAnimating
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(
                        _isAnimating ? 30 : 10,
                      ),
                    ),
                    duration: Duration(milliseconds: _currentAnimationTime),
                    curve: Curves.easeInOut,
                    child: const Icon(
                      Icons.flutter_dash,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),

            // 提示信息
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                '提示：调整滑块查看动画效果，点击确认后才会保存设置',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

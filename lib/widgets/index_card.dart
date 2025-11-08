import 'package:flutter/material.dart';

class IndexCard extends StatelessWidget {
  final String name;
  final String value;
  final String change;

  const IndexCard({
    super.key,
    required this.name,
    required this.value,
    required this.change,
  });

  // 根据涨跌情况自动判断颜色
  Color _getChangeColor() {
    if (change.startsWith('+')) {
      return Colors.green;
    } else if (change.startsWith('-')) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              change,
              style: TextStyle(
                fontSize: 12,
                color: _getChangeColor(),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
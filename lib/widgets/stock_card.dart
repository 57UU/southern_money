import 'package:flutter/material.dart';
import 'styled_card.dart';

class StockCard extends StatelessWidget {
  final String stockName;
  final String stockCode;
  final double price;
  final double changeAmount;
  final double changePercent;
  final bool isUp;
  final VoidCallback? onTap;

  const StockCard({
    super.key,
    required this.stockName,
    required this.stockCode,
    required this.price,
    required this.changeAmount,
    required this.changePercent,
    required this.isUp,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return StyledCard(
      margin: const EdgeInsets.only(bottom: 12),
      borderRadius: 8,
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('查看 $stockName 详情')));
        }
      },
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stockName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stockCode,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price.toStringAsFixed(2),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  (isUp ? '+' : '') + changeAmount.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 12,
                    color: isUp ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          SizedBox(
            width: 70,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isUp
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                (isUp ? '+' : '') + changePercent.toStringAsFixed(2) + '%',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isUp ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

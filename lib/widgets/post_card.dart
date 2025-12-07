import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:southern_money/widgets/common_widget.dart';
import 'styled_card.dart';

class PostCard extends StatelessWidget {
  final String title;
  final String author;
  final String timeAgo;
  final VoidCallback? onTap;
  final VoidCallback? onMorePressed;
  final String avaterUrl;

  const PostCard({
    super.key,
    required this.title,
    required this.author,
    required this.timeAgo,
    this.onTap,
    this.onMorePressed,
    required this.avaterUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return StyledCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Avater(avatarUrl: avaterUrl)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.more_horiz,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                onPressed: onMorePressed ?? () {},
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:southern_money/pages/theme_color_page.dart';
import 'package:southern_money/widgets/common_widget.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'styled_card.dart';

class PostCard extends StatelessWidget {
  final String content;
  final String title;
  final String author;
  final String timeAgo;
  final VoidCallback? onTap;
  final VoidCallback? onMorePressed;
  final String avaterUrl;
  final bool isBlocked;
  final List<BlockReason> postBlocks;
  final VoidCallback? onBlockInfoPressed;

  const PostCard({
    super.key,
    required this.title,
    required this.content,
    required this.author,
    required this.timeAgo,
    this.onTap,
    this.onMorePressed,
    required this.avaterUrl,
    this.isBlocked = false,
    this.postBlocks = const [],
    this.onBlockInfoPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return StyledCard(
      onTap: onTap,
      borderSide: isBlocked
          ? BorderSide(
              color: colorScheme.error.withValues(alpha: 0.5),
              width: 1.5,
            )
          : BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBlocked) _buildBlockWarning(context, colorScheme),
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
              if (onMorePressed != null)
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
          titleText(title),
          Text(
            content,
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

  Widget _buildBlockWarning(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: colorScheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: colorScheme.onErrorContainer, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '此帖子已被封禁',
              style: TextStyle(
                color: colorScheme.onErrorContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (postBlocks.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.info_outline,
                size: 20,
                color: colorScheme.onErrorContainer,
              ),
              onPressed: onBlockInfoPressed,
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}

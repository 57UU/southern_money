import 'package:cached_network_image/cached_network_image.dart';
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

class Avater extends StatelessWidget {
  final String avatarUrl;
  const Avater({super.key, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: avatarUrl,
          fit: BoxFit.cover,
          width: 40,
          height: 40,
          errorWidget: (context, url, error) => Container(
            width: 40,
            height: 40,
            color: colorScheme.surfaceContainerHighest,
            child: Icon(Icons.person, color: colorScheme.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}

class Uploader extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final void Function()? onTap;
  const Uploader({
    super.key,
    required this.avatarUrl,
    required this.name,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          // 头像
          Avater(avatarUrl: avatarUrl),
          const SizedBox(width: 12),
          // 用户名
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class Tag extends StatelessWidget {
  final String tag;
  final void Function()? onTap;
  const Tag({super.key, required this.tag, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final body = Chip(
      label: Text(
        tag,
        style: TextStyle(color: colorScheme.onSecondaryContainer, fontSize: 14),
      ),
      backgroundColor: colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
    return GestureDetector(onTap: onTap, child: body);
  }
}

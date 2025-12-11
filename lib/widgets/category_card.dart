import 'package:flutter/material.dart';
import 'package:southern_money/webapi/api_image.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/setting/ensure_initialized.dart';

class CategoryCard extends StatelessWidget {
  final CategoryResponse category;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final bool showFavoriteButton;

  const CategoryCard({
    super.key,
    required this.category,
    this.onTap,
    this.onFavoriteToggle,
    this.showFavoriteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final apiImageService = getIt<ApiImageService>();
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            apiImageService.getImageUrl(category.coverImageId),
          ),
          onBackgroundImageError: (exception, stackTrace) {
            // 图片加载失败时的处理
          },
          child: category.coverImageId.isEmpty
              ? const Icon(Icons.category)
              : null,
        ),
        title: Text(
          category.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '创建时间: ${category.CreateTime.toString().substring(0, 10)}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        onTap: onTap,
        trailing: showFavoriteButton
            ? IconButton(
                icon: Icon(
                  category.isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: category.isFavorited ? Colors.red : null,
                ),
                onPressed: onFavoriteToggle,
              )
            : null,
      ),
    );
  }
}
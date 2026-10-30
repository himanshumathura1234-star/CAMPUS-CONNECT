import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/campus_models.dart';
import '../../../services/campus_data_service.dart';

class ResourceCard extends StatelessWidget {
  final StudyResourceModel resource;
  final VoidCallback? onUpdate;

  const ResourceCard({
    super.key,
    required this.resource,
    this.onUpdate,
  });

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return AppColors.coral;
      case 'pyq':
        return const Color(0xFF6B4FB8); // Lavender accent
      case 'code':
        return AppColors.emerald;
      default:
        return const Color(0xFFC78500); // Amber/Golden
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'pyq':
        return Icons.quiz_rounded;
      case 'code':
        return Icons.code_rounded;
      default:
        return Icons.menu_book_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final typeColor = _getTypeColor(resource.fileType);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
          width: 1.2,
        ),
        boxShadow: AppColors.softShadow(Colors.black, blur: 8, offset: const Offset(0, 3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: typeColor.withValues(alpha: 0.3)),
              ),
              child: Icon(_getTypeIcon(resource.fileType), color: typeColor, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: typeColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          resource.fileType.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: typeColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Sem ${resource.semester} • ${resource.subject}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          resource.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                          size: 20,
                          color: resource.isBookmarked ? AppColors.coral : Colors.grey,
                        ),
                        onPressed: () {
                          CampusDataService().toggleBookmarkResource(resource.id);
                          onUpdate?.call();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    resource.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    resource.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 16, color: AppColors.goldenYellow),
                      const SizedBox(width: 2),
                      Text(
                        '${resource.rating}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.download_rounded, size: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText),
                      const SizedBox(width: 2),
                      Text(
                        '${resource.downloadCount} dl',
                        style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          resource.downloadCount++;
                          onUpdate?.call();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('📥 Downloading ${resource.title}...'),
                              backgroundColor: AppColors.emerald,
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.coral.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.download_rounded, size: 14, color: AppColors.coral),
                              SizedBox(width: 4),
                              Text(
                                'Download',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.coral,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


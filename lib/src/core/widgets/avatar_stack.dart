import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable overlapping avatar stack with configurable radius, borders,
/// and trailing +N counter badge.
class AvatarStack extends StatelessWidget {
  final List<String> imageUrls;
  final List<String>? fallbackNames;
  final int totalCount;
  final double radius;
  final double overlap;
  final Color? borderColor;

  const AvatarStack({
    super.key,
    required this.imageUrls,
    this.fallbackNames,
    this.totalCount = 0,
    this.radius = 14,
    this.overlap = 10,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderCol = borderColor ?? (isDark ? AppColors.darkSurface : Colors.white);
    final displayedCount = imageUrls.take(3).length;
    final remaining = (totalCount > displayedCount) ? totalCount - displayedCount : 0;

    return SizedBox(
      height: radius * 2,
      width: (displayedCount * (radius * 2 - overlap)) + (remaining > 0 ? (radius * 2 - overlap) : overlap),
      child: Stack(
        children: [
          for (int i = 0; i < displayedCount; i++)
            Positioned(
              left: i * (radius * 2 - overlap),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: borderCol, width: 2),
                ),
                child: CircleAvatar(
                  radius: radius - 1,
                  backgroundColor: AppColors.peach,
                  backgroundImage: imageUrls[i].isNotEmpty ? NetworkImage(imageUrls[i]) : null,
                  child: imageUrls[i].isEmpty && fallbackNames != null && fallbackNames!.length > i
                      ? Text(
                          fallbackNames![i].isNotEmpty ? fallbackNames![i][0] : 'U',
                          style: TextStyle(
                            fontSize: radius * 0.8,
                            fontWeight: FontWeight.bold,
                            color: AppColors.charcoal,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          if (remaining > 0)
            Positioned(
              left: displayedCount * (radius * 2 - overlap),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: borderCol, width: 2),
                ),
                child: CircleAvatar(
                  radius: radius - 1,
                  backgroundColor: AppColors.softLavender,
                  child: Text(
                    '+$remaining',
                    style: TextStyle(
                      fontSize: radius * 0.75,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF4A348F),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}


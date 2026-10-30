import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final String? iconEmoji;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? activeColor;
  final int? count;

  const CategoryChip({
    super.key,
    required this.label,
    this.iconEmoji,
    this.icon,
    required this.isSelected,
    required this.onTap,
    this.activeColor,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    final color = activeColor ?? AppColors.coral;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? color.withValues(alpha: 0.25) : color.withValues(alpha: 0.14))
              : (isDark ? AppColors.darkSurface : AppColors.pureWhite),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected
                ? color
                : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
            width: isSelected ? 1.8 : 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.20),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconEmoji != null) ...[
              Text(iconEmoji!, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
            ] else if (icon != null) ...[
              Icon(
                icon,
                size: 15,
                color: isSelected ? color : AppColors.secondaryText,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? (isDark ? Colors.white : AppColors.charcoal)
                    : (isDark ? AppColors.darkTextSecondary : AppColors.mainText),
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                decoration: BoxDecoration(
                  color: isSelected ? color : AppColors.secondaryText.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppColors.secondaryText,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


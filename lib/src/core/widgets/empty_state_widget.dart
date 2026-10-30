import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'gradient_action_button.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String description;
  final String emoji;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.description,
    this.emoji = '🔍',
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceElevated
                    : AppColors.peach.withValues(alpha: 0.5),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.darkCardBorder : AppColors.peach,
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: Text(emoji, style: const TextStyle(fontSize: 40)),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.mainText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 20),
              GradientActionButton(
                label: buttonText!,
                onPressed: onButtonPressed,
                height: 42,
                borderRadius: 12,
              )
            ]
          ],
        ),
      ),
    );
  }
}


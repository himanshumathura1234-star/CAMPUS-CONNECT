import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/campus_models.dart';
import '../../../services/campus_data_service.dart';

class ConfessionCard extends StatelessWidget {
  final ConfessionItem confession;
  final VoidCallback? onReactionChanged;

  const ConfessionCard({
    super.key,
    required this.confession,
    this.onReactionChanged,
  });

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Report Confession'),
        content: const Text(
          'Are you sure you want to flag this confession for campus moderation review? False reports are discouraged.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(ctx);
              CampusDataService().reportConfession(confession.id);
              onReactionChanged?.call();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Report submitted. Thank you for keeping Campus Build safe.'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
            child: const Text('Report & Hide'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (confession.isReported) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
          width: 1.2,
        ),
        boxShadow: AppColors.softShadow(Colors.black, blur: 10, offset: const Offset(0, 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Anonymous identity & Category tag
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.softLavender.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Text('🤫', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Anonymous Student',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.charcoal,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.shield_rounded, size: 13, color: Color(0xFF6B4FB8)),
                        ],
                      ),
                      Text(
                        confession.timeAgo,
                        style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.peach.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.peach),
                    ),
                    child: Text(
                      confession.category,
                      style: const TextStyle(
                        color: Color(0xFF9E3A25),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.more_horiz, size: 18, color: AppColors.secondaryText),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => _showReportDialog(context),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            confession.content,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark ? AppColors.darkTextPrimary : AppColors.charcoal,
            ),
          ),
          const SizedBox(height: 14),

          // Interactive Emoji Reactions Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: confession.reactions.entries.map((entry) {
                final emoji = entry.key;
                final count = entry.value;
                final isSelected = confession.userReactions.contains(emoji);

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      CampusDataService().toggleConfessionReaction(confession.id, emoji);
                      onReactionChanged?.call();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.coral.withValues(alpha: 0.15)
                            : (isDark ? AppColors.darkSurfaceElevated : AppColors.warmCream),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.coral
                              : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(emoji, style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                          Text(
                            '$count',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected
                                  ? AppColors.coral
                                  : (isDark ? AppColors.darkTextSecondary : AppColors.charcoal),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}


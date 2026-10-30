import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/avatar_stack.dart';
import '../../../core/widgets/bouncy_card.dart';
import '../../../services/campus_data_service.dart';

class CampusPulseWidget extends StatelessWidget {
  final Function(int tabIndex, {int? subIndex}) onNavigate;

  const CampusPulseWidget({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final dataService = CampusDataService();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pulseItems = dataService.getCampusPulseItems();

    if (pulseItems.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.coral,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.coral,
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Campus Pulse',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.charcoal,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.coral.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(
                      color: AppColors.coral,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              'Real-Time',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Horizontal scrolling pulse tiles
        SizedBox(
          height: 115,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: pulseItems.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = pulseItems[index];

              return BouncyCard(
                onTap: () {
                  if (item.category.contains('Event')) {
                    onNavigate(1, subIndex: 5);
                  } else if (item.category.contains('Opinion') || item.category.contains('Poll')) {
                    onNavigate(1, subIndex: 6);
                  } else if (item.category.contains('Community') || item.category.contains('Club')) {
                    onNavigate(1, subIndex: 5);
                  } else if (item.category.contains('Market')) {
                    onNavigate(1, subIndex: 1);
                  }
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 270,
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.pureWhite,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                      width: 1.2,
                    ),
                    boxShadow: AppColors.softShadow(Colors.black, blur: 8, offset: const Offset(0, 3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(item.emoji, style: const TextStyle(fontSize: 16)),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    item.category,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.coral,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item.timeAgo,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.secondaryText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.charcoal,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (item.avatars.isNotEmpty)
                            AvatarStack(
                              imageUrls: item.avatars,
                              radius: 10,
                              overlap: 6,
                            )
                          else
                            const SizedBox.shrink(),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: AppColors.goldenYellow.withValues(alpha: 0.22),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item.highlightText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF7A5405),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

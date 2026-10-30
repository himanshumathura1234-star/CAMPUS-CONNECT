import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../services/campus_data_service.dart';

class NotificationsSheet {
  static void show(BuildContext context) {
    final dataService = CampusDataService();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.pureWhite,
      builder: (ctx) {
        return ListenableBuilder(
          listenable: dataService,
          builder: (ctx, _) {
            final items = dataService.notifications;

            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.notifications_active_rounded, color: AppColors.coral, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Campus Notifications',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          dataService.markAllNotificationsAsRead();
                        },
                        child: const Text('Mark all as read', style: TextStyle(fontSize: 12, color: AppColors.coral)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Center(
                        child: Text('No new notifications', style: TextStyle(color: AppColors.secondaryText)),
                      ),
                    )
                  else
                    ...items.map((n) {
                      Color catColor = AppColors.coral;
                      IconData catIcon = Icons.notifications_rounded;
                      if (n.category == 'Study') {
                        catColor = AppColors.emerald;
                        catIcon = Icons.group_work_rounded;
                      } else if (n.category == 'Event') {
                        catColor = AppColors.coral;
                        catIcon = Icons.event_available_rounded;
                      } else if (n.category == 'Poll') {
                        catColor = AppColors.goldenYellow;
                        catIcon = Icons.poll_rounded;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: n.isRead
                              ? (isDark ? AppColors.darkSurfaceElevated.withValues(alpha: 0.5) : AppColors.warmCream)
                              : (isDark ? AppColors.darkSurfaceElevated : AppColors.pureWhite),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: n.isRead
                                ? (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder)
                                : AppColors.coral.withValues(alpha: 0.4),
                            width: n.isRead ? 1 : 1.4,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: catColor.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(catIcon, color: catColor, size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        n.title,
                                        style: TextStyle(
                                          fontWeight: n.isRead ? FontWeight.w600 : FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        n.timeAgo,
                                        style: const TextStyle(fontSize: 10, color: AppColors.secondaryText),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    n.message,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            );
          },
        );
      },
    );
  }
}


import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/bouncy_card.dart';
import '../../../core/widgets/gradient_action_button.dart';
import '../../../models/campus_models.dart';
import '../../../services/campus_data_service.dart';

class LostFoundCard extends StatelessWidget {
  final LostFoundItemModel item;
  final VoidCallback? onUpdate;

  const LostFoundCard({
    super.key,
    required this.item,
    this.onUpdate,
  });

  void _showDetails(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLost = item.itemType == 'lost';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.pureWhite,
      builder: (ctx) {
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isLost
                          ? AppColors.coral.withValues(alpha: 0.15)
                          : AppColors.emerald.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isLost ? '🔴 LOST ITEM' : '🟢 FOUND ITEM',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: isLost ? AppColors.coral : AppColors.emerald,
                      ),
                    ),
                  ),
                  Text(
                    item.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                item.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceElevated : AppColors.warmCream,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 18, color: AppColors.coral),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Location: ${item.location}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 18, color: AppColors.softLavender),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Reported by: ${item.reporterName} • ${item.timeAgo}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (item.isResolved)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Item Claimed / Recovered ✓',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          CampusDataService().resolveLostFoundItem(item.id);
                          Navigator.pop(ctx);
                          onUpdate?.call();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Item marked as recovered/resolved!')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          side: BorderSide(color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                        ),
                        child: const Text('Mark Resolved'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GradientActionButton(
                        label: 'Contact Reporter',
                        icon: Icons.phone_outlined,
                        gradient: isLost ? AppColors.coralGradient : AppColors.mintGradient,
                        height: 44,
                        borderRadius: 14,
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('📞 Contacting ${item.reporterName} at ${item.contactPhone}...'),
                              backgroundColor: AppColors.emerald,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLost = item.itemType == 'lost';

    return BouncyCard(
      onTap: () => _showDetails(context),
      child: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: isLost
                            ? AppColors.coral.withValues(alpha: 0.15)
                            : AppColors.emerald.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isLost ? 'LOST' : 'FOUND',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: isLost ? AppColors.coral : AppColors.emerald,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.category,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      item.timeAgo,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.place_outlined,
                      size: 15,
                      color: AppColors.coral,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                        ),
                      ),
                    ),
                    if (item.isResolved)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('Resolved', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
  }
}


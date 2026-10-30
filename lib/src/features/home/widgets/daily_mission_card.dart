import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/bouncy_card.dart';
import '../../../services/campus_data_service.dart';

class DailyMissionCard extends StatelessWidget {
  final Function(int tabIndex, {int? subIndex}) onNavigate;

  const DailyMissionCard({
    super.key,
    required this.onNavigate,
  });

  void _showCelebrationDialog(BuildContext context, CampusDataService dataService) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                gradient: AppColors.amberGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.goldenYellow,
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text('🎉', style: TextStyle(fontSize: 42)),
            ),
            const SizedBox(height: 18),
            const Text(
              'Daily Missions Conquered!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.charcoal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'You successfully completed all daily campus objectives. +100 Bonus XP has been added to your profile!',
              style: TextStyle(fontSize: 13, color: AppColors.secondaryText, height: 1.4),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.goldenYellow.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.goldenYellow),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('⚡ ', style: TextStyle(fontSize: 18)),
                  Text(
                    '+100 XP CREDITED',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF7A5405),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.coral,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Keep Exploring', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataService = CampusDataService();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final missions = dataService.getDailyMissions();
    final completedCount = missions.where((m) => m.isCompleted).length;
    final progress = missions.isEmpty ? 0.0 : completedCount / missions.length;
    final allCompleted = completedCount == missions.length;
    final isClaimed = dataService.dailyMissionsBonusClaimed;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
          width: 1.2,
        ),
        boxShadow: AppColors.softShadow(Colors.black, blur: 12, offset: const Offset(0, 4)),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: AppColors.amberGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppColors.glowShadow(AppColors.goldenYellow),
                    ),
                    alignment: Alignment.center,
                    child: const Text('🎯', style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Campus Missions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.charcoal,
                        ),
                      ),
                      Text(
                        '$completedCount of ${missions.length} completed',
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.secondaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.coral.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.coral.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('⚡ ', style: TextStyle(fontSize: 12)),
                    Text(
                      '+100 XP Bonus',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: AppColors.coral,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Progress Bar with percentage
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      allCompleted ? AppColors.emerald : AppColors.coral,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: allCompleted ? AppColors.emerald : AppColors.coral,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Missions checklist
          ...missions.map((mission) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: BouncyCard(
                onTap: () {
                  if (!mission.isCompleted) {
                    if (mission.actionTab == 'discover') {
                      onNavigate(1);
                    } else if (mission.actionTab == 'play') {
                      onNavigate(3);
                    } else if (mission.actionTab == 'profile') {
                      onNavigate(4);
                    }
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  decoration: BoxDecoration(
                    color: mission.isCompleted
                        ? AppColors.emerald.withValues(alpha: 0.08)
                        : (isDark ? AppColors.darkSurfaceElevated : AppColors.warmCream),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: mission.isCompleted
                          ? AppColors.emerald.withValues(alpha: 0.35)
                          : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: mission.isCompleted
                              ? AppColors.emerald
                              : Colors.grey.withValues(alpha: 0.2),
                        ),
                        alignment: Alignment.center,
                        child: mission.isCompleted
                            ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                            : Text(mission.emoji, style: const TextStyle(fontSize: 14)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mission.title,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                decoration: mission.isCompleted ? TextDecoration.lineThrough : null,
                                color: mission.isCompleted
                                    ? AppColors.secondaryText
                                    : (isDark ? AppColors.darkTextPrimary : AppColors.charcoal),
                              ),
                            ),
                            Text(
                              mission.description,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.goldenYellow.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '+${mission.xpReward} XP',
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF7A5405),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 6),

          // Bottom Claim Button when all completed
          if (allCompleted)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(
                  isClaimed ? Icons.check_circle_rounded : Icons.card_giftcard_rounded,
                  size: 18,
                ),
                label: Text(
                  isClaimed ? 'Bonus 100 XP Claimed ✓' : 'Claim +100 XP Reward!',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isClaimed ? Colors.grey : AppColors.emerald,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: isClaimed
                    ? null
                    : () {
                        final success = dataService.claimDailyMissionsReward();
                        if (success) {
                          _showCelebrationDialog(context, dataService);
                        }
                      },
              ),
            ),
        ],
      ),
    );
  }
}

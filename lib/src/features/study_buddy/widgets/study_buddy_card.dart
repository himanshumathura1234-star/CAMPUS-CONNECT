import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/bouncy_card.dart';
import '../../../core/widgets/gradient_action_button.dart';
import '../../../models/campus_models.dart';
import '../../../services/campus_data_service.dart';

class StudyBuddyCard extends StatelessWidget {
  final StudyBuddy buddy;
  final VoidCallback? onConnectChanged;

  const StudyBuddyCard({
    super.key,
    required this.buddy,
    this.onConnectChanged,
  });

  Color _getScoreColor() {
    if (buddy.compatibilityScore >= 90) return AppColors.emerald;
    if (buddy.compatibilityScore >= 80) return AppColors.coral;
    return AppColors.goldenYellow;
  }

  void _showCompatibilityDetail(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scoreColor = _getScoreColor();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.pureWhite,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
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
              const SizedBox(height: 20),
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: scoreColor.withValues(alpha: 0.15),
                    child: Text(
                      buddy.fullName[0],
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: scoreColor),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          buddy.fullName,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${buddy.department} • Sem ${buddy.semester}',
                          style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: scoreColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${buddy.compatibilityScore}%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: scoreColor,
                          ),
                        ),
                        Text(
                          'Match',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: scoreColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Why You Two Match (Explainable AI)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 10),
              ...buddy.compatibilityReasons.map((reason) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.accentMint),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            reason,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.mainText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time_filled_rounded, size: 16, color: AppColors.primaryIndigo),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Available: ${buddy.preferredStudyTimes}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GradientActionButton(
                label: buddy.requestStatus == 'accepted'
                    ? 'Connected (Message on WhatsApp)'
                    : (buddy.requestStatus == 'pending'
                        ? 'Request Pending (Tap to Cancel)'
                        : 'Send Study Buddy Request'),
                icon: buddy.requestStatus == 'accepted'
                    ? Icons.chat_bubble_outline
                    : (buddy.requestStatus == 'pending'
                        ? Icons.hourglass_top_rounded
                        : Icons.person_add_alt_1_rounded),
                gradient: buddy.requestStatus == 'accepted'
                    ? AppColors.mintGradient
                    : AppColors.primaryGradient,
                onPressed: () {
                  Navigator.pop(ctx);
                  CampusDataService().toggleStudyBuddyConnect(buddy.userId);
                  onConnectChanged?.call();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        buddy.requestStatus == 'pending'
                            ? 'Request sent to ${buddy.fullName}!'
                            : 'Request cancelled for ${buddy.fullName}',
                      ),
                      backgroundColor: buddy.requestStatus == 'pending' ? AppColors.coral : AppColors.secondaryText,
                    ),
                  );
                },
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
    final scoreColor = _getScoreColor();

    return BouncyCard(
      onTap: () => _showCompatibilityDetail(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: AppColors.softLavender.withValues(alpha: 0.35),
                      child: Text(
                        buddy.fullName[0],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF5B41A8),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 13,
                        height: 13,
                        decoration: BoxDecoration(
                          color: AppColors.emerald,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              buddy.fullName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.charcoal,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                            decoration: BoxDecoration(
                              color: scoreColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.bolt_rounded, color: scoreColor, size: 13),
                                Text(
                                  '${buddy.compatibilityScore}% Match',
                                  style: TextStyle(
                                    color: scoreColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${buddy.department} • Sem ${buddy.semester}',
                        style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 12, color: AppColors.secondaryText),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              buddy.preferredStudyMode,
                              style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: buddy.skills.map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceElevated : AppColors.warmCream,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                    ),
                  ),
                  child: Text(
                    skill,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.charcoal,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showCompatibilityDetail(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      side: BorderSide(
                        color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Why Match?', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GradientActionButton(
                    label: buddy.requestStatus == 'accepted'
                        ? 'Connected'
                        : (buddy.requestStatus == 'pending' ? 'Pending' : 'Connect'),
                    icon: buddy.requestStatus == 'accepted'
                        ? Icons.check
                        : (buddy.requestStatus == 'pending' ? Icons.hourglass_top : Icons.person_add),
                    height: 38,
                    borderRadius: 12,
                    gradient: buddy.requestStatus == 'accepted'
                        ? AppColors.mintGradient
                        : (buddy.requestStatus == 'pending'
                            ? const LinearGradient(colors: [Colors.grey, Colors.black45])
                            : AppColors.coralGradient),
                    onPressed: () {
                      CampusDataService().toggleStudyBuddyConnect(buddy.userId);
                      onConnectChanged?.call();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            buddy.requestStatus == 'pending'
                                ? 'Connection request sent to ${buddy.fullName}!'
                                : 'Request updated for ${buddy.fullName}',
                          ),
                          backgroundColor: AppColors.emerald,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/avatar_stack.dart';
import '../../../core/widgets/bouncy_card.dart';
import '../../../core/widgets/gradient_action_button.dart';
import '../../../models/campus_models.dart';
import '../../../services/campus_data_service.dart';

class CommunityCard extends StatelessWidget {
  final CampusCommunity community;
  final VoidCallback? onJoinChanged;

  const CommunityCard({
    super.key,
    required this.community,
    this.onJoinChanged,
  });

  void _showCommunityDetails(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
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
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: AppColors.mintGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppColors.glowShadow(AppColors.emerald),
                    ),
                    alignment: Alignment.center,
                    child: Text(community.iconEmoji, style: const TextStyle(fontSize: 28)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          community.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.charcoal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.emerald.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                community.category,
                                style: const TextStyle(
                                  color: AppColors.emerald,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${community.memberCount} members',
                              style: const TextStyle(fontSize: 12, color: AppColors.secondaryText, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Text(
                community.description,
                style: const TextStyle(fontSize: 13, height: 1.5, color: AppColors.secondaryText),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month_rounded, size: 16, color: AppColors.accentCoral),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        community.meetingSchedule,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text('Recent Discussions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              ...community.recentDiscussions.map((d) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.chat_bubble_outline_rounded, size: 14, color: AppColors.secondaryText),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            d,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.mainText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 24),
              GradientActionButton(
                label: community.isJoined ? 'Leave Club' : 'Join Community (+15 Pts)',
                icon: community.isJoined ? Icons.logout : Icons.group_add_rounded,
                gradient: community.isJoined
                    ? const LinearGradient(colors: [Colors.grey, Colors.black45])
                    : AppColors.primaryGradient,
                onPressed: () {
                  Navigator.pop(ctx);
                  CampusDataService().toggleCommunityMembership(community.id);
                  onJoinChanged?.call();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        community.isJoined
                            ? '🎉 Welcome to ${community.name}!'
                            : 'Left ${community.name}',
                      ),
                      backgroundColor: community.isJoined ? AppColors.accentMint : AppColors.secondaryText,
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

    return BouncyCard(
      onTap: () => _showCommunityDetails(context),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: AppColors.mintGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppColors.glowShadow(AppColors.emerald),
              ),
              alignment: Alignment.center,
              child: Text(community.iconEmoji, style: const TextStyle(fontSize: 26)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          community.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.charcoal,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.emerald.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          community.category,
                          style: const TextStyle(
                            color: AppColors.emerald,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      AvatarStack(
                        imageUrls: const [
                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
                          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
                          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
                        ],
                        totalCount: community.memberCount,
                        radius: 10,
                        overlap: 6,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${community.memberCount} members • ${community.meetingSchedule}',
                        style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    community.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.charcoal,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () => _showCommunityDetails(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          side: BorderSide(
                            color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Discussions', style: TextStyle(fontSize: 11)),
                      ),
                      const Spacer(),
                      GradientActionButton(
                        label: community.isJoined ? 'Joined ✓' : 'Join',
                        width: 96,
                        height: 36,
                        borderRadius: 12,
                        gradient: community.isJoined
                            ? AppColors.mintGradient
                            : AppColors.coralGradient,
                        onPressed: () {
                          CampusDataService().toggleCommunityMembership(community.id);
                          onJoinChanged?.call();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                community.isJoined
                                    ? '🎉 Joined ${community.name}!'
                                    : 'Left ${community.name}',
                              ),
                              backgroundColor: AppColors.emerald,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


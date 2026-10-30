import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/campus_models.dart';
import '../../../services/campus_data_service.dart';

class PollCard extends StatelessWidget {
  final CampusPollModel poll;
  final VoidCallback? onVoted;

  const PollCard({
    super.key,
    required this.poll,
    this.onVoted,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasVoted = poll.userVotedIndex != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
          width: 1.2,
        ),
        boxShadow: AppColors.softShadow(Colors.black, blur: 12, offset: const Offset(0, 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.coral.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.poll_rounded, color: AppColors.coral, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      poll.category,
                      style: const TextStyle(
                        color: AppColors.coral,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${poll.totalVotes} votes • ${poll.timeLeft}',
                style: const TextStyle(fontSize: 11, color: AppColors.secondaryText, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            poll.question,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              height: 1.3,
              color: isDark ? AppColors.darkTextPrimary : AppColors.charcoal,
            ),
          ),
          const SizedBox(height: 16),
          ...poll.options.map((opt) {
            final isSelected = poll.userVotedIndex == opt.index;
            final pct = poll.totalVotes > 0
                ? (opt.votes / poll.totalVotes).clamp(0.0, 1.0)
                : 0.0;
            final pctText = '${(pct * 100).round()}%';

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: hasVoted
                    ? null
                    : () {
                        CampusDataService().votePoll(poll.id, opt.index);
                        onVoted?.call();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('🗳️ Vote recorded for "${opt.text}" (+10 Points)!'),
                            duration: const Duration(seconds: 2),
                            backgroundColor: AppColors.emerald,
                          ),
                        );
                      },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceElevated : AppColors.warmCream,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.coral
                          : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                      width: isSelected ? 2.0 : 1.2,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Animated Progress fill
                      if (hasVoted)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: FractionallySizedBox(
                            widthFactor: pct,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              color: isSelected
                                  ? AppColors.coral.withValues(alpha: 0.25)
                                  : AppColors.goldenYellow.withValues(alpha: 0.25),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                if (isSelected)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(Icons.check_circle_rounded, size: 16, color: AppColors.coral),
                                  ),
                                Text(
                                  opt.text,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.charcoal,
                                  ),
                                ),
                              ],
                            ),
                            if (hasVoted)
                              Text(
                                '$pctText (${opt.votes})',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected ? AppColors.coral : AppColors.secondaryText,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/avatar_stack.dart';
import '../../../core/widgets/bouncy_card.dart';
import '../../../core/widgets/gradient_action_button.dart';
import '../../../models/campus_models.dart';
import '../../../services/campus_data_service.dart';

class EventCard extends StatelessWidget {
  final CampusEvent event;
  final VoidCallback? onRegisterChanged;

  const EventCard({
    super.key,
    required this.event,
    this.onRegisterChanged,
  });

  Color _getCategoryColor() {
    switch (event.category) {
      case 'Hackathon':
        return AppColors.coral;
      case 'Workshop':
        return AppColors.emerald;
      case 'Cultural':
        return AppColors.softLavender;
      case 'Sports':
        return AppColors.goldenYellow;
      default:
        return AppColors.coral;
    }
  }

  LinearGradient _getGradient() {
    switch (event.bannerGradient) {
      case 'primary':
        return AppColors.heroGradient;
      case 'mint':
        return AppColors.mintGradient;
      case 'coral':
        return AppColors.coralGradient;
      case 'amber':
        return AppColors.amberGradient;
      default:
        return AppColors.heroGradient;
    }
  }

  void _showEventDetailsSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final catColor = _getCategoryColor();

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: catColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      event.category,
                      style: TextStyle(
                        color: catColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    '${event.registeredCount} / ${event.capacity} Registered',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                event.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Organized by: ${event.organizer}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceElevated : AppColors.warmCream,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.coral),
                        const SizedBox(width: 8),
                        Text(event.dateString, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.schedule_rounded, size: 16, color: AppColors.goldenYellow),
                        const SizedBox(width: 8),
                        Text(event.timeString, style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, size: 16, color: AppColors.emerald),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            event.venue,
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('About Event', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 6),
              Text(
                event.description,
                style: const TextStyle(fontSize: 13, height: 1.5, color: AppColors.secondaryText),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: event.tags
                    .map((tag) => Chip(
                          label: Text('#$tag', style: const TextStyle(fontSize: 11)),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero,
                          backgroundColor: isDark ? AppColors.darkSurfaceElevated : AppColors.warmCream,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
              GradientActionButton(
                label: event.isRegistered ? 'Cancel Registration' : 'Confirm Registration (Free Pass)',
                icon: event.isRegistered ? Icons.cancel_outlined : Icons.confirmation_number_outlined,
                gradient: event.isRegistered
                    ? const LinearGradient(colors: [Colors.grey, Colors.black45])
                    : AppColors.heroGradient,
                onPressed: () {
                  Navigator.pop(ctx);
                  CampusDataService().toggleEventRegistration(event.id);
                  onRegisterChanged?.call();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        event.isRegistered
                            ? '✅ Registered for ${event.title}! (+20 Points)'
                            : 'Registration cancelled for ${event.title}',
                      ),
                      backgroundColor: event.isRegistered ? AppColors.emerald : AppColors.secondaryText,
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
    final catColor = _getCategoryColor();
    final pct = (event.registeredCount / event.capacity).clamp(0.0, 1.0);

    return BouncyCard(
      onTap: () => _showEventDetailsSheet(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
            // Event Top Graphic Banner
            Container(
              height: 104,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: _getGradient(),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.stars, color: Colors.white, size: 13),
                            const SizedBox(width: 4),
                            Text(
                              event.category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (event.isRegistered)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.emerald,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle, color: Colors.white, size: 12),
                              SizedBox(width: 4),
                              Text(
                                'Pass Booked',
                                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  Text(
                    event.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Card Body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.schedule_rounded, size: 14, color: AppColors.coral),
                      const SizedBox(width: 5),
                      Text(
                        '${event.dateString} • ${event.timeString}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.charcoal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.place_outlined, size: 14, color: AppColors.secondaryText),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          event.venue,
                          style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Attendees AvatarStack & Capacity Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          AvatarStack(
                            imageUrls: const [
                              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
                              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
                              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
                            ],
                            totalCount: event.registeredCount,
                            radius: 11,
                            overlap: 8,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${event.registeredCount} of ${event.capacity} seats',
                            style: const TextStyle(fontSize: 11, color: AppColors.secondaryText, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: (pct > 0.85 ? AppColors.coral : catColor).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${(pct * 100).toInt()}% filled',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: pct > 0.85 ? AppColors.coral : catColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 5,
                      backgroundColor: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        pct > 0.85 ? AppColors.coral : catColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showEventDetailsSheet(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            side: BorderSide(
                              color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                            ),
                          ),
                          child: const Text('Details', style: TextStyle(fontSize: 13)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GradientActionButton(
                          label: event.isRegistered ? 'Going ✓' : 'RSVP',
                          height: 40,
                          borderRadius: 14,
                          gradient: event.isRegistered
                              ? AppColors.mintGradient
                              : AppColors.heroGradient,
                          onPressed: () {
                            CampusDataService().toggleEventRegistration(event.id);
                            onRegisterChanged?.call();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  event.isRegistered
                                      ? 'Registration cancelled for ${event.title}'
                                      : '✅ Registered for ${event.title}! (+20 Points)',
                                ),
                                duration: const Duration(seconds: 2),
                                backgroundColor: event.isRegistered ? AppColors.secondaryText : AppColors.emerald,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


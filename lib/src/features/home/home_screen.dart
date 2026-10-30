import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/bouncy_card.dart';
import '../../models/campus_models.dart';
import '../../services/campus_data_service.dart';
import '../events/widgets/event_card.dart';
import '../study_buddy/widgets/study_buddy_card.dart';
import '../communities/widgets/community_card.dart';
import '../confessions_polls/widgets/poll_card.dart';
import 'widgets/interactive_feature_carousel.dart';
import 'widgets/daily_mission_card.dart';
import 'widgets/campus_pulse_widget.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int tabIndex, {int? subIndex}) onNavigateTab;
  final VoidCallback onOpenNotifications;

  const HomeScreen({
    super.key,
    required this.onNavigateTab,
    required this.onOpenNotifications,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CampusDataService _dataService = CampusDataService();
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showAnnouncementDetail(BuildContext context, CampusAnnouncementModel ann) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    _dataService.markAnnouncementRead(ann.id);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.pureWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.coral.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                ann.category.toUpperCase(),
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.coral),
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text('Official Notice', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ann.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'Issued by: ${ann.authorName} • ${ann.timeAgo}',
              style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText),
            ),
            const SizedBox(height: 12),
            Text(ann.content, style: const TextStyle(fontSize: 13, height: 1.45)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.coral)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: _dataService,
      builder: (context, _) {
        final user = _dataService.currentUser;
        final featuredEvent = _dataService.events.isNotEmpty ? _dataService.events.first : null;
        final studyBuddies = _dataService.studyBuddies.take(2).toList();
        final communities = _dataService.communities.take(2).toList();
        final activePoll = _dataService.polls.isNotEmpty ? _dataService.polls.first : null;
        final streak = _dataService.streakInfo;
        final announcements = _dataService.announcements;

        return RefreshIndicator(
          color: AppColors.coral,
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.pureWhite,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 400));
            setState(() {});
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Personalized Header Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'GL Bajaj Institute',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondaryText,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: AppColors.emerald.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Mathura Campus',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.emerald,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Hey, ${user.fullName.split(' ').first} 👋',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.charcoal,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Notifications Bell
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkSurfaceElevated : AppColors.pureWhite,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                                ),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.notifications_none_rounded, size: 22),
                                onPressed: widget.onOpenNotifications,
                              ),
                            ),
                            if (_dataService.unreadNotificationsCount > 0)
                              Positioned(
                                right: 6,
                                top: 6,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: AppColors.coral,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${_dataService.unreadNotificationsCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        // Avatar with Level Ring
                        GestureDetector(
                          onTap: () => widget.onNavigateTab(4), // Profile Tab
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(2.5),
                                decoration: const BoxDecoration(
                                  gradient: AppColors.coralGradient,
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  radius: 19,
                                  backgroundColor: AppColors.peach,
                                  child: Text(
                                    user.fullName[0],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.charcoal,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: AppColors.emerald,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isDark ? AppColors.darkBackground : AppColors.pureWhite,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 2. Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.pureWhite,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                      width: 1.2,
                    ),
                    boxShadow: AppColors.softShadow(Colors.black, blur: 10, offset: const Offset(0, 3)),
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Search textbooks, lost items, PYQs, buddies...',
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.coral),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // 3. CAMPUS POP WELCOME & "YOUR CAMPUS TODAY" HERO BANNER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.heroGradient,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: AppColors.glowShadow(AppColors.coral),
                  ),
                  child: Stack(
                    children: [
                      // Decorative background circles for Pop aesthetic
                      Positioned(
                        right: -20,
                        top: -30,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 40,
                        bottom: -40,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.goldenYellow.withValues(alpha: 0.20),
                          ),
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Pills Row: Streak + XP + Check-in
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.20),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Row(
                                      children: [
                                        const Text('🔥 ', style: TextStyle(fontSize: 13)),
                                        Text(
                                          '${streak.currentStreak}-Day Streak',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: AppColors.goldenYellow,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${user.totalPoints} XP',
                                      style: const TextStyle(
                                        color: AppColors.charcoal,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Daily Check-In Button
                              InkWell(
                                onTap: () {
                                  if (!streak.hasCheckedInToday) {
                                    _dataService.checkInDailyStreak();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('🎉 Daily Check-in Complete! +50 XP Earned!'),
                                        backgroundColor: AppColors.emerald,
                                      ),
                                    );
                                  }
                                },
                                borderRadius: BorderRadius.circular(14),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: streak.hasCheckedInToday
                                        ? Colors.white.withValues(alpha: 0.25)
                                        : AppColors.pureWhite,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: streak.hasCheckedInToday ? null : AppColors.softShadow(Colors.black),
                                  ),
                                  child: Text(
                                    streak.hasCheckedInToday ? 'Checked-In ✓' : 'Check In (+50 XP)',
                                    style: TextStyle(
                                      color: streak.hasCheckedInToday ? Colors.white : AppColors.coral,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          const Text(
                            'Your Campus Today',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'One Campus. One Community. Endless Connections.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Live Notice Ticker Pill inside Welcome Banner
                          if (announcements.isNotEmpty)
                            GestureDetector(
                              onTap: () => _showAnnouncementDetail(context, announcements.first),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    const Text('📢', style: TextStyle(fontSize: 14)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        announcements.first.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 12),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // 4. INTERACTIVE FEATURE CAROUSEL (Snapping carousel across 8 campus verticals with dedicated gradients)
                InteractiveFeatureCarousel(
                  onNavigate: widget.onNavigateTab,
                ),

                const SizedBox(height: 24),

                // 5. CAMPUS PULSE (Real-time live activity stream with live pulse badge & avatar stacks)
                CampusPulseWidget(
                  onNavigate: widget.onNavigateTab,
                ),

                const SizedBox(height: 24),

                // 6. DAILY MISSION GAMIFICATION CARD (Interactive checklist, live progress tracking & celebratory XP claim)
                DailyMissionCard(
                  onNavigate: widget.onNavigateTab,
                ),

                const SizedBox(height: 24),

                // 7. COLORFUL QUICK-ACCESS FEATURE TILES (Campus Essentials)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Campus Essentials',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    TextButton(
                      onPressed: () => widget.onNavigateTab(1), // Discover
                      child: const Text(
                        'View All 7 Hubs →',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.coral),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // 2x3 Grid of Playful Pop Feature Tiles
                Row(
                  children: [
                    _buildPopTile(
                      emoji: '🤝',
                      title: 'Study Buddies',
                      subtitle: 'AI Matching',
                      color: AppColors.softLavender,
                      textColor: const Color(0xFF4A348F),
                      onTap: () => widget.onNavigateTab(1, subIndex: 0),
                    ),
                    const SizedBox(width: 12),
                    _buildPopTile(
                      emoji: '🛍️',
                      title: 'Marketplace',
                      subtitle: 'Books & Swap',
                      color: AppColors.peach,
                      textColor: const Color(0xFF943D2A),
                      onTap: () => widget.onNavigateTab(1, subIndex: 1),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildPopTile(
                      emoji: '🔍',
                      title: 'Lost & Found',
                      subtitle: 'Active Reports',
                      color: AppColors.goldenYellow,
                      textColor: const Color(0xFF7A5405),
                      onTap: () => widget.onNavigateTab(1, subIndex: 2),
                    ),
                    const SizedBox(width: 12),
                    _buildPopTile(
                      emoji: '❓',
                      title: 'Campus Q&A',
                      subtitle: 'Ask Seniors',
                      color: AppColors.emerald.withValues(alpha: 0.18),
                      textColor: AppColors.emerald,
                      onTap: () => widget.onNavigateTab(1, subIndex: 3),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildPopTile(
                      emoji: '📚',
                      title: 'Notes & PYQs',
                      subtitle: 'Curated PDFs',
                      color: AppColors.coral.withValues(alpha: 0.16),
                      textColor: const Color(0xFFC43823),
                      onTap: () => widget.onNavigateTab(1, subIndex: 4),
                    ),
                    const SizedBox(width: 12),
                    _buildPopTile(
                      emoji: '🤫',
                      title: 'Secret Wall',
                      subtitle: '100% Private',
                      color: AppColors.softLavender.withValues(alpha: 0.4),
                      textColor: const Color(0xFF4A348F),
                      onTap: () => widget.onNavigateTab(1, subIndex: 6),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 6. Flagship Event Card
                if (featuredEvent != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Flagship Campus Event',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                      TextButton(
                        onPressed: () => widget.onNavigateTab(1),
                        child: const Text('View All', style: TextStyle(fontSize: 13, color: AppColors.coral)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  EventCard(
                    event: featuredEvent,
                    onRegisterChanged: () => setState(() {}),
                  ),
                  const SizedBox(height: 20),
                ],

                // 7. Recommended Study Buddies
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'AI Recommended Study Buddies',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    TextButton(
                      onPressed: () => widget.onNavigateTab(1),
                      child: const Text('See Matches', style: TextStyle(fontSize: 13, color: AppColors.coral)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ...studyBuddies.map(
                  (buddy) => StudyBuddyCard(
                    buddy: buddy,
                    onConnectChanged: () => setState(() {}),
                  ),
                ),

                const SizedBox(height: 20),

                // 8. Active Campus Poll
                if (activePoll != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Trending Campus Poll',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.goldenYellow.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          activePoll.timeLeft,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF7A5405),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  PollCard(
                    poll: activePoll,
                    onVoted: () => setState(() {}),
                  ),
                  const SizedBox(height: 20),
                ],

                // 9. Trending Communities
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Active Clubs & Communities',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    TextButton(
                      onPressed: () => widget.onNavigateTab(1),
                      child: const Text('Explore', style: TextStyle(fontSize: 13, color: AppColors.coral)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ...communities.map(
                  (comm) => CommunityCard(
                    community: comm,
                    onJoinChanged: () => setState(() {}),
                  ),
                ),

                const SizedBox(height: 20),

                // 10. Official Announcements Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text('📢 ', style: TextStyle(fontSize: 18)),
                        Text(
                          'Official Campus Notices',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    Text(
                      '${announcements.length} Notices',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...announcements.take(2).map((ann) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : AppColors.pureWhite,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: ann.isPinned
                              ? AppColors.coral.withValues(alpha: 0.6)
                              : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                          width: ann.isPinned ? 1.5 : 1.0,
                        ),
                      ),
                      child: InkWell(
                        onTap: () => _showAnnouncementDetail(context, ann),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.coral.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.campaign_rounded, color: AppColors.coral, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ann.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${ann.authorName} • ${ann.timeAgo}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!ann.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.coral,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ),
                    )),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopTile({
    required String emoji,
    required String title,
    required String subtitle,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: BouncyCard(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 26)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: textColor,
                      ),
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: textColor.withValues(alpha: 0.8),
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
  }
}

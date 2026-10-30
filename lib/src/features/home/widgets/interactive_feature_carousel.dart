import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/bouncy_card.dart';

class FeatureCarouselItem {
  final String title;
  final String badge;
  final String description;
  final String emoji;
  final LinearGradient gradient;
  final Color accentColor;
  final int targetTab; // 1: Discover, 2: Create, 3: Play, 4: Profile
  final int? discoverSubIndex;

  const FeatureCarouselItem({
    required this.title,
    required this.badge,
    required this.description,
    required this.emoji,
    required this.gradient,
    required this.accentColor,
    required this.targetTab,
    this.discoverSubIndex,
  });
}

class InteractiveFeatureCarousel extends StatefulWidget {
  final Function(int tabIndex, {int? subIndex}) onNavigate;

  const InteractiveFeatureCarousel({
    super.key,
    required this.onNavigate,
  });

  @override
  State<InteractiveFeatureCarousel> createState() =>
      _InteractiveFeatureCarouselState();
}

class _InteractiveFeatureCarouselState
    extends State<InteractiveFeatureCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;

  static const List<FeatureCarouselItem> _items = [
    FeatureCarouselItem(
      title: 'Study Buddy Finder',
      badge: '🤝 AI Matchmaking',
      description: 'Match with 90%+ compatible peers for exams and projects.',
      emoji: '🧠',
      gradient: AppColors.lavenderGradient,
      accentColor: Color(0xFF5B41A8),
      targetTab: 1,
      discoverSubIndex: 0,
    ),
    FeatureCarouselItem(
      title: 'Hackbriven & Events',
      badge: '🎪 Free Passes',
      description: 'Register for 36-hr hackathons, tech workshops & fests.',
      emoji: '🚀',
      gradient: AppColors.coralGradient,
      accentColor: AppColors.coral,
      targetTab: 1,
      discoverSubIndex: 5,
    ),
    FeatureCarouselItem(
      title: 'Student Marketplace',
      badge: '📦 Buy & Swap',
      description: 'Buy and exchange textbooks, calculators & drafters.',
      emoji: '🛍️',
      gradient: AppColors.peachGradient,
      accentColor: Color(0xFFC43823),
      targetTab: 1,
      discoverSubIndex: 1,
    ),
    FeatureCarouselItem(
      title: 'Lost & Found Vault',
      badge: '🔍 Campus Recovery',
      description: 'Quickly report or claim lost earphones, keys and IDs.',
      emoji: '📍',
      gradient: AppColors.amberGradient,
      accentColor: Color(0xFFC78500),
      targetTab: 1,
      discoverSubIndex: 2,
    ),
    FeatureCarouselItem(
      title: 'Active Clubs & GDG',
      badge: '🌱 Join Communities',
      description: 'Collaborate with campus chapters, tech and cultural societies.',
      emoji: '👥',
      gradient: AppColors.mintGradient,
      accentColor: AppColors.emerald,
      targetTab: 1,
      discoverSubIndex: 5,
    ),
    FeatureCarouselItem(
      title: 'Campus Quiz Battles',
      badge: '⚡ Compete for XP',
      description: 'Daily CS knowledge questions and global leaderboard.',
      emoji: '🏆',
      gradient: AppColors.amberGradient,
      accentColor: Color(0xFFC78500),
      targetTab: 3,
    ),
    FeatureCarouselItem(
      title: 'Campus Treasure Hunt',
      badge: '🗺️ Mystery Quest',
      description: 'Solve real riddles around GL Bajaj to unlock badges.',
      emoji: '🗝️',
      gradient: AppColors.coralGradient,
      accentColor: AppColors.coral,
      targetTab: 3,
    ),
    FeatureCarouselItem(
      title: 'Curated Notes & PYQs',
      badge: '📚 AKTU Question Bank',
      description: 'Download verified handwritten notes and semester solutions.',
      emoji: '📖',
      gradient: AppColors.lavenderGradient,
      accentColor: Color(0xFF5B41A8),
      targetTab: 1,
      discoverSubIndex: 4,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 184,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _items.length,
            onPageChanged: (idx) => setState(() => _currentPage = idx),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final item = _items[index];
              final isFocused = _currentPage == index;

              return AnimatedPadding(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: isFocused ? 0 : 6,
                ),
                child: BouncyCard(
                  onTap: () {
                    widget.onNavigate(item.targetTab, subIndex: item.discoverSubIndex);
                  },
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: item.gradient,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: AppColors.glowShadow(item.gradient.colors.first),
                    ),
                    child: Stack(
                      children: [
                        // Decorative Background Shapes
                        Positioned(
                          right: -25,
                          top: -25,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 35,
                          bottom: -35,
                          child: Container(
                            width: 85,
                            height: 85,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.12),
                            ),
                          ),
                        ),

                        // Card Content
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4.5),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.18),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: Text(
                                      item.badge,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.25),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      item.emoji,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: AppColors.pureWhite,
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: AppColors.softShadow(Colors.black, blur: 6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Explore',
                                          style: TextStyle(
                                            color: item.gradient.colors.first,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 13,
                                          color: item.gradient.colors.first,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_items.length, (idx) {
            final isCurrent = _currentPage == idx;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isCurrent ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isCurrent
                    ? AppColors.coral
                    : AppColors.coral.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}

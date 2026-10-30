import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/bouncy_card.dart';
import '../../core/widgets/gradient_action_button.dart';
import '../../services/campus_data_service.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CampusDataService _dataService = CampusDataService();
  final TextEditingController _riddleAnswerCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _riddleAnswerCtrl.dispose();
    super.dispose();
  }

  void _onAnswerSubmitted() {
    final ans = _riddleAnswerCtrl.text;
    if (ans.trim().isEmpty) return;

    final success = _dataService.submitTreasureAnswer(ans);
    if (success) {
      _riddleAnswerCtrl.clear();
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('🎉 Riddle Solved!'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🏆', style: TextStyle(fontSize: 48)),
              SizedBox(height: 12),
              Text(
                'Correct! You unlocked the Central Library Clue checkpoint!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                '+50 Campus Points earned & "Campus Detective" badge unlocked!',
                style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Claim Reward & Continue'),
            )
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Not quite! Think carefully about where books and quiet study live on campus.'),
          backgroundColor: AppColors.coral,
        ),
      );
    }
  }

  void _confirmHint() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reveal Hint?'),
        content: const Text(
          'Using a hint costs a -15 Campus Points penalty on your score. Do you want to reveal the clue hint?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentAmber),
            onPressed: () {
              Navigator.pop(ctx);
              _dataService.revealTreasureHint();
            },
            child: const Text('Reveal (-15 Pts)'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _dataService,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Play & Compete', style: TextStyle(fontWeight: FontWeight.bold)),
            bottom: TabBar(
              controller: _tabController,
              labelColor: AppColors.coral,
              unselectedLabelColor: AppColors.secondaryText,
              indicatorColor: AppColors.coral,
              indicatorWeight: 3.5,
              labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
              tabs: const [
                Tab(
                  icon: Icon(Icons.explore_rounded),
                  text: 'Treasure Hunt',
                ),
                Tab(
                  icon: Icon(Icons.bolt_rounded),
                  text: 'Quiz Battles',
                ),
                Tab(
                  icon: Icon(Icons.leaderboard_rounded),
                  text: 'Leaderboard',
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildTreasureHuntTab(),
              _buildQuizBattlesTab(),
              _buildLeaderboardTab(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTreasureHuntTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hunt = _dataService.treasureHunt;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Adventure Hero Card
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: AppColors.coralGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: AppColors.glowShadow(AppColors.accentCoral),
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
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '🗺️ Campus Quest: Phase 1',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      'Score: ${hunt.userScore} Pts',
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  hunt.isCompleted ? '🎉 Quest Solved!' : hunt.stageTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  hunt.isCompleted
                      ? 'Congratulations! You solved the mystery of the knowledge gateway. Check back next Friday for Phase 2!'
                      : hunt.riddle,
                  style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.45),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Reward: +${hunt.rewardPoints} Pts • Badge: ${hunt.rewardBadge}',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Clue Submission Card
          if (!hunt.isCompleted) ...[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.pureWhite,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                  width: 1.2,
                ),
                boxShadow: AppColors.softShadow(Colors.black, blur: 8, offset: const Offset(0, 3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enter Riddle Solution', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  const SizedBox(height: 4),
                  const Text('Submit the single-word location name (e.g., LIBRARY, LAB, AUDITORIUM)', style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _riddleAnswerCtrl,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            hintText: 'e.g. LIBRARY',
                            prefixIcon: Icon(Icons.vpn_key_rounded, color: AppColors.coral),
                          ),
                          onSubmitted: (_) => _onAnswerSubmitted(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GradientActionButton(
                        label: 'Verify',
                        width: 90,
                        gradient: AppColors.coralGradient,
                        onPressed: _onAnswerSubmitted,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (!hunt.hintRevealed)
                    OutlinedButton.icon(
                      icon: const Icon(Icons.lightbulb_outline_rounded, size: 16, color: AppColors.goldenYellow),
                      label: const Text('Need a Hint? (-15 Pts penalty)'),
                      onPressed: _confirmHint,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF8A5E00),
                        side: const BorderSide(color: AppColors.goldenYellow),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.goldenYellow.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.goldenYellow.withValues(alpha: 0.35)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb, color: AppColors.goldenYellow, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '💡 Hint: ${hunt.locationHint}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.emerald.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.emerald.withValues(alpha: 0.35)),
              ),
              child: const Row(
                children: [
                  Text('🏅', style: TextStyle(fontSize: 32)),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Campus Detective Unlocked', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 2),
                        Text('Badge proudly displayed on your student profile!', style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Campus Leaderboard Highlights
          const Text('Top Campus Adventurers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          _buildLeaderboardTile(rank: 1, name: 'Siddharth Roy', score: 680, avatar: 'S'),
          _buildLeaderboardTile(rank: 2, name: 'Aarav Sharma (You)', score: hunt.userScore, avatar: 'A', isCurrentUser: true),
          _buildLeaderboardTile(rank: 3, name: 'Neha Gupta', score: 410, avatar: 'N'),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTile({
    required int rank,
    required String name,
    required int score,
    required String avatar,
    bool isCurrentUser = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? AppColors.coral.withValues(alpha: 0.12)
            : (isDark ? AppColors.darkSurface : AppColors.pureWhite),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrentUser
              ? AppColors.coral
              : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
        ),
      ),
      child: Row(
        children: [
          Text(
            '#$rank',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: rank == 1 ? AppColors.goldenYellow : AppColors.secondaryText,
            ),
          ),
          const SizedBox(width: 14),
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.softLavender.withValues(alpha: 0.35),
            child: Text(avatar, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF5B41A8))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.w600, fontSize: 14),
            ),
          ),
          Text(
            '$score Pts',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.coral),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizBattlesTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final questions = _dataService.quizQuestions;

    if (_dataService.quizCompleted) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🏆', style: TextStyle(fontSize: 54)),
              const SizedBox(height: 14),
              const Text('Battle Completed!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(
                'You scored ${_dataService.quizScore} / ${questions.length * 25} Points',
                style: const TextStyle(fontSize: 16, color: AppColors.primaryIndigo, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Great effort! Consistency on daily battles boosts your Campus Life rank.',
                style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              GradientActionButton(
                label: 'Play Again',
                width: 160,
                onPressed: () => _dataService.resetQuiz(),
              ),
            ],
          ),
        ),
      );
    }

    final currentQ = questions[_dataService.quizCurrentIndex];
    final progress = (_dataService.quizCurrentIndex + 1) / questions.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Header Card
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_dataService.quizCurrentIndex + 1} of ${questions.length}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.secondaryText),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.goldenYellow.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Streak: ${_dataService.quizStreak} 🔥',
                  style: const TextStyle(color: Color(0xFF7A5405), fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.coral),
            ),
          ),
          const SizedBox(height: 20),

          // Question Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.pureWhite,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                width: 1.2,
              ),
              boxShadow: AppColors.softShadow(Colors.black, blur: 12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.softLavender.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    currentQ.category,
                    style: const TextStyle(color: Color(0xFF5B41A8), fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  currentQ.question,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    height: 1.35,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 20),

                // 4 Selectable Answers
                ...List.generate(currentQ.options.length, (idx) {
                  final opt = currentQ.options[idx];
                  final isSelected = _dataService.quizSelectedAnswer == idx;
                  final isAnswerSubmitted = _dataService.quizAnswerSubmitted;
                  final isCorrect = idx == currentQ.correctIndex;

                  Color optionBg = isDark ? AppColors.darkSurfaceElevated : AppColors.warmCream;
                  Color borderColor = isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;
                  Color textColor = isDark ? AppColors.darkTextPrimary : AppColors.charcoal;

                  if (isAnswerSubmitted) {
                    if (isCorrect) {
                      optionBg = AppColors.emerald.withValues(alpha: 0.18);
                      borderColor = AppColors.emerald;
                      textColor = AppColors.emerald;
                    } else if (isSelected && !isCorrect) {
                      optionBg = AppColors.coral.withValues(alpha: 0.18);
                      borderColor = AppColors.coral;
                      textColor = AppColors.coral;
                    }
                  } else if (isSelected) {
                    borderColor = AppColors.coral;
                    optionBg = AppColors.coral.withValues(alpha: 0.12);
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () => _dataService.selectQuizAnswer(idx),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: optionBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderColor, width: isSelected || isCorrect ? 1.5 : 1),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: borderColor),
                                color: isSelected || (isAnswerSubmitted && isCorrect)
                                    ? borderColor
                                    : Colors.transparent,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                String.fromCharCode(65 + idx),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected || (isAnswerSubmitted && isCorrect)
                                      ? Colors.white
                                      : textColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                opt,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                if (_dataService.quizAnswerSubmitted) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.softLavender.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline, size: 16, color: Color(0xFF5B41A8)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            currentQ.explanation,
                            style: const TextStyle(fontSize: 12, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GradientActionButton(
                    label: _dataService.quizCurrentIndex < questions.length - 1
                        ? 'Next Question →'
                        : 'View Results 🏆',
                    gradient: AppColors.heroGradient,
                    onPressed: () => _dataService.nextQuizQuestion(),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final streak = _dataService.streakInfo;
    final leaderboard = _dataService.leaderboard;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Daily Streak Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.circular(22),
              boxShadow: AppColors.glowShadow(AppColors.coral),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('🔥 ', style: TextStyle(fontSize: 22)),
                        Text(
                          '${streak.currentStreak}-Day Active Streak!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        if (!streak.hasCheckedInToday) {
                          _dataService.checkInDailyStreak();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('🎉 Streak Check-in Complete! +50 XP Earned!')),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: streak.hasCheckedInToday
                              ? Colors.white.withValues(alpha: 0.25)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          streak.hasCheckedInToday ? 'Checked ✓' : 'Daily Check-in',
                          style: TextStyle(
                            color: streak.hasCheckedInToday ? Colors.white : AppColors.coral,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Best Record: ${streak.bestStreak} Days • Keep solving daily quizzes to multiply your XP payout!',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 12),
                Row(
                  children: streak.streakRewards.map((badge) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '🎖️ $badge',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 2. Podium Section for Top 3
          const Text(
            'GL Bajaj Campus Leaderboard',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Rankings updated live from quizzes, hackathon quests, and peer contributions.',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 16),

          // Top 3 Podium Cards
          if (leaderboard.length >= 3)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Rank 2 (Silver)
                Expanded(
                  child: BouncyCard(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : AppColors.pureWhite,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade400, width: 1.5),
                      ),
                      child: Column(
                        children: [
                          const Text('🥈', style: TextStyle(fontSize: 24)),
                          const SizedBox(height: 4),
                          CircleAvatar(
                            radius: 22,
                            backgroundImage: NetworkImage(leaderboard[1].avatarUrl),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            leaderboard[1].studentName.split(' ').first,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          Text(
                            '${leaderboard[1].totalXp} XP',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.coral),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Rank 1 (Gold - Elevated)
                Expanded(
                  child: BouncyCard(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                      decoration: BoxDecoration(
                        gradient: AppColors.amberGradient,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: AppColors.glowShadow(AppColors.goldenYellow),
                      ),
                      child: Column(
                        children: [
                          const Text('👑', style: TextStyle(fontSize: 28)),
                          const SizedBox(height: 4),
                          CircleAvatar(
                            radius: 26,
                            backgroundImage: NetworkImage(leaderboard[0].avatarUrl),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            leaderboard[0].studentName.split(' ').first,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: AppColors.charcoal, fontWeight: FontWeight.w900, fontSize: 13),
                          ),
                          Text(
                            '${leaderboard[0].totalXp} XP',
                            style: const TextStyle(color: AppColors.charcoal, fontSize: 12, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Rank 3 (Bronze - Aarav)
                Expanded(
                  child: BouncyCard(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : AppColors.pureWhite,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.coral, width: 1.5),
                      ),
                      child: Column(
                        children: [
                          const Text('🥉', style: TextStyle(fontSize: 24)),
                          const SizedBox(height: 4),
                          CircleAvatar(
                            radius: 22,
                            backgroundImage: NetworkImage(leaderboard[2].avatarUrl),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'You (Aarav)',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.coral),
                          ),
                          Text(
                            '${leaderboard[2].totalXp} XP',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.coral),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 20),

          // 3. Full Leaderboard List
          const Text('All Campus Standings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 10),
          ...leaderboard.map((entry) {
            final isSelf = entry.isCurrentUser;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelf
                    ? AppColors.coral.withValues(alpha: 0.12)
                    : (isDark ? AppColors.darkSurface : AppColors.pureWhite),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelf
                      ? AppColors.coral
                      : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                  width: isSelf ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isSelf ? AppColors.coral : Colors.grey.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '#${entry.rank}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isSelf ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(entry.avatarUrl),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              entry.studentName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: isSelf ? AppColors.coral : null,
                              ),
                            ),
                            if (isSelf) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.coral,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'YOU',
                                  style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ]
                          ],
                        ),
                        Text(
                          '${entry.department} • ${entry.badge}',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${entry.totalXp} XP',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.coral),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}


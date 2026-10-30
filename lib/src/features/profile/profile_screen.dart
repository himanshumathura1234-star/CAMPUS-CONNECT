import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/bouncy_card.dart';
import '../../services/campus_data_service.dart';
import '../study_planner/widgets/study_planner_widget.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const ProfileScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  void _showEditBioDialog(BuildContext context, CampusDataService dataService) {
    final bioCtrl = TextEditingController(text: dataService.currentUser.bio);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Student Bio'),
        content: TextField(
          controller: bioCtrl,
          maxLines: 4,
          maxLength: 200,
          decoration: const InputDecoration(
            hintText: 'Share your academic passions, hackathon goals, and study vibes...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              dataService.updateBio(bioCtrl.text);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile bio updated!')),
              );
            },
            child: const Text('Save Bio'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataService = CampusDataService();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: dataService,
      builder: (context, _) {
        final user = dataService.currentUser;
        final registeredEvents = dataService.events.where((e) => e.isRegistered).toList();
        final joinedClubs = dataService.communities.where((c) => c.isJoined).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Student Profile', style: TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                onPressed: onToggleTheme,
                tooltip: 'Toggle Theme',
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.pureWhite,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                      width: 1.2,
                    ),
                    boxShadow: AppColors.softShadow(Colors.black, blur: 12),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              gradient: AppColors.coralGradient,
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 44,
                              backgroundColor: AppColors.peach,
                              child: Text(
                                user.fullName[0],
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.charcoal,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.coral,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.school_rounded, color: Colors.white, size: 14),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.fullName,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.charcoal,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${user.studentId} • ${user.department}',
                        style: const TextStyle(fontSize: 13, color: AppColors.secondaryText, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: AppColors.amberGradient,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: AppColors.glowShadow(AppColors.goldenYellow),
                        ),
                        child: Text(
                          '🏆 ${user.totalPoints} Campus Points • Top 5% Rank',
                          style: const TextStyle(
                            color: AppColors.charcoal,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Bio Row
                      GestureDetector(
                        onTap: () => _showEditBioDialog(context, dataService),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurfaceElevated : AppColors.warmCream,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  user.bio,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.charcoal,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.edit_note_rounded, size: 22, color: AppColors.coral),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Stats Dashboard Row
                Row(
                  children: [
                    _buildStatCard(
                      label: 'Events RSVP',
                      value: '${registeredEvents.length}',
                      icon: Icons.confirmation_number_outlined,
                      color: AppColors.coral,
                      context: context,
                    ),
                    const SizedBox(width: 8),
                    _buildStatCard(
                      label: 'Clubs',
                      value: '${joinedClubs.length}',
                      icon: Icons.groups_outlined,
                      color: AppColors.emerald,
                      context: context,
                    ),
                    const SizedBox(width: 8),
                    _buildStatCard(
                      label: 'Tasks Done',
                      value: '${dataService.studyTasks.where((t) => t.isCompleted).length}',
                      icon: Icons.task_alt_outlined,
                      color: const Color(0xFF6B4FB8),
                      context: context,
                    ),
                    const SizedBox(width: 8),
                    _buildStatCard(
                      label: 'Streak',
                      value: '${dataService.streakInfo.currentStreak}d 🔥',
                      icon: Icons.local_fire_department_rounded,
                      color: AppColors.goldenYellow,
                      context: context,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Study Mode Preference
                const Text('Preferred Study Mode', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  children: ['either', 'in_person', 'online'].map((mode) {
                    final isSel = user.preferredStudyMode == mode;
                    final display = mode == 'either'
                        ? 'Hybrid / Either'
                        : (mode == 'in_person' ? 'Campus Library' : 'Online Discord');
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(display, style: const TextStyle(fontSize: 11)),
                          selected: isSel,
                          onSelected: (val) {
                            if (val) dataService.updateStudyMode(mode);
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // Unlocked Badges
                const Text('Unlocked Badges & Honors', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: user.badges.map((badge) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                        ),
                        boxShadow: AppColors.softShadow(Colors.black, blur: 8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified_rounded, color: AppColors.accentAmber, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            badge,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // Skills & Interests
                const Text('Academic Skills & Tools', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: user.skills.map((s) => Chip(
                    label: Text(s, style: const TextStyle(fontSize: 11)),
                    padding: EdgeInsets.zero,
                  )).toList(),
                ),

                const SizedBox(height: 24),

                // Embedded Study Planner
                const StudyPlannerWidget(),

                const SizedBox(height: 24),

                // Settings & Appearance
                Material(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.brightness_4_outlined, color: AppColors.coral),
                        title: const Text('Dark Mode', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        trailing: Switch(
                          value: isDarkMode,
                          onChanged: (_) => onToggleTheme(),
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.security_outlined, color: AppColors.emerald),
                        title: const Text('Institutional Email Verified', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        subtitle: Text(user.email, style: const TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                        trailing: const Icon(Icons.check_circle, color: AppColors.emerald, size: 18),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.redAccent),
                        title: const Text('Sign Out', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.redAccent)),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Session secure. Signed out of GL Bajaj Campus Connect.')),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required BuildContext context,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: BouncyCard(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.pureWhite,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
              width: 1.2,
            ),
            boxShadow: AppColors.softShadow(Colors.black, blur: 8),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: AppColors.secondaryText, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

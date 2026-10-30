import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/core/theme/app_theme.dart';
import 'src/core/widgets/custom_bottom_sheet.dart';
import 'src/features/home/home_screen.dart';
import 'src/features/discover/discover_screen.dart';
import 'src/features/play/play_screen.dart';
import 'src/features/profile/profile_screen.dart';
import 'src/features/notifications/notifications_sheet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CampusBuildApp());
}

typedef CampusConnectApp = CampusBuildApp;

class CampusBuildApp extends StatefulWidget {
  const CampusBuildApp({super.key});

  @override
  State<CampusBuildApp> createState() => _CampusBuildAppState();
}

class _CampusBuildAppState extends State<CampusBuildApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadSavedTheme();
  }

  Future<void> _loadSavedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool('campus_is_dark_theme') ?? false;
      setState(() {
        _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      });
    } catch (_) {}
  }

  Future<void> _toggleTheme() async {
    final nextMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    setState(() {
      _themeMode = nextMode;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('campus_is_dark_theme', nextMode == ThemeMode.dark);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Build',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: CampusMainShell(
        toggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class CampusMainShell extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const CampusMainShell({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<CampusMainShell> createState() => _CampusMainShellState();
}

class _CampusMainShellState extends State<CampusMainShell> {
  int _selectedIndex = 0;
  int _discoverSubIndex = 0;

  void _onTabSelected(int index, {int? subIndex}) {
    if (index == 2) {
      CustomBottomSheet.showCreateActionSheet(context);
    } else {
      setState(() {
        _selectedIndex = index;
        if (subIndex != null) {
          _discoverSubIndex = subIndex;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > 800;

        final screens = [
          HomeScreen(
            onNavigateTab: (idx, {subIndex}) => _onTabSelected(idx, subIndex: subIndex),
            onOpenNotifications: () => NotificationsSheet.show(context),
          ),
          DiscoverScreen(
            key: ValueKey(_discoverSubIndex),
            initialTabIndex: _discoverSubIndex,
          ),
          const SizedBox.shrink(), // Create action trigger
          const PlayScreen(),
          ProfileScreen(
            onToggleTheme: widget.toggleTheme,
            isDarkMode: widget.isDarkMode,
          ),
        ];

        return Scaffold(
          body: Row(
            children: [
              if (isLargeScreen)
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onTabSelected,
                  labelType: NavigationRailLabelType.all,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: AppColors.softShadow(AppColors.coral),
                          ),
                          child: const Icon(Icons.school_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'GL Bajaj',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                    onPressed: widget.toggleTheme,
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.explore_outlined),
                      selectedIcon: Icon(Icons.explore_rounded),
                      label: Text('Discover'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.add_circle_outline, size: 28, color: AppColors.coral),
                      selectedIcon: Icon(Icons.add_circle, size: 28, color: AppColors.coral),
                      label: Text('Create'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.sports_esports_outlined),
                      selectedIcon: Icon(Icons.sports_esports_rounded),
                      label: Text('Play'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person_rounded),
                      label: Text('Profile'),
                    ),
                  ],
                ),
              Expanded(
                child: SafeArea(
                  child: screens[_selectedIndex == 2 ? 0 : _selectedIndex],
                ),
              ),
            ],
          ),
          bottomNavigationBar: isLargeScreen
              ? null
              : Container(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                  child: SafeArea(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : AppColors.pureWhite,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                            blurRadius: 18,
                            spreadRadius: 0,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavItem(0, Icons.home_outlined, Icons.home_rounded, 'Home'),
                          _buildNavItem(1, Icons.explore_outlined, Icons.explore_rounded, 'Discover'),
                          _buildCreateButton(),
                          _buildNavItem(3, Icons.sports_esports_outlined, Icons.sports_esports_rounded, 'Play'),
                          _buildNavItem(4, Icons.person_outline, Icons.person_rounded, 'Profile'),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _selectedIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _onTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.coral.withValues(alpha: 0.22) : AppColors.coral.withValues(alpha: 0.12))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected
                  ? AppColors.coral
                  : (isDark ? AppColors.darkTextSecondary : AppColors.secondaryText),
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: isSelected
                    ? AppColors.coral
                    : (isDark ? AppColors.darkTextSecondary : AppColors.secondaryText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return GestureDetector(
      onTap: () => _onTabSelected(2),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: AppColors.glowShadow(AppColors.coral),
            ),
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 2),
          const Text(
            'Create',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.coral,
            ),
          ),
        ],
      ),
    );
  }
}

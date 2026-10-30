import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/category_chip.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../services/campus_data_service.dart';
import '../events/widgets/event_card.dart';
import '../study_buddy/widgets/study_buddy_card.dart';
import '../communities/widgets/community_card.dart';
import '../confessions_polls/widgets/confession_card.dart';
import '../confessions_polls/widgets/poll_card.dart';
import '../marketplace/widgets/marketplace_card.dart';
import '../lost_found/widgets/lost_found_card.dart';
import '../qa/widgets/question_card.dart';
import '../resources/widgets/resource_card.dart';

class DiscoverScreen extends StatefulWidget {
  final int initialTabIndex;

  const DiscoverScreen({super.key, this.initialTabIndex = 0});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CampusDataService _dataService = CampusDataService();
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  // Filters
  String _buddyFilter = 'All';
  String _marketFilter = 'All';
  String _lostFoundFilter = 'All';
  String _qaFilter = 'All';
  String _resourceFilter = 'All';
  String _eventFilter = 'All';
  final String _confessionFilter = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 7,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: _dataService,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Discover Campus', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : AppColors.pureWhite,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                          width: 1.2,
                        ),
                        boxShadow: AppColors.softShadow(Colors.black, blur: 8, offset: const Offset(0, 2)),
                      ),
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
                        decoration: InputDecoration(
                          hintText: 'Search partners, books, lost items, PYQs, clubs...',
                          hintStyle: TextStyle(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                            fontSize: 13,
                          ),
                          prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.coral),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, size: 18),
                                  onPressed: () {
                                    _searchCtrl.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  // Tab Bar (7 Core Discovery Verticals)
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: AppColors.coral,
                    unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                    indicatorColor: AppColors.coral,
                    indicatorWeight: 3.5,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: const [
                      Tab(text: 'Study Buddies'),
                      Tab(text: 'Marketplace'),
                      Tab(text: 'Lost & Found'),
                      Tab(text: 'Campus Q&A'),
                      Tab(text: 'Notes & PYQs'),
                      Tab(text: 'Events & Clubs'),
                      Tab(text: 'Confessions & Polls'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildStudyBuddiesTab(),
              _buildMarketplaceTab(),
              _buildLostFoundTab(),
              _buildQATab(),
              _buildResourcesTab(),
              _buildEventsTab(),
              _buildConfessionsTab(),
            ],
          ),
        );
      },
    );
  }

  // 1. Study Buddies Tab
  Widget _buildStudyBuddiesTab() {
    final filtered = _dataService.studyBuddies.where((b) {
      final matchesQuery = _searchQuery.isEmpty ||
          b.fullName.toLowerCase().contains(_searchQuery) ||
          b.department.toLowerCase().contains(_searchQuery) ||
          b.skills.any((s) => s.toLowerCase().contains(_searchQuery));

      if (!matchesQuery) return false;
      if (_buddyFilter == 'All') return true;
      if (_buddyFilter == 'Sem 5') return b.semester == 5;
      if (_buddyFilter == 'In-Person') return b.preferredStudyMode.toLowerCase().contains('in-person');
      if (_buddyFilter == 'Online') return b.preferredStudyMode.toLowerCase().contains('online');
      return true;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Sem 5', 'In-Person', 'Online'].map((f) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CategoryChip(
                    label: f,
                    isSelected: _buddyFilter == f,
                    onTap: () => setState(() => _buddyFilter = f),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const EmptyStateWidget(
                  title: 'No Study Partners Found',
                  description: 'Try adjusting your filters or search keywords.',
                  emoji: '👥',
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, idx) => StudyBuddyCard(
                    buddy: filtered[idx],
                    onConnectChanged: () => setState(() {}),
                  ),
                ),
        ),
      ],
    );
  }

  // 2. Marketplace Tab
  Widget _buildMarketplaceTab() {
    final filtered = _dataService.marketplaceItems.where((it) {
      final matchesQuery = _searchQuery.isEmpty ||
          it.title.toLowerCase().contains(_searchQuery) ||
          it.description.toLowerCase().contains(_searchQuery) ||
          it.category.toLowerCase().contains(_searchQuery);

      if (!matchesQuery) return false;
      if (_marketFilter == 'All') return true;
      if (_marketFilter == 'Textbooks') return it.category == 'textbooks';
      if (_marketFilter == 'Calculators') return it.category == 'calculators';
      if (_marketFilter == 'Accessories') return it.category == 'accessories';
      if (_marketFilter == 'Notes') return it.category == 'notes';
      if (_marketFilter == 'Exchange') return it.isExchangeable;
      return true;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Textbooks', 'Calculators', 'Accessories', 'Notes', 'Exchange'].map((f) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CategoryChip(
                    label: f,
                    isSelected: _marketFilter == f,
                    onTap: () => setState(() => _marketFilter = f),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const EmptyStateWidget(
                  title: 'No Marketplace Listings',
                  description: 'Be the first to list a used textbook or calculator!',
                  emoji: '🛍️',
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, idx) => MarketplaceCard(
                    item: filtered[idx],
                    onUpdate: () => setState(() {}),
                  ),
                ),
        ),
      ],
    );
  }

  // 3. Lost & Found Tab
  Widget _buildLostFoundTab() {
    final filtered = _dataService.lostFoundItems.where((it) {
      final matchesQuery = _searchQuery.isEmpty ||
          it.title.toLowerCase().contains(_searchQuery) ||
          it.description.toLowerCase().contains(_searchQuery) ||
          it.location.toLowerCase().contains(_searchQuery);

      if (!matchesQuery) return false;
      if (_lostFoundFilter == 'All') return true;
      if (_lostFoundFilter == 'Lost') return it.itemType == 'lost';
      if (_lostFoundFilter == 'Found') return it.itemType == 'found';
      if (_lostFoundFilter == 'Electronics') return it.category == 'electronics';
      if (_lostFoundFilter == 'Documents') return it.category == 'documents';
      return true;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Lost', 'Found', 'Electronics', 'Documents'].map((f) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CategoryChip(
                    label: f,
                    isSelected: _lostFoundFilter == f,
                    onTap: () => setState(() => _lostFoundFilter = f),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const EmptyStateWidget(
                  title: 'No Lost or Found Items Reported',
                  description: 'All items on campus are accounted for!',
                  emoji: '🔍',
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, idx) => LostFoundCard(
                    item: filtered[idx],
                    onUpdate: () => setState(() {}),
                  ),
                ),
        ),
      ],
    );
  }

  // 4. Campus Q&A Tab
  Widget _buildQATab() {
    final filtered = _dataService.questions.where((q) {
      final matchesQuery = _searchQuery.isEmpty ||
          q.title.toLowerCase().contains(_searchQuery) ||
          q.content.toLowerCase().contains(_searchQuery) ||
          q.subject.toLowerCase().contains(_searchQuery);

      if (!matchesQuery) return false;
      if (_qaFilter == 'All') return true;
      if (_qaFilter == 'Operating Systems') return q.subject.contains('Operating');
      if (_qaFilter == 'Entrepreneurship') return q.subject.contains('Entrepreneurship');
      if (_qaFilter == 'Solved') return q.isResolved;
      return true;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Operating Systems', 'Entrepreneurship', 'Solved'].map((f) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CategoryChip(
                    label: f,
                    isSelected: _qaFilter == f,
                    onTap: () => setState(() => _qaFilter = f),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const EmptyStateWidget(
                  title: 'No Questions Found',
                  description: 'Have a doubt? Ask seniors and peers anonymously!',
                  emoji: '❓',
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, idx) => QuestionCard(
                    question: filtered[idx],
                    onUpdate: () => setState(() {}),
                  ),
                ),
        ),
      ],
    );
  }

  // 5. Notes & PYQs Tab
  Widget _buildResourcesTab() {
    final filtered = _dataService.studyResources.where((r) {
      final matchesQuery = _searchQuery.isEmpty ||
          r.title.toLowerCase().contains(_searchQuery) ||
          r.subject.toLowerCase().contains(_searchQuery) ||
          r.uploaderName.toLowerCase().contains(_searchQuery);

      if (!matchesQuery) return false;
      if (_resourceFilter == 'All') return true;
      if (_resourceFilter == 'PDF Notes') return r.fileType == 'pdf';
      if (_resourceFilter == 'PYQs') return r.fileType == 'pyq';
      if (_resourceFilter == 'Code') return r.fileType == 'code';
      if (_resourceFilter == 'Bookmarked') return r.isBookmarked;
      return true;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'PDF Notes', 'PYQs', 'Code', 'Bookmarked'].map((f) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CategoryChip(
                    label: f,
                    isSelected: _resourceFilter == f,
                    onTap: () => setState(() => _resourceFilter = f),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const EmptyStateWidget(
                  title: 'No Study Resources Found',
                  description: 'Upload your notes or previous year papers to help your peers!',
                  emoji: '📚',
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, idx) => ResourceCard(
                    resource: filtered[idx],
                    onUpdate: () => setState(() {}),
                  ),
                ),
        ),
      ],
    );
  }

  // 6. Events & Clubs Tab
  Widget _buildEventsTab() {
    final filteredEvents = _dataService.events.where((e) {
      final matchesQuery = _searchQuery.isEmpty ||
          e.title.toLowerCase().contains(_searchQuery) ||
          e.organizer.toLowerCase().contains(_searchQuery) ||
          e.tags.any((t) => t.toLowerCase().contains(_searchQuery));

      if (!matchesQuery) return false;
      if (_eventFilter == 'All') return true;
      return e.category.toLowerCase() == _eventFilter.toLowerCase();
    }).toList();

    final filteredCommunities = _dataService.communities.where((c) {
      return _searchQuery.isEmpty ||
          c.name.toLowerCase().contains(_searchQuery) ||
          c.description.toLowerCase().contains(_searchQuery) ||
          c.category.toLowerCase().contains(_searchQuery);
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Hackathon', 'Workshop', 'Cultural'].map((f) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CategoryChip(
                    label: f,
                    isSelected: _eventFilter == f,
                    onTap: () => setState(() => _eventFilter = f),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Campus Events', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...filteredEvents.map((e) => EventCard(
                event: e,
                onRegisterChanged: () => setState(() {}),
              )),
          const SizedBox(height: 18),
          const Text('Student Clubs & Communities', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...filteredCommunities.map((c) => CommunityCard(
                community: c,
                onJoinChanged: () => setState(() {}),
              )),
        ],
      ),
    );
  }

  // 7. Confessions & Polls Tab
  Widget _buildConfessionsTab() {
    final filteredConfessions = _dataService.confessions.where((c) {
      final matchesQuery = _searchQuery.isEmpty || c.content.toLowerCase().contains(_searchQuery);
      if (!matchesQuery) return false;
      if (_confessionFilter == 'All') return true;
      return c.category.toLowerCase() == _confessionFilter.toLowerCase();
    }).toList();

    final polls = _dataService.polls;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Live Campus Polls', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...polls.map((p) => PollCard(
                poll: p,
                onVoted: () => setState(() {}),
              )),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Anonymous Wall', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.softLavender.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.softLavender.withValues(alpha: 0.5),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.shield_outlined, size: 14, color: Color(0xFF5B41A8)),
                    SizedBox(width: 4),
                    Text('100% Private', style: TextStyle(fontSize: 11, color: Color(0xFF5B41A8), fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...filteredConfessions.map((c) => ConfessionCard(
                confession: c,
                onReactionChanged: () => setState(() {}),
              )),
        ],
      ),
    );
  }
}

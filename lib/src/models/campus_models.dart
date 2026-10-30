class StudentUser {
  final int id;
  final String fullName;
  final String studentId;
  final String email;
  final String department;
  final int semester;
  String bio;
  final String avatarUrl;
  final List<String> skills;
  final List<String> academicInterests;
  final List<String> hobbies;
  String preferredStudyMode;
  String preferredStudyTimes;
  int totalPoints;
  final List<String> badges;

  StudentUser({
    required this.id,
    required this.fullName,
    required this.studentId,
    required this.email,
    required this.department,
    required this.semester,
    required this.bio,
    required this.avatarUrl,
    required this.skills,
    required this.academicInterests,
    required this.hobbies,
    required this.preferredStudyMode,
    required this.preferredStudyTimes,
    required this.totalPoints,
    required this.badges,
  });

  factory StudentUser.initialAarav() {
    return StudentUser(
      id: 1,
      fullName: 'Aarav Sharma',
      studentId: 'GLB-2023-CS-042',
      email: 'aarav.sharma@glbajaj.ac.in',
      department: 'Computer Science & Engineering',
      semester: 5,
      bio: 'Passionate Flutter & Serverpod developer. Building Campus Build with Team Beyond Aura! Excited about hackathons and distributed systems.',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      skills: ['Flutter', 'Dart', 'Python', 'Machine Learning', 'Serverpod', 'Git'],
      academicInterests: ['Cloud Computing', 'AI Algorithms', 'Distributed Systems'],
      hobbies: ['Chess', 'Photography', 'Badminton', 'Open Source'],
      preferredStudyMode: 'either',
      preferredStudyTimes: 'Weekday evenings 6-9 PM',
      totalPoints: 420,
      badges: ['Campus Detective', 'Quiz Prodigy', 'Hackathon Lead', 'Top Contributor'],
    );
  }
}

class StudyBuddy {
  final int userId;
  final String fullName;
  final String department;
  final int semester;
  final String avatarUrl;
  final List<String> skills;
  final List<String> academicInterests;
  final String preferredStudyMode;
  final String preferredStudyTimes;
  final int compatibilityScore;
  final List<String> compatibilityReasons;
  String requestStatus; // 'none', 'pending', 'accepted'

  StudyBuddy({
    required this.userId,
    required this.fullName,
    required this.department,
    required this.semester,
    required this.avatarUrl,
    required this.skills,
    required this.academicInterests,
    required this.preferredStudyMode,
    required this.preferredStudyTimes,
    required this.compatibilityScore,
    required this.compatibilityReasons,
    this.requestStatus = 'none',
  });
}

class CampusEvent {
  final int id;
  final String title;
  final String description;
  final String category; // 'Hackathon', 'Workshop', 'Cultural', 'Sports', 'Technical'
  final String dateString;
  final String timeString;
  final String venue;
  final String organizer;
  final int capacity;
  int registeredCount;
  bool isRegistered;
  final String bannerGradient; // identifier or label
  final List<String> tags;

  CampusEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.dateString,
    required this.timeString,
    required this.venue,
    required this.organizer,
    required this.capacity,
    required this.registeredCount,
    this.isRegistered = false,
    required this.bannerGradient,
    required this.tags,
  });
}

class CampusCommunity {
  final int id;
  final String name;
  final String description;
  final String category;
  final String iconEmoji;
  int memberCount;
  bool isJoined;
  final String meetingSchedule;
  final List<String> recentDiscussions;

  CampusCommunity({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.iconEmoji,
    required this.memberCount,
    this.isJoined = false,
    required this.meetingSchedule,
    required this.recentDiscussions,
  });
}

class ConfessionItem {
  final int id;
  final String content;
  final String category;
  final String timeAgo;
  int likeCount;
  bool hasLiked;
  final Map<String, int> reactions;
  final Set<String> userReactions;
  bool isReported;

  ConfessionItem({
    required this.id,
    required this.content,
    required this.category,
    required this.timeAgo,
    required this.likeCount,
    this.hasLiked = false,
    required this.reactions,
    Set<String>? userReactions,
    this.isReported = false,
  }) : userReactions = userReactions ?? <String>{};
}

class PollOptionModel {
  final int index;
  final String text;
  int votes;

  PollOptionModel({
    required this.index,
    required this.text,
    required this.votes,
  });
}

class CampusPollModel {
  final int id;
  final String question;
  final String category;
  final String timeLeft;
  int totalVotes;
  int? userVotedIndex;
  final List<PollOptionModel> options;

  CampusPollModel({
    required this.id,
    required this.question,
    required this.category,
    required this.timeLeft,
    required this.totalVotes,
    this.userVotedIndex,
    required this.options,
  });
}

class TreasureHuntState {
  final int currentClueIndex;
  final int totalClues;
  final String stageTitle;
  final String riddle;
  final String locationHint;
  final int rewardPoints;
  final String rewardBadge;
  final String expectedKeyword;
  bool hintRevealed;
  bool isCompleted;
  int userScore;

  TreasureHuntState({
    required this.currentClueIndex,
    required this.totalClues,
    required this.stageTitle,
    required this.riddle,
    required this.locationHint,
    required this.rewardPoints,
    required this.rewardBadge,
    required this.expectedKeyword,
    this.hintRevealed = false,
    this.isCompleted = false,
    required this.userScore,
  });
}

class QuizQuestionModel {
  final int id;
  final String category;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  QuizQuestionModel({
    required this.id,
    required this.category,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class CampusNotificationItem {
  final int id;
  final String title;
  final String message;
  final String timeAgo;
  final String category;
  bool isRead;

  CampusNotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.category,
    this.isRead = false,
  });
}



class MarketplaceItemModel {
  final int id;
  final int sellerId;
  final String sellerName;
  final String sellerAvatar;
  final String title;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  bool isSold;
  final bool isExchangeable;
  final String contactPhone;
  final String timeAgo;

  MarketplaceItemModel({
    required this.id,
    required this.sellerId,
    required this.sellerName,
    required this.sellerAvatar,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.isSold = false,
    this.isExchangeable = false,
    required this.contactPhone,
    required this.timeAgo,
  });
}

class LostFoundItemModel {
  final int id;
  final int reporterId;
  final String reporterName;
  final String reporterAvatar;
  final String title;
  final String description;
  final String itemType; // 'lost' or 'found'
  final String category;
  final String location;
  final String timeAgo;
  bool isResolved;
  final String contactPhone;

  LostFoundItemModel({
    required this.id,
    required this.reporterId,
    required this.reporterName,
    required this.reporterAvatar,
    required this.title,
    required this.description,
    required this.itemType,
    required this.category,
    required this.location,
    required this.timeAgo,
    this.isResolved = false,
    required this.contactPhone,
  });
}

class CampusAnswerModel {
  final int id;
  final String authorName;
  final bool isAnonymous;
  final String content;
  int upvotes;
  bool isAccepted;
  bool userUpvoted;

  CampusAnswerModel({
    required this.id,
    required this.authorName,
    required this.isAnonymous,
    required this.content,
    required this.upvotes,
    this.isAccepted = false,
    this.userUpvoted = false,
  });
}

class CampusQuestionModel {
  final int id;
  final int authorId;
  final String authorName;
  final bool isAnonymous;
  final String title;
  final String content;
  final String subject;
  int upvotes;
  int answerCount;
  bool isResolved;
  final String timeAgo;
  bool userUpvoted;
  final List<CampusAnswerModel> answers;

  CampusQuestionModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.isAnonymous,
    required this.title,
    required this.content,
    required this.subject,
    required this.upvotes,
    required this.answerCount,
    this.isResolved = false,
    required this.timeAgo,
    this.userUpvoted = false,
    required this.answers,
  });
}

class StudyTaskModel {
  final int id;
  final String title;
  final String subject;
  final DateTime deadline;
  bool isCompleted;
  final String priority; // 'high', 'medium', 'low'
  final String? notes;

  StudyTaskModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.deadline,
    this.isCompleted = false,
    required this.priority,
    this.notes,
  });
}

class StudyResourceModel {
  final int id;
  final String uploaderName;
  final String title;
  final String description;
  final String course;
  final int semester;
  final String subject;
  final String fileUrl;
  final String fileType; // 'pdf', 'pyq', 'code', 'notes'
  int downloadCount;
  final double rating;
  bool isBookmarked;

  StudyResourceModel({
    required this.id,
    required this.uploaderName,
    required this.title,
    required this.description,
    required this.course,
    required this.semester,
    required this.subject,
    required this.fileUrl,
    required this.fileType,
    required this.downloadCount,
    required this.rating,
    this.isBookmarked = false,
  });
}

class CampusAnnouncementModel {
  final int id;
  final String title;
  final String content;
  final String category; // 'event', 'exam', 'academic', 'club'
  final String authorName;
  final bool isPinned;
  final String targetAudience;
  final String timeAgo;
  int readCount;
  bool isRead;

  CampusAnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.authorName,
    required this.isPinned,
    required this.targetAudience,
    required this.timeAgo,
    required this.readCount,
    this.isRead = false,
  });
}

class StreakInfoModel {
  int currentStreak;
  int bestStreak;
  bool hasCheckedInToday;
  final List<String> streakRewards;

  StreakInfoModel({
    required this.currentStreak,
    required this.bestStreak,
    required this.hasCheckedInToday,
    required this.streakRewards,
  });
}

class LeaderboardEntryModel {
  final int rank;
  final String studentName;
  final String avatarUrl;
  final String department;
  final int semester;
  final int totalXp;
  final String badge;
  final bool isCurrentUser;

  LeaderboardEntryModel({
    required this.rank,
    required this.studentName,
    required this.avatarUrl,
    required this.department,
    required this.semester,
    required this.totalXp,
    required this.badge,
    this.isCurrentUser = false,
  });
}

class DailyMissionItem {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final int xpReward;
  final bool isCompleted;
  final String actionTab; // 'home', 'discover', 'play', 'profile'

  DailyMissionItem({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.xpReward,
    required this.isCompleted,
    this.actionTab = 'home',
  });
}

class CampusPulseItem {
  final String id;
  final String title;
  final String subtitle;
  final String timeAgo;
  final String emoji;
  final String category;
  final List<String> avatars;
  final String highlightText;

  CampusPulseItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    required this.emoji,
    required this.category,
    required this.avatars,
    required this.highlightText,
  });
}

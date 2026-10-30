import 'package:flutter/foundation.dart';
import 'package:campus_connect_client/campus_connect_client.dart' as serverpod_client;
import '../models/campus_models.dart';

class CampusDataService extends ChangeNotifier {
  static final CampusDataService _instance = CampusDataService._internal();
  factory CampusDataService() => _instance;

  CampusDataService._internal() {
    _initializeSeedData();
    _connectToServerpod();
  }

  serverpod_client.Client? _serverClient;
  serverpod_client.Client? get serverClient => _serverClient;
  bool _serverConnected = false;
  bool get serverConnected => _serverConnected;

  void _connectToServerpod() {
    try {
      _serverClient = serverpod_client.Client('http://localhost:8081/');
      _serverConnected = true;
    } catch (e) {
      debugPrint('[CampusDataService] Serverpod client fallback to local sync: $e');
    }
  }

  // Active User Profile
  late StudentUser currentUser;

  // Domain Collections
  List<CampusEvent> events = [];
  List<StudyBuddy> studyBuddies = [];
  List<CampusCommunity> communities = [];
  List<ConfessionItem> confessions = [];
  List<CampusPollModel> polls = [];
  List<CampusNotificationItem> notifications = [];
  late TreasureHuntState treasureHunt;
  List<QuizQuestionModel> quizQuestions = [];
  List<MarketplaceItemModel> marketplaceItems = [];
  List<LostFoundItemModel> lostFoundItems = [];
  List<CampusQuestionModel> questions = [];
  List<StudyTaskModel> studyTasks = [];
  List<StudyResourceModel> studyResources = [];
  List<CampusAnnouncementModel> announcements = [];
  late StreakInfoModel streakInfo;
  List<LeaderboardEntryModel> leaderboard = [];

  // Quiz active state
  int quizCurrentIndex = 0;
  int? quizSelectedAnswer;
  bool quizAnswerSubmitted = false;
  int quizScore = 0;
  int quizStreak = 0;
  bool quizCompleted = false;

  int get unreadNotificationsCount =>
      notifications.where((n) => !n.isRead).length;

  void _initializeSeedData() {
    currentUser = StudentUser.initialAarav();

    events = [
      CampusEvent(
        id: 101,
        title: 'Hackbriven 2026: Campus Life Upgraded',
        description:
            'The flagship 36-hour college hackathon by Beyond Aura at GL Bajaj. Build cutting-edge mobile apps with Flutter, Serverpod, and GenAI.',
        category: 'Hackathon',
        dateString: 'Nov 12 - 14, 2026',
        timeString: '36 Hours Duration • 9:00 AM Kickoff',
        venue: 'Auditorium Hall A & Innovation Lab',
        organizer: 'Beyond Aura & GDG GL Bajaj',
        capacity: 250,
        registeredCount: 194,
        isRegistered: true,
        bannerGradient: 'primary',
        tags: ['Flutter', 'Serverpod', '₹1,50,000 Prizes', 'Live Demos'],
      ),
      CampusEvent(
        id: 102,
        title: 'Flutter & Serverpod Masterclass',
        description:
            'Deep dive into full-stack Dart development, server endpoints, relational database migrations, and real-time streaming sockets.',
        category: 'Workshop',
        dateString: 'Tomorrow, Nov 2',
        timeString: '2:00 PM - 5:30 PM',
        venue: 'Seminar Hall 2 & YouTube Live',
        organizer: 'CSE Department & Beyond Devs',
        capacity: 120,
        registeredCount: 96,
        isRegistered: false,
        bannerGradient: 'mint',
        tags: ['Hands-on', 'Certificate', 'Dart Fullstack'],
      ),
      CampusEvent(
        id: 103,
        title: 'AuraFest 2026: Cultural Battle of Bands',
        description:
            'Annual inter-college musical extravaganza, dance competitions, poetry slam, and food fiesta on the central grounds.',
        category: 'Cultural',
        dateString: 'Nov 20, 2026',
        timeString: '5:00 PM - 10:00 PM',
        venue: 'Open Air Amphitheatre',
        organizer: 'Student Welfare Committee',
        capacity: 500,
        registeredCount: 412,
        isRegistered: false,
        bannerGradient: 'coral',
        tags: ['Music', 'Dance', 'Food Stalls', 'Celebrity DJ'],
      ),
      CampusEvent(
        id: 104,
        title: 'GL Bajaj Inter-Branch Esports Arena',
        description:
            'Valorant 5v5, BGMI Squads, and Chess showdown. Knockout rounds broadcast live on discord and campus screens.',
        category: 'Sports',
        dateString: 'Nov 24, 2026',
        timeString: '11:00 AM Onwards',
        venue: 'Computer Center Lab 4',
        organizer: 'GLB Esports Arena',
        capacity: 80,
        registeredCount: 78,
        isRegistered: true,
        bannerGradient: 'amber',
        tags: ['Valorant', 'BGMI', 'Trophies & Swag'],
      ),
    ];

    studyBuddies = [
      StudyBuddy(
        userId: 2,
        fullName: 'Priya Patel',
        department: 'Information Technology',
        semester: 5,
        avatarUrl:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
        skills: ['DSA', 'C++', 'Figma', 'Problem Solving'],
        academicInterests: ['Algorithms', 'Human Computer Interaction'],
        preferredStudyMode: 'In-Person (Library 4-7 PM)',
        preferredStudyTimes: 'Weekday evenings 4:00 - 7:00 PM',
        compatibilityScore: 94,
        compatibilityReasons: [
          'Shared interest in Algorithms & Competitive Coding',
          'Compatible semester level (Semester 5)',
          'Flexible library study hours'
        ],
        requestStatus: 'none',
      ),
      StudyBuddy(
        userId: 3,
        fullName: 'Rohan Verma',
        department: 'AI & Machine Learning',
        semester: 3,
        avatarUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        skills: ['PyTorch', 'Python', 'ROS', 'OpenCV'],
        academicInterests: ['Deep Learning', 'Computer Vision'],
        preferredStudyMode: 'Online (Discord / Google Meet)',
        preferredStudyTimes: 'Late night 10:00 PM - 1:00 AM',
        compatibilityScore: 87,
        compatibilityReasons: [
          'Complementary Python & Machine Learning skills',
          'Both actively preparing for Hackbriven 2026'
        ],
        requestStatus: 'none',
      ),
      StudyBuddy(
        userId: 4,
        fullName: 'Ananya Singh',
        department: 'Electronics & Communication',
        semester: 5,
        avatarUrl:
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150',
        skills: ['Embedded C', 'IoT', 'Arduino', 'Robotics'],
        academicInterests: ['Signals & Systems', 'Microcontrollers'],
        preferredStudyMode: 'Either (Campus or Online)',
        preferredStudyTimes: 'Weekends 10:00 AM - 2:00 PM',
        compatibilityScore: 81,
        compatibilityReasons: [
          'Matches either study mode (online or campus library)',
          'Collaborative project partner for IoT track'
        ],
        requestStatus: 'accepted',
      ),
      StudyBuddy(
        userId: 5,
        fullName: 'Kabir Mehta',
        department: 'Computer Science & Engineering',
        semester: 5,
        avatarUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
        skills: ['React', 'Node.js', 'PostgreSQL', 'Docker'],
        academicInterests: ['Full-stack Architecture', 'System Design'],
        preferredStudyMode: 'In-Person (Tech Labs)',
        preferredStudyTimes: 'Daily after 5:00 PM',
        compatibilityScore: 89,
        compatibilityReasons: [
          'Same CSE department and semester 5 subjects',
          'Expert in backend databases and Docker workflows'
        ],
        requestStatus: 'none',
      ),
    ];

    communities = [
      CampusCommunity(
        id: 201,
        name: 'Beyond Devs (Coding & AI Club)',
        description:
            'Official developer student community at GL Bajaj. We organize weekly hack nights, open source contributions, and peer mentorship.',
        category: 'Tech & AI',
        iconEmoji: '💻',
        memberCount: 168,
        isJoined: true,
        meetingSchedule: 'Wednesdays 4:30 PM @ Innovation Lab',
        recentDiscussions: [
          'Hackbriven 2026 teammate matching thread',
          'Serverpod 1.2 vs 2.0 migration tips & tricks',
          'How to optimize PostgreSQL queries on large datasets'
        ],
      ),
      CampusCommunity(
        id: 202,
        name: 'Mathura Lens & Shutter',
        description:
            'Photography and videography enthusiasts capturing campus moments, heritage photowalks across Mathura & Vrindavan, and editing workshops.',
        category: 'Creative Arts',
        iconEmoji: '📸',
        memberCount: 94,
        isJoined: false,
        meetingSchedule: 'Sundays 8:00 AM @ Main Gate',
        recentDiscussions: [
          'Golden hour campus photography walk this weekend',
          'Lightroom presets bundle for autumn shots',
          'Best budget prime lens for portraits'
        ],
      ),
      CampusCommunity(
        id: 203,
        name: 'GLB Esports Arena',
        description:
            'Competitive gaming squad for Valorant, BGMI, and Chess. Regular scrims, LAN tournaments, and national esports qualifier watch parties.',
        category: 'Gaming & Sports',
        iconEmoji: '🎮',
        memberCount: 226,
        isJoined: true,
        meetingSchedule: 'Fridays 6:00 PM on Discord',
        recentDiscussions: [
          'Inter-branch Valorant tournament bracket released!',
          'Looking for 1 initiator for campus tier-2 team',
          'Weekly blitz chess contest tonight at 9 PM'
        ],
      ),
      CampusCommunity(
        id: 204,
        name: 'Robotics & IoT Innovators',
        description:
            'Hardware hacking club designing autonomous rovers, drone swarms, and smart campus IoT monitoring systems.',
        category: 'Hardware',
        iconEmoji: '🤖',
        memberCount: 110,
        isJoined: false,
        meetingSchedule: 'Saturdays 2:00 PM @ Robotics Cell',
        recentDiscussions: [
          'ESP32 sensor network prototype deployed in library',
          '3D printing slot bookings for hackathon chassis',
          'PCB layout review session'
        ],
      ),
    ];

    confessions = [
      ConfessionItem(
        id: 301,
        content:
            'I spent 4 hours debugging my distributed systems lab assignment only to realize I had a semicolon at the end of an if-statement! 😭 Still aced the viva though!',
        category: 'Academics',
        timeAgo: '15m ago',
        likeCount: 48,
        hasLiked: true,
        reactions: {'❤️': 32, '😂': 45, '💡': 12, '🔥': 19},
        userReactions: {'😂', '❤️'},
      ),
      ConfessionItem(
        id: 302,
        content:
            'The iced latte and grilled paneer sandwich at the Nescafe booth behind the library got me through mid-term exams. Pure lifesaving fuel.',
        category: 'Campus Life',
        timeAgo: '1h ago',
        likeCount: 65,
        hasLiked: false,
        reactions: {'❤️': 58, '☕': 34, '🔥': 20},
        userReactions: {},
      ),
      ConfessionItem(
        id: 303,
        content:
            'To whoever returned my forgotten laptop charger to the 3rd floor lab reception yesterday: You are a genuine superhero and saved my hackathon project!',
        category: 'Appreciation',
        timeAgo: '3h ago',
        likeCount: 89,
        hasLiked: true,
        reactions: {'❤️': 82, '🙌': 41, '🌟': 28},
        userReactions: {'❤️'},
      ),
    ];

    polls = [
      CampusPollModel(
        id: 401,
        question:
            'Which technology are you most excited to learn and build with this semester at GL Bajaj?',
        category: 'Tech Poll',
        timeLeft: '3 days left',
        totalVotes: 184,
        userVotedIndex: 0,
        options: [
          PollOptionModel(index: 0, text: 'Flutter & Serverpod (Fullstack Dart)', votes: 98),
          PollOptionModel(index: 1, text: 'GenAI, LLMs & LangChain Agents', votes: 56),
          PollOptionModel(index: 2, text: 'Distributed Cloud & Kubernetes', votes: 19),
          PollOptionModel(index: 3, text: 'Cybersecurity & Ethical Hacking', votes: 11),
        ],
      ),
      CampusPollModel(
        id: 402,
        question:
            'What should be the theme for this year\'s Campus Cultural Night at GL Bajaj?',
        category: 'Campus Life',
        timeLeft: '1 day left',
        totalVotes: 312,
        userVotedIndex: null,
        options: [
          PollOptionModel(index: 0, text: 'Retro 90s Bollywood Night', votes: 142),
          PollOptionModel(index: 1, text: 'Cyberpunk & EDM Rave', votes: 108),
          PollOptionModel(index: 2, text: 'Traditional Braj Heritage Folk', votes: 62),
        ],
      ),
    ];

    treasureHunt = TreasureHuntState(
      currentClueIndex: 1,
      totalClues: 3,
      stageTitle: 'The Gateway of Knowledge',
      riddle:
          'I hold thousands of stories, formulas, and silent minds. Where knowledge is stacked high and whisper rules the land, find the book marked with the campus crest at the main entrance desk.',
      locationHint:
          'Look near the Central Library reference counter on Ground Floor.',
      rewardPoints: 50,
      rewardBadge: 'Campus Detective',
      expectedKeyword: 'LIBRARY',
      userScore: 420,
    );

    quizQuestions = [
      QuizQuestionModel(
        id: 501,
        category: 'Flutter & Mobile Architecture',
        question:
            'In Flutter, which widget is best suited for responsive layouts that wrap children to the next line when screen width is constrained?',
        options: ['Wrap', 'Row', 'Column', 'Stack'],
        correctIndex: 0,
        explanation:
            'Wrap displays its children in multiple horizontal or vertical runs, automatically flowing onto new lines.',
      ),
      QuizQuestionModel(
        id: 502,
        category: 'Serverpod Backend',
        question:
            'What is the primary role of SerializationManagerServer in a Serverpod backend application?',
        options: [
          'Managing CSS stylesheets',
          'Serializing models and mapping database tables to Dart classes',
          'Handling DNS routing',
          'Compressing MP4 media'
        ],
        correctIndex: 1,
        explanation:
            'SerializationManagerServer handles serializing and deserializing models, JSON data, and mapping Table definitions for PostgreSQL.',
      ),
      QuizQuestionModel(
        id: 503,
        category: 'Dart Language',
        question:
            'Which keyword in Dart allows a class to share implementation code with multiple class hierarchies via mixins?',
        options: ['implements', 'with', 'extends', 'factory'],
        correctIndex: 1,
        explanation:
            'The `with` keyword applies mixins onto classes without classical inheritance constraints.',
      ),
      QuizQuestionModel(
        id: 504,
        category: 'GL Bajaj Campus Trivia',
        question:
            'What is the official track tagline for the Beyond Aura hackathon track?',
        options: [
          'Code Fast, Ship Hard',
          'Campus Life, Upgraded',
          'Future of Automation',
          'Digital World 2030'
        ],
        correctIndex: 1,
        explanation:
            'The official track for Beyond Aura at GL Bajaj is "Campus Life, Upgraded (Flutter + Serverpod)".',
      ),
    ];

    notifications = [
      CampusNotificationItem(
        id: 601,
        title: 'Study Buddy Request',
        message: 'Priya Patel wants to connect for DSA & C++ study sessions.',
        timeAgo: '10m ago',
        category: 'Study',
      ),
      CampusNotificationItem(
        id: 602,
        title: 'Event Reminder: Hackbriven 2026',
        message: 'Your registration is confirmed. Team check-in starts at 9:00 AM.',
        timeAgo: '2h ago',
        category: 'Event',
      ),
      CampusNotificationItem(
        id: 603,
        title: 'Campus Poll Alert',
        message: 'A new poll about tech preferences is live. Cast your vote!',
        timeAgo: '1d ago',
        category: 'Poll',
        isRead: true,
      ),
    ];

    marketplaceItems = [
      MarketplaceItemModel(
        id: 1,
        sellerId: 101,
        sellerName: 'Rohan Verma',
        sellerAvatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
        title: 'Higher Engineering Mathematics - B.S. Grewal (44th Ed.)',
        description: 'Pristine condition, unmarked formulas, ideal for 1st & 2nd year AKTU syllabus.',
        price: 350.0,
        category: 'textbooks',
        imageUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400',
        isSold: false,
        isExchangeable: true,
        contactPhone: '+91 98765 43210',
        timeAgo: '2d ago',
      ),
      MarketplaceItemModel(
        id: 2,
        sellerId: 102,
        sellerName: 'Priya Singh',
        sellerAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
        title: 'Casio FX-991EX ClassWiz Scientific Calculator',
        description: 'Used for one semester in Engineering Mechanics. Comes with protective slide case.',
        price: 750.0,
        category: 'calculators',
        imageUrl: 'https://images.unsplash.com/photo-1587145820266-a5951ee6f620?w=400',
        isSold: false,
        isExchangeable: false,
        contactPhone: '+91 98765 43211',
        timeAgo: '4d ago',
      ),
      MarketplaceItemModel(
        id: 3,
        sellerId: 103,
        sellerName: 'Aman Gupta',
        sellerAvatar: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=150',
        title: 'Mini Drafter with Canvas Bag (Omega)',
        description: 'Essential for Engineering Graphics (EDG) 1st year lab. Perfectly calibrated ruler.',
        price: 220.0,
        category: 'accessories',
        imageUrl: 'https://images.unsplash.com/photo-1581291518857-4e27b48ff24e?w=400',
        isSold: false,
        isExchangeable: true,
        contactPhone: '+91 98765 43212',
        timeAgo: '6d ago',
      ),
      MarketplaceItemModel(
        id: 4,
        sellerId: 104,
        sellerName: 'Ananya Desai',
        sellerAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
        title: 'Complete Data Structures & Algorithms Handwritten Quantum',
        description: 'Handwritten comprehensive notes covering Trees, Graphs, DP, and AKTU past 5-year solved papers.',
        price: 120.0,
        category: 'notes',
        imageUrl: 'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?w=400',
        isSold: false,
        isExchangeable: false,
        contactPhone: '+91 98765 43213',
        timeAgo: '1d ago',
      ),
    ];

    lostFoundItems = [
      LostFoundItemModel(
        id: 1,
        reporterId: 201,
        reporterName: 'Vikram Malhotra',
        reporterAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        title: 'Black Boat Rockerz 450 Headphones',
        description: 'Misplaced in Central Library 2nd floor reading hall near the journals rack on Thursday afternoon.',
        itemType: 'lost',
        category: 'electronics',
        location: 'Central Library, 2nd Floor',
        timeAgo: '18h ago',
        isResolved: false,
        contactPhone: '+91 98765 54321',
      ),
      LostFoundItemModel(
        id: 2,
        reporterId: 202,
        reporterName: 'Security Desk (Ramanujan Block)',
        reporterAvatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
        title: 'Found: GL Bajaj Student ID Card & Key bunch',
        description: 'ID belongs to B.Tech ECE 2nd year student. Handed over to ground floor security guard room.',
        itemType: 'found',
        category: 'documents',
        location: 'Ramanujan Block, Ground Floor',
        timeAgo: '1d ago',
        isResolved: false,
        contactPhone: '+91 98765 54322',
      ),
      LostFoundItemModel(
        id: 3,
        reporterId: 203,
        reporterName: 'Neha Sharma',
        reporterAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
        title: 'Blue Spiral Chemistry Lab Manual',
        description: 'Left in Chemical Engineering Lab 3 on table 5. Contains evaluated experiment records.',
        itemType: 'found',
        category: 'books',
        location: 'Lab Complex, Room 204',
        timeAgo: '3d ago',
        isResolved: false,
        contactPhone: '+91 98765 54323',
      ),
    ];

    questions = [
      CampusQuestionModel(
        id: 1,
        authorId: 301,
        authorName: 'Anonymous Student',
        isAnonymous: true,
        title: 'How to prepare for AKTU Operating Systems end-sem exam?',
        content: 'Which units carry the highest weightage between Process Synchronization, CPU Scheduling, and Memory Management? Any recommended PYQs?',
        subject: 'Operating Systems',
        upvotes: 24,
        answerCount: 1,
        isResolved: true,
        timeAgo: '2d ago',
        answers: [
          CampusAnswerModel(
            id: 101,
            authorName: 'Rohan Verma (4th Yr CSE)',
            isAnonymous: false,
            content: 'Units 2 and 4 are paramount! Make sure you practice Peterson\'s solution, Banker\'s Algorithm numericals, and Page Replacement FIFO/LRU. Quantum question bank unit 3 also has guaranteed 10-markers.',
            upvotes: 15,
            isAccepted: true,
          ),
        ],
      ),
      CampusQuestionModel(
        id: 2,
        authorId: 302,
        authorName: 'Kavya Patel',
        isAnonymous: false,
        title: 'Is the GL Bajaj Incubation Centre (E-Cell) accepting fresh pitch decks this month?',
        content: 'We have a prototype for an EV battery thermal monitoring device. Who is the faculty coordinator to submit our proposal?',
        subject: 'Entrepreneurship',
        upvotes: 18,
        answerCount: 1,
        isResolved: false,
        timeAgo: '4d ago',
        answers: [
          CampusAnswerModel(
            id: 102,
            authorName: 'Dr. Sharma (Faculty Advisor)',
            isAnonymous: false,
            content: 'Yes! Submissions are open until Nov 12 at the TBI office 3rd Floor Admin Block. Email pitch deck directly to ecell@glbajaj.ac.in.',
            upvotes: 9,
            isAccepted: false,
          ),
        ],
      ),
    ];

    studyTasks = [
      StudyTaskModel(
        id: 1,
        title: 'Complete Dijkstra Algorithm implementation in C++',
        subject: 'Data Structures',
        deadline: DateTime.now().add(const Duration(days: 2)),
        isCompleted: false,
        priority: 'high',
        notes: 'Submit on GL Bajaj Google Classroom before 11:59 PM',
      ),
      StudyTaskModel(
        id: 2,
        title: 'Review 2024 AKTU End-Sem Question Paper for Microprocessors',
        subject: 'Microprocessors',
        deadline: DateTime.now().add(const Duration(days: 3)),
        isCompleted: false,
        priority: 'medium',
        notes: 'Focus on 8086 pin diagram and interrupt vector table',
      ),
      StudyTaskModel(
        id: 3,
        title: 'Prepare 5-minute presentation for Hackbriven 2026 jury',
        subject: 'Hackathon',
        deadline: DateTime.now().add(const Duration(days: 5)),
        isCompleted: true,
        priority: 'high',
        notes: 'Highlight Serverpod PostgreSQL real-time sync architecture',
      ),
    ];

    studyResources = [
      StudyResourceModel(
        id: 1,
        uploaderName: 'Prof. S. K. Sharma (Curated)',
        title: 'Computer Networks Complete Unit 1-5 Lecture Notes',
        description: 'Comprehensive illustrated notes on OSI Model, TCP/IP, Sliding Window Protocol, Routing Algorithms.',
        course: 'B.Tech CSE',
        semester: 5,
        subject: 'Computer Networks',
        fileUrl: 'https://campusconnect.glbajaj.ac.in/resources/cn_notes.pdf',
        fileType: 'pdf',
        downloadCount: 342,
        rating: 4.9,
        isBookmarked: true,
      ),
      StudyResourceModel(
        id: 2,
        uploaderName: 'Beyond Aura Team',
        title: 'AKTU 5-Year Solved Papers: Design & Analysis of Algorithms',
        description: 'Categorized solutions covering Asymptotic notations, Greedy, Dynamic Programming, Backtracking, NP-Completeness.',
        course: 'B.Tech CSE',
        semester: 4,
        subject: 'DAA',
        fileUrl: 'https://campusconnect.glbajaj.ac.in/resources/daa_pyqs.pdf',
        fileType: 'pyq',
        downloadCount: 518,
        rating: 4.95,
        isBookmarked: false,
      ),
      StudyResourceModel(
        id: 3,
        uploaderName: 'Aarav Sharma',
        title: 'Python Machine Learning Lab Source Codes & Jupyter Notebooks',
        description: 'Clean documented scripts for Linear Regression, SVM, Decision Trees, and K-Means with sample datasets.',
        course: 'B.Tech CSE',
        semester: 6,
        subject: 'Machine Learning',
        fileUrl: 'https://campusconnect.glbajaj.ac.in/resources/ml_lab.zip',
        fileType: 'code',
        downloadCount: 289,
        rating: 4.8,
        isBookmarked: true,
      ),
    ];

    announcements = [
      CampusAnnouncementModel(
        id: 1,
        title: 'GL Bajaj Hackbriven 2026 Registration Open — 36H National Hackathon',
        content: 'Beyond Aura and the Dept. of CSE invite all innovators to the flagship hackathon on Nov 15-16, 2026. ₹1,50,000 in cash prizes, direct mentorship, and industry internship fast-tracks. Register your team on CampusConnect!',
        category: 'event',
        authorName: 'Dean Student Welfare & Beyond Aura',
        isPinned: true,
        targetAudience: 'All Engineering & MBA Students',
        timeAgo: '4h ago',
        readCount: 1420,
        isRead: false,
      ),
      CampusAnnouncementModel(
        id: 2,
        title: 'AKTU Odd-Semester Examination Form Submission Schedule & Guidelines',
        content: 'All regular and carry-over students are required to verify their elective choices on the ERP portal before November 10. Admit cards will be released post-clearance.',
        category: 'exam',
        authorName: 'Office of the Controller of Examinations',
        isPinned: true,
        targetAudience: 'All Semesters',
        timeAgo: '1d ago',
        readCount: 2150,
        isRead: true,
      ),
      CampusAnnouncementModel(
        id: 3,
        title: 'Campus Placements 2026: Tier-1 Tech Drive Registration Mandatory Briefing',
        content: 'Training & Placement Cell (T&P) will host an orientation in Audi 1 at 3:00 PM this Wednesday for pre-final and final year eligible students.',
        category: 'academic',
        authorName: 'Corporate Relations & Placement Cell',
        isPinned: false,
        targetAudience: '3rd & 4th Year Students',
        timeAgo: '2d ago',
        readCount: 980,
        isRead: true,
      ),
    ];

    streakInfo = StreakInfoModel(
      currentStreak: 5,
      bestStreak: 14,
      hasCheckedInToday: false,
      streakRewards: ['Bronze Streaker', 'Silver Scholar', 'Gold Campus Legend'],
    );

    leaderboard = [
      LeaderboardEntryModel(
        rank: 1,
        studentName: 'Priya Singh',
        avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
        department: 'B.Tech CSE',
        semester: 5,
        totalXp: 3450,
        badge: '🏆 Grandmaster',
      ),
      LeaderboardEntryModel(
        rank: 2,
        studentName: 'Rohan Verma',
        avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
        department: 'B.Tech IT',
        semester: 7,
        totalXp: 3120,
        badge: '⚡ Top Contributor',
      ),
      LeaderboardEntryModel(
        rank: 3,
        studentName: 'Aarav Sharma',
        avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
        department: 'B.Tech CSE',
        semester: 5,
        totalXp: 2850,
        badge: '🚀 Hackathon Lead',
        isCurrentUser: true,
      ),
      LeaderboardEntryModel(
        rank: 4,
        studentName: 'Kavya Patel',
        avatarUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150',
        department: 'B.Tech ECE',
        semester: 3,
        totalXp: 2640,
        badge: '💡 Innovator',
      ),
      LeaderboardEntryModel(
        rank: 5,
        studentName: 'Vikram Malhotra',
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        department: 'B.Tech ME',
        semester: 5,
        totalXp: 2280,
        badge: '🎯 Clue Master',
      ),
    ];
  }

  // Actions
  void toggleEventRegistration(int eventId) {
    final idx = events.indexWhere((e) => e.id == eventId);
    if (idx != -1) {
      final ev = events[idx];
      ev.isRegistered = !ev.isRegistered;
      if (ev.isRegistered) {
        ev.registeredCount++;
        currentUser.totalPoints += 20;
      } else {
        ev.registeredCount--;
        currentUser.totalPoints -= 20;
      }
      notifyListeners();
    }
  }

  void toggleStudyBuddyConnect(int userId) {
    final idx = studyBuddies.indexWhere((s) => s.userId == userId);
    if (idx != -1) {
      final buddy = studyBuddies[idx];
      if (buddy.requestStatus == 'none') {
        buddy.requestStatus = 'pending';
      } else if (buddy.requestStatus == 'pending') {
        buddy.requestStatus = 'none';
      } else if (buddy.requestStatus == 'accepted') {
        buddy.requestStatus = 'none';
      }
      notifyListeners();
    }
  }

  void toggleCommunityMembership(int communityId) {
    final idx = communities.indexWhere((c) => c.id == communityId);
    if (idx != -1) {
      final comm = communities[idx];
      comm.isJoined = !comm.isJoined;
      if (comm.isJoined) {
        comm.memberCount++;
        currentUser.totalPoints += 15;
      } else {
        comm.memberCount--;
        currentUser.totalPoints -= 15;
      }
      notifyListeners();
    }
  }

  void toggleConfessionReaction(int confessionId, String emoji) {
    final idx = confessions.indexWhere((c) => c.id == confessionId);
    if (idx != -1) {
      final item = confessions[idx];
      if (item.userReactions.contains(emoji)) {
        item.userReactions.remove(emoji);
        item.reactions[emoji] = (item.reactions[emoji] ?? 1) - 1;
        if (emoji == '❤️') item.likeCount--;
      } else {
        item.userReactions.add(emoji);
        item.reactions[emoji] = (item.reactions[emoji] ?? 0) + 1;
        if (emoji == '❤️') item.likeCount++;
      }
      notifyListeners();
    }
  }

  void submitConfession(String text, String category) {
    if (text.trim().isEmpty) return;
    confessions.insert(
      0,
      ConfessionItem(
        id: DateTime.now().millisecondsSinceEpoch,
        content: text.trim(),
        category: category,
        timeAgo: 'Just now',
        likeCount: 0,
        reactions: {'❤️': 0, '😂': 0, '💡': 0, '🔥': 0},
      ),
    );
    currentUser.totalPoints += 10;
    notifyListeners();
  }

  void addConfession(String text, String category) => submitConfession(text, category);

  void createPoll({
    required String question,
    required String category,
    required List<String> optionTexts,
  }) {
    final newPoll = CampusPollModel(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      question: question.trim(),
      category: category.trim(),
      timeLeft: '24 hours left',
      totalVotes: 0,
      options: List.generate(
        optionTexts.length,
        (i) => PollOptionModel(index: i, text: optionTexts[i], votes: 0),
      ),
    );
    polls.insert(0, newPoll);
    currentUser.totalPoints += 15;
    notifyListeners();
  }

  void reportConfession(int confessionId) {
    final idx = confessions.indexWhere((c) => c.id == confessionId);
    if (idx != -1) {
      confessions[idx].isReported = true;
      notifyListeners();
    }
  }

  void votePoll(int pollId, int optionIndex) {
    final pIdx = polls.indexWhere((p) => p.id == pollId);
    if (pIdx != -1) {
      final poll = polls[pIdx];
      if (poll.userVotedIndex != null) return; // 1 vote rule
      poll.userVotedIndex = optionIndex;
      poll.options[optionIndex].votes++;
      poll.totalVotes++;
      currentUser.totalPoints += 10;
      notifyListeners();
    }
  }

  bool submitTreasureAnswer(String answer) {
    final clean = answer.trim().toUpperCase();
    if (clean.contains(treasureHunt.expectedKeyword)) {
      treasureHunt.isCompleted = true;
      treasureHunt.userScore += treasureHunt.rewardPoints;
      currentUser.totalPoints += treasureHunt.rewardPoints;
      if (!currentUser.badges.contains(treasureHunt.rewardBadge)) {
        currentUser.badges.add(treasureHunt.rewardBadge);
      }
      notifyListeners();
      return true;
    }
    return false;
  }

  void revealTreasureHint() {
    if (!treasureHunt.hintRevealed) {
      treasureHunt.hintRevealed = true;
      treasureHunt.userScore = (treasureHunt.userScore - 15).clamp(0, 9999);
      currentUser.totalPoints = (currentUser.totalPoints - 15).clamp(0, 9999);
      notifyListeners();
    }
  }

  void selectQuizAnswer(int optionIndex) {
    if (quizAnswerSubmitted) return;
    quizSelectedAnswer = optionIndex;
    quizAnswerSubmitted = true;
    final currentQ = quizQuestions[quizCurrentIndex];
    if (optionIndex == currentQ.correctIndex) {
      quizScore += 25;
      quizStreak++;
      currentUser.totalPoints += 25;
    } else {
      quizStreak = 0;
    }
    notifyListeners();
  }

  void nextQuizQuestion() {
    if (quizCurrentIndex < quizQuestions.length - 1) {
      quizCurrentIndex++;
      quizSelectedAnswer = null;
      quizAnswerSubmitted = false;
    } else {
      quizCompleted = true;
      if (quizScore >= 75 && !currentUser.badges.contains('Quiz Prodigy')) {
        currentUser.badges.add('Quiz Prodigy');
      }
    }
    notifyListeners();
  }

  void resetQuiz() {
    quizCurrentIndex = 0;
    quizSelectedAnswer = null;
    quizAnswerSubmitted = false;
    quizScore = 0;
    quizStreak = 0;
    quizCompleted = false;
    notifyListeners();
  }

  void updateBio(String newBio) {
    currentUser.bio = newBio.trim();
    notifyListeners();
  }

  void updateStudyMode(String mode) {
    currentUser.preferredStudyMode = mode;
    notifyListeners();
  }

  void markAllNotificationsAsRead() {
    for (var n in notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  // --- Marketplace & Exchange Actions ---
  void addMarketplaceItem({
    required String title,
    required String description,
    required double price,
    required String category,
    required bool isExchangeable,
    String? contactPhone,
  }) {
    final newItem = MarketplaceItemModel(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      sellerId: currentUser.id,
      sellerName: currentUser.fullName,
      sellerAvatar: currentUser.avatarUrl,
      title: title.trim(),
      description: description.trim(),
      price: price,
      category: category,
      imageUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400',
      isSold: false,
      isExchangeable: isExchangeable,
      contactPhone: contactPhone ?? '+91 98765 00000',
      timeAgo: 'Just now',
    );
    marketplaceItems.insert(0, newItem);
    currentUser.totalPoints += 10;
    notifyListeners();
  }

  void markMarketplaceItemSold(int itemId) {
    final idx = marketplaceItems.indexWhere((it) => it.id == itemId);
    if (idx != -1) {
      marketplaceItems[idx].isSold = true;
      notifyListeners();
    }
  }

  void reportMarketplaceItem(int itemId) {
    notifyListeners();
  }

  // --- Lost & Found Actions ---
  void addLostFoundItem({
    required String title,
    required String description,
    required String itemType,
    required String category,
    required String location,
    String? contactPhone,
  }) {
    final newItem = LostFoundItemModel(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      reporterId: currentUser.id,
      reporterName: currentUser.fullName,
      reporterAvatar: currentUser.avatarUrl,
      title: title.trim(),
      description: description.trim(),
      itemType: itemType,
      category: category,
      location: location.trim(),
      timeAgo: 'Just now',
      isResolved: false,
      contactPhone: contactPhone ?? '+91 98765 00000',
    );
    lostFoundItems.insert(0, newItem);
    currentUser.totalPoints += 15;
    notifyListeners();
  }

  void resolveLostFoundItem(int itemId) {
    final idx = lostFoundItems.indexWhere((it) => it.id == itemId);
    if (idx != -1) {
      lostFoundItems[idx].isResolved = true;
      notifyListeners();
    }
  }

  // --- Campus Q&A Actions ---
  void askQuestion({
    required String title,
    required String content,
    required String subject,
    required bool isAnonymous,
  }) {
    final newQ = CampusQuestionModel(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      authorId: currentUser.id,
      authorName: isAnonymous ? 'Anonymous Student' : currentUser.fullName,
      isAnonymous: isAnonymous,
      title: title.trim(),
      content: content.trim(),
      subject: subject.trim(),
      upvotes: 1,
      answerCount: 0,
      isResolved: false,
      timeAgo: 'Just now',
      userUpvoted: true,
      answers: [],
    );
    questions.insert(0, newQ);
    currentUser.totalPoints += 10;
    notifyListeners();
  }

  void addAnswer({
    required int questionId,
    required String content,
    required bool isAnonymous,
  }) {
    final idx = questions.indexWhere((q) => q.id == questionId);
    if (idx != -1) {
      final newAns = CampusAnswerModel(
        id: DateTime.now().millisecondsSinceEpoch % 100000,
        authorName: isAnonymous ? 'Anonymous Student' : currentUser.fullName,
        isAnonymous: isAnonymous,
        content: content.trim(),
        upvotes: 0,
        isAccepted: false,
        userUpvoted: false,
      );
      questions[idx].answers.add(newAns);
      questions[idx].answerCount++;
      currentUser.totalPoints += 15;
      notifyListeners();
    }
  }

  void toggleUpvoteQuestion(int questionId) {
    final idx = questions.indexWhere((q) => q.id == questionId);
    if (idx != -1) {
      final q = questions[idx];
      if (q.userUpvoted) {
        q.upvotes--;
        q.userUpvoted = false;
      } else {
        q.upvotes++;
        q.userUpvoted = true;
      }
      notifyListeners();
    }
  }

  void toggleUpvoteAnswer(int questionId, int answerId) {
    final qIdx = questions.indexWhere((q) => q.id == questionId);
    if (qIdx != -1) {
      final aIdx = questions[qIdx].answers.indexWhere((a) => a.id == answerId);
      if (aIdx != -1) {
        final a = questions[qIdx].answers[aIdx];
        if (a.userUpvoted) {
          a.upvotes--;
          a.userUpvoted = false;
        } else {
          a.upvotes++;
          a.userUpvoted = true;
        }
        notifyListeners();
      }
    }
  }

  void markBestAnswer(int questionId, int answerId) {
    final qIdx = questions.indexWhere((q) => q.id == questionId);
    if (qIdx != -1) {
      for (var a in questions[qIdx].answers) {
        a.isAccepted = (a.id == answerId);
      }
      questions[qIdx].isResolved = true;
      notifyListeners();
    }
  }

  // --- Study Planner Actions ---
  void addStudyTask({
    required String title,
    required String subject,
    required DateTime deadline,
    required String priority,
    String? notes,
  }) {
    final newTask = StudyTaskModel(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      title: title.trim(),
      subject: subject.trim(),
      deadline: deadline,
      isCompleted: false,
      priority: priority,
      notes: notes?.trim(),
    );
    studyTasks.add(newTask);
    notifyListeners();
  }

  void toggleStudyTask(int taskId) {
    final idx = studyTasks.indexWhere((t) => t.id == taskId);
    if (idx != -1) {
      final t = studyTasks[idx];
      t.isCompleted = !t.isCompleted;
      if (t.isCompleted) {
        currentUser.totalPoints += 5;
      }
      notifyListeners();
    }
  }

  void deleteStudyTask(int taskId) {
    studyTasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }

  // --- Study Resource Actions ---
  void addStudyResource({
    required String title,
    required String description,
    required String course,
    required int semester,
    required String subject,
    required String fileType,
  }) {
    final newRes = StudyResourceModel(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      uploaderName: currentUser.fullName,
      title: title.trim(),
      description: description.trim(),
      course: course,
      semester: semester,
      subject: subject.trim(),
      fileUrl: 'https://campusconnect.glbajaj.ac.in/resources/user_upload.pdf',
      fileType: fileType,
      downloadCount: 1,
      rating: 5.0,
      isBookmarked: false,
    );
    studyResources.insert(0, newRes);
    currentUser.totalPoints += 25;
    notifyListeners();
  }

  void toggleBookmarkResource(int resourceId) {
    final idx = studyResources.indexWhere((r) => r.id == resourceId);
    if (idx != -1) {
      studyResources[idx].isBookmarked = !studyResources[idx].isBookmarked;
      notifyListeners();
    }
  }

  // --- Announcements Actions ---
  void markAnnouncementRead(int announcementId) {
    final idx = announcements.indexWhere((a) => a.id == announcementId);
    if (idx != -1) {
      announcements[idx].isRead = true;
      notifyListeners();
    }
  }

  // --- Streak Check-in Action ---
  void checkInDailyStreak() {
    if (!streakInfo.hasCheckedInToday) {
      streakInfo.hasCheckedInToday = true;
      streakInfo.currentStreak++;
      if (streakInfo.currentStreak > streakInfo.bestStreak) {
        streakInfo.bestStreak = streakInfo.currentStreak;
      }
      currentUser.totalPoints += 50;
      notifyListeners();
    }
  }

  // --- Daily Missions System (Section 4) ---
  bool dailyMissionsBonusClaimed = false;

  List<DailyMissionItem> getDailyMissions() {
    final hasCheckedIn = streakInfo.hasCheckedInToday;
    final hasVotedPoll = polls.any((p) => p.userVotedIndex != null);
    final hasQuizAttempt = quizAnswerSubmitted;
    final hasClubJoined = communities.any((c) => c.isJoined);
    final hasBuddyRequest = studyBuddies.any((b) => b.requestStatus != 'none');

    return [
      DailyMissionItem(
        id: 'mission_checkin',
        title: 'Daily Campus Check-In',
        description: 'Keep your consecutive streak alive on campus',
        emoji: '🔥',
        xpReward: 50,
        isCompleted: hasCheckedIn,
        actionTab: 'home',
      ),
      DailyMissionItem(
        id: 'mission_poll',
        title: 'Vote in Campus Poll',
        description: 'Voice your stance on current GL Bajaj campus affairs',
        emoji: '🗳️',
        xpReward: 20,
        isCompleted: hasVotedPoll,
        actionTab: 'discover',
      ),
      DailyMissionItem(
        id: 'mission_quiz',
        title: 'Solve Today\'s Battle Quiz',
        description: 'Test your academic knowledge in CS and Tech',
        emoji: '⚡',
        xpReward: 30,
        isCompleted: hasQuizAttempt,
        actionTab: 'play',
      ),
      DailyMissionItem(
        id: 'mission_club',
        title: 'Join a Student Community',
        description: 'Connect with campus clubs and special interest groups',
        emoji: '🌱',
        xpReward: 25,
        isCompleted: hasClubJoined,
        actionTab: 'discover',
      ),
      DailyMissionItem(
        id: 'mission_buddy',
        title: 'Connect with a Study Buddy',
        description: 'Send a study partnership request to a peer',
        emoji: '🤝',
        xpReward: 25,
        isCompleted: hasBuddyRequest,
        actionTab: 'discover',
      ),
    ];
  }

  bool claimDailyMissionsReward() {
    final missions = getDailyMissions();
    final allDone = missions.every((m) => m.isCompleted);
    if (allDone && !dailyMissionsBonusClaimed) {
      dailyMissionsBonusClaimed = true;
      currentUser.totalPoints += 100;
      notifyListeners();
      return true;
    }
    return false;
  }

  // --- Campus Pulse Real-Time Feed (Section 3) ---
  List<CampusPulseItem> getCampusPulseItems() {
    final featuredEv = events.isNotEmpty ? events.first : null;
    final activePollItem = polls.isNotEmpty ? polls.first : null;
    final activeClub = communities.isNotEmpty ? communities.first : null;
    final marketItem = marketplaceItems.isNotEmpty ? marketplaceItems.first : null;

    final pulseList = <CampusPulseItem>[];

    if (featuredEv != null) {
      pulseList.add(
        CampusPulseItem(
          id: 'pulse_event_1',
          title: '${featuredEv.registeredCount} students booked passes',
          subtitle: featuredEv.title,
          timeAgo: 'Just now',
          emoji: '🔥',
          category: 'Trending Event',
          avatars: [
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
          ],
          highlightText: 'Fast filling (${((featuredEv.registeredCount / featuredEv.capacity) * 100).toInt()}%)',
        ),
      );
    }

    if (activePollItem != null) {
      pulseList.add(
        CampusPulseItem(
          id: 'pulse_poll_1',
          title: '${activePollItem.totalVotes} campus votes recorded',
          subtitle: activePollItem.question,
          timeAgo: '12m ago',
          emoji: '🗳️',
          category: 'Live Opinion',
          avatars: [
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150',
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
          ],
          highlightText: activePollItem.timeLeft,
        ),
      );
    }

    if (activeClub != null) {
      pulseList.add(
        CampusPulseItem(
          id: 'pulse_club_1',
          title: '${activeClub.memberCount} active developers joined',
          subtitle: activeClub.name,
          timeAgo: '28m ago',
          emoji: '🌱',
          category: 'Community Surge',
          avatars: [
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
          ],
          highlightText: activeClub.category,
        ),
      );
    }

    if (marketItem != null) {
      pulseList.add(
        CampusPulseItem(
          id: 'pulse_market_1',
          title: 'Fresh textbook listing posted',
          subtitle: marketItem.title,
          timeAgo: marketItem.timeAgo,
          emoji: '📦',
          category: 'Student Market',
          avatars: [marketItem.sellerAvatar],
          highlightText: '₹${marketItem.price.toInt()}',
        ),
      );
    }

    return pulseList;
  }
}

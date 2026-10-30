import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../../services/campus_data_service.dart';

class CustomBottomSheet {
  static void showCreateActionSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      builder: (ctx) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Create on Campus Build',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  )
                ],
              ),
              const SizedBox(height: 14),
              _buildOptionTile(
                context: ctx,
                emoji: '🤫',
                color: AppColors.coral,
                title: 'Post Anonymous Confession',
                subtitle: 'Share honest thoughts safely on the campus secret wall',
                onTap: () {
                  Navigator.pop(ctx);
                  _showCreateConfessionDialog(context);
                },
              ),
              const SizedBox(height: 10),
              _buildOptionTile(
                context: ctx,
                emoji: '🗳️',
                color: AppColors.goldenYellow,
                title: 'Launch Campus Poll',
                subtitle: 'Gather live student opinions with real-time percentages',
                onTap: () {
                  Navigator.pop(ctx);
                  _showCreatePollDialog(context);
                },
              ),
              const SizedBox(height: 10),
              _buildOptionTile(
                context: ctx,
                emoji: '🛍️',
                color: AppColors.emerald,
                title: 'List Marketplace Item',
                subtitle: 'Sell or exchange textbooks, calculators, and drafters',
                onTap: () {
                  Navigator.pop(ctx);
                  _showCreateMarketplaceDialog(context);
                },
              ),
              const SizedBox(height: 10),
              _buildOptionTile(
                context: ctx,
                emoji: '🔍',
                color: AppColors.coral,
                title: 'Report Lost or Found Item',
                subtitle: 'Help peers recover misplaced IDs, earphones, or books',
                onTap: () {
                  Navigator.pop(ctx);
                  _showCreateLostFoundDialog(context);
                },
              ),
              const SizedBox(height: 10),
              _buildOptionTile(
                context: ctx,
                emoji: '❓',
                color: AppColors.softLavender,
                title: 'Ask Academic Question',
                subtitle: 'Get answers from senior students or professors',
                onTap: () {
                  Navigator.pop(ctx);
                  _showCreateQuestionDialog(context);
                },
              ),
              const SizedBox(height: 10),
              _buildOptionTile(
                context: ctx,
                emoji: '📚',
                color: AppColors.emerald,
                title: 'Share Notes & PYQs',
                subtitle: 'Upload study material to help your branch and batch',
                onTap: () {
                  Navigator.pop(ctx);
                  _showCreateResourceDialog(context);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildOptionTile({
    required BuildContext context,
    required String emoji,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Text(emoji, style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // 1. Confession Dialog
  static void _showCreateConfessionDialog(BuildContext context) {
    final ctrl = TextEditingController();
    String category = 'Campus Life';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: const Text('Post Anonymous Confession'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: ['Campus Life', 'Academics', 'Hostel', 'Crushes & Vibes']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setDlgState(() => category = v ?? 'Campus Life'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ctrl,
                maxLines: 4,
                maxLength: 280,
                decoration: const InputDecoration(
                  hintText: 'Share what happened... Your name or roll number is never stored.',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (ctrl.text.trim().isNotEmpty) {
                  CampusDataService().addConfession(ctrl.text.trim(), category);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Confession shared anonymously on campus wall!')),
                  );
                }
              },
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }

  // 2. Poll Dialog
  static void _showCreatePollDialog(BuildContext context) {
    final questionCtrl = TextEditingController();
    final opt1Ctrl = TextEditingController();
    final opt2Ctrl = TextEditingController();
    final opt3Ctrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Launch Campus Poll'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionCtrl,
                decoration: const InputDecoration(labelText: 'Poll Question (e.g. Best canteen snack?)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: opt1Ctrl,
                decoration: const InputDecoration(labelText: 'Option 1'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: opt2Ctrl,
                decoration: const InputDecoration(labelText: 'Option 2'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: opt3Ctrl,
                decoration: const InputDecoration(labelText: 'Option 3 (Optional)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (questionCtrl.text.trim().isNotEmpty &&
                  opt1Ctrl.text.trim().isNotEmpty &&
                  opt2Ctrl.text.trim().isNotEmpty) {
                final options = [opt1Ctrl.text.trim(), opt2Ctrl.text.trim()];
                if (opt3Ctrl.text.trim().isNotEmpty) {
                  options.add(opt3Ctrl.text.trim());
                }
                CampusDataService().createPoll(
                  question: questionCtrl.text.trim(),
                  category: 'Campus Poll',
                  optionTexts: options,
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Poll launched live!')),
                );
              }
            },
            child: const Text('Launch'),
          ),
        ],
      ),
    );
  }

  // 3. Marketplace Listing Dialog
  static void _showCreateMarketplaceDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    String category = 'textbooks';
    bool isExchangeable = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: const Text('List Marketplace Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Item Name (e.g. B.S. Grewal Math 44th Ed)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price (₹)'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: const [
                    DropdownMenuItem(value: 'textbooks', child: Text('Textbooks & Quantum')),
                    DropdownMenuItem(value: 'calculators', child: Text('Calculators (Casio/FX)')),
                    DropdownMenuItem(value: 'accessories', child: Text('Drafters & Drawing Tools')),
                    DropdownMenuItem(value: 'notes', child: Text('Handwritten Notes')),
                    DropdownMenuItem(value: 'electronics', child: Text('Electronics & Gadgets')),
                  ],
                  onChanged: (v) => setDlgState(() => category = v ?? 'textbooks'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Condition & Details'),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isExchangeable,
                      onChanged: (v) => setDlgState(() => isExchangeable = v ?? false),
                    ),
                    const Text('Open to Exchange / Swap', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.trim().isNotEmpty && priceCtrl.text.trim().isNotEmpty) {
                  final price = double.tryParse(priceCtrl.text.trim()) ?? 0.0;
                  CampusDataService().addMarketplaceItem(
                    title: titleCtrl.text,
                    description: descCtrl.text.isEmpty ? 'Excellent condition, used by student.' : descCtrl.text,
                    price: price,
                    category: category,
                    isExchangeable: isExchangeable,
                  );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Item listed on Campus Marketplace!')),
                  );
                }
              },
              child: const Text('List Item'),
            ),
          ],
        ),
      ),
    );
  }

  // 4. Lost & Found Dialog
  static void _showCreateLostFoundDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final locCtrl = TextEditingController();
    String itemType = 'lost';
    String category = 'electronics';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: const Text('Report Lost or Found Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: itemType,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: const [
                    DropdownMenuItem(value: 'lost', child: Text('🔴 I LOST this item')),
                    DropdownMenuItem(value: 'found', child: Text('🟢 I FOUND this item')),
                  ],
                  onChanged: (v) => setDlgState(() => itemType = v ?? 'lost'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Item Name (e.g. Black Boat Earphones)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: locCtrl,
                  decoration: const InputDecoration(labelText: 'Campus Location (e.g. Audi 2 / Library)'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: const [
                    DropdownMenuItem(value: 'electronics', child: Text('Electronics & Chargers')),
                    DropdownMenuItem(value: 'documents', child: Text('ID Cards & Documents')),
                    DropdownMenuItem(value: 'books', child: Text('Books & Lab Manuals')),
                    DropdownMenuItem(value: 'accessories', child: Text('Keys & Accessories')),
                  ],
                  onChanged: (v) => setDlgState(() => category = v ?? 'electronics'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Additional Clues or Identifying Marks'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.trim().isNotEmpty && locCtrl.text.trim().isNotEmpty) {
                  CampusDataService().addLostFoundItem(
                    title: titleCtrl.text,
                    description: descCtrl.text.isEmpty ? 'Please reach out if you have information.' : descCtrl.text,
                    itemType: itemType,
                    category: category,
                    location: locCtrl.text,
                  );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notice posted to Lost & Found desk!')),
                  );
                }
              },
              child: const Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }

  // 5. Ask Question Dialog
  static void _showCreateQuestionDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String subject = 'Operating Systems';
    bool isAnonymous = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: const Text('Ask Academic Question'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: subject,
                  decoration: const InputDecoration(labelText: 'Subject / Area'),
                  items: const [
                    DropdownMenuItem(value: 'Operating Systems', child: Text('Operating Systems')),
                    DropdownMenuItem(value: 'Data Structures', child: Text('Data Structures & Algorithms')),
                    DropdownMenuItem(value: 'Computer Networks', child: Text('Computer Networks')),
                    DropdownMenuItem(value: 'Machine Learning', child: Text('Machine Learning & AI')),
                    DropdownMenuItem(value: 'Entrepreneurship', child: Text('Entrepreneurship & E-Cell')),
                  ],
                  onChanged: (v) => setDlgState(() => subject = v ?? 'Operating Systems'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Question Title (e.g. Peterson Solution Doubt)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Elaborate your doubt with specifics...'),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isAnonymous,
                      onChanged: (v) => setDlgState(() => isAnonymous = v ?? false),
                    ),
                    const Text('Ask Anonymously', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.trim().isNotEmpty) {
                  CampusDataService().askQuestion(
                    title: titleCtrl.text,
                    content: descCtrl.text.isEmpty ? titleCtrl.text : descCtrl.text,
                    subject: subject,
                    isAnonymous: isAnonymous,
                  );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Academic question published to student community!')),
                  );
                }
              },
              child: const Text('Ask Question'),
            ),
          ],
        ),
      ),
    );
  }

  // 6. Share Notes & Resources Dialog
  static void _showCreateResourceDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final subjectCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String fileType = 'pdf';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: const Text('Upload Notes & Resources'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Title (e.g. Unit 3 Trees & Graphs Notes)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: subjectCtrl,
                  decoration: const InputDecoration(labelText: 'Subject (e.g. Data Structures)'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: fileType,
                  decoration: const InputDecoration(labelText: 'Resource Type'),
                  items: const [
                    DropdownMenuItem(value: 'pdf', child: Text('Lecture Notes (PDF)')),
                    DropdownMenuItem(value: 'pyq', child: Text('Solved PYQs / Question Bank')),
                    DropdownMenuItem(value: 'code', child: Text('Lab Source Code / Jupyter')),
                  ],
                  onChanged: (v) => setDlgState(() => fileType = v ?? 'pdf'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Brief Summary / Syllabus Coverage'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.trim().isNotEmpty && subjectCtrl.text.trim().isNotEmpty) {
                  CampusDataService().addStudyResource(
                    title: titleCtrl.text,
                    description: descCtrl.text.isEmpty ? 'Handwritten peer notes.' : descCtrl.text,
                    course: 'B.Tech CSE',
                    semester: 5,
                    subject: subjectCtrl.text,
                    fileType: fileType,
                  );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Study resource uploaded! +25 XP awarded!')),
                  );
                }
              },
              child: const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}

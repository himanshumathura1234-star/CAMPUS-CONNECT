import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/gradient_action_button.dart';
import '../../../services/campus_data_service.dart';

class StudyPlannerWidget extends StatefulWidget {
  const StudyPlannerWidget({super.key});

  @override
  State<StudyPlannerWidget> createState() => _StudyPlannerWidgetState();
}

class _StudyPlannerWidgetState extends State<StudyPlannerWidget> {
  String _selectedPriority = 'All';

  void _showAddTaskDialog(BuildContext context, CampusDataService dataService) {
    final titleCtrl = TextEditingController();
    final subjectCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String priority = 'high';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: const Text('Add Study Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Task Title (e.g. Solve DAA PYQs)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: subjectCtrl,
                  decoration: const InputDecoration(labelText: 'Subject (e.g. Operating Systems)'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: priority,
                  decoration: const InputDecoration(labelText: 'Priority'),
                  items: const [
                    DropdownMenuItem(value: 'high', child: Text('🔴 High Priority')),
                    DropdownMenuItem(value: 'medium', child: Text('🟡 Medium Priority')),
                    DropdownMenuItem(value: 'low', child: Text('🟢 Low Priority')),
                  ],
                  onChanged: (v) => setDlgState(() => priority = v ?? 'medium'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: notesCtrl,
                  decoration: const InputDecoration(labelText: 'Notes / Assignment Link (Optional)'),
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
                  dataService.addStudyTask(
                    title: titleCtrl.text,
                    subject: subjectCtrl.text,
                    deadline: DateTime.now().add(const Duration(days: 3)),
                    priority: priority,
                    notes: notesCtrl.text,
                  );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Study task scheduled!')),
                  );
                }
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColors.coral;
      case 'medium':
        return const Color(0xFFC78500); // Golden amber
      default:
        return AppColors.emerald;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataService = CampusDataService();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: dataService,
      builder: (context, _) {
        final allTasks = dataService.studyTasks;
        final completedCount = allTasks.where((t) => t.isCompleted).length;
        final progress = allTasks.isEmpty ? 0.0 : completedCount / allTasks.length;

        final filteredTasks = _selectedPriority == 'All'
            ? allTasks
            : allTasks.where((t) => t.priority.toLowerCase() == _selectedPriority.toLowerCase()).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Header Card
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '📚 AKTU Exam Sprint',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                      Text(
                        '12 Days Remaining',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$completedCount of ${allTasks.length} Tasks Done',
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.white.withValues(alpha: 0.25),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.goldenYellow),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // Header with Filters & Add Button
            Row(
              children: [
                Text(
                  'My Study Tasks',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.charcoal,
                  ),
                ),
                const Spacer(),
                GradientActionButton(
                  label: '+ Task',
                  height: 34,
                  width: 84,
                  borderRadius: 12,
                  gradient: AppColors.mintGradient,
                  onPressed: () => _showAddTaskDialog(context, dataService),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Priority Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'High', 'Medium', 'Low'].map((p) {
                  final isSel = _selectedPriority == p;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        p,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                          color: isSel ? AppColors.coral : (isDark ? AppColors.darkTextSecondary : AppColors.charcoal),
                        ),
                      ),
                      selected: isSel,
                      onSelected: (v) => setState(() => _selectedPriority = p),
                      selectedColor: AppColors.coral.withValues(alpha: 0.15),
                      backgroundColor: isDark ? AppColors.darkSurfaceElevated : AppColors.pureWhite,
                      side: BorderSide(
                        color: isSel ? AppColors.coral : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            // Tasks List
            if (filteredTasks.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'No tasks in this category. You are all caught up! 🎉',
                    style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredTasks.length,
                itemBuilder: (ctx, idx) {
                  final task = filteredTasks[idx];
                  final priColor = _getPriorityColor(task.priority);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.pureWhite,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                        width: 1.2,
                      ),
                      boxShadow: AppColors.softShadow(Colors.black, blur: 6, offset: const Offset(0, 2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: task.isCompleted,
                          activeColor: AppColors.emerald,
                          onChanged: (_) => dataService.toggleStudyTask(task.id),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                  color: task.isCompleted
                                      ? (isDark ? AppColors.darkTextSecondary : AppColors.secondaryText)
                                      : (isDark ? AppColors.darkTextPrimary : AppColors.charcoal),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                                    decoration: BoxDecoration(
                                      color: priColor.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      task.priority.toUpperCase(),
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: priColor),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    task.subject,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.grey),
                          onPressed: () => dataService.deleteStudyTask(task.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}


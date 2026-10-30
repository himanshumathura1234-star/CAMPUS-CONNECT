import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/campus_models.dart';
import '../../../services/campus_data_service.dart';

class QuestionCard extends StatelessWidget {
  final CampusQuestionModel question;
  final VoidCallback? onUpdate;

  const QuestionCard({
    super.key,
    required this.question,
    this.onUpdate,
  });

  void _showAnswers(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final answerCtrl = TextEditingController();
    bool isAnonymousReply = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.pureWhite,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: Column(
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
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.softLavender.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.softLavender),
                          ),
                          child: Text(
                            question.subject,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF5B41A8),
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (question.isResolved)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.emerald.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '✓ Resolved',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.emerald),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      question.title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.charcoal,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      question.content,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const Text(
                      'Answers & Insights',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: question.answers.isEmpty
                          ? Center(
                              child: Text(
                                'No answers yet. Be the first senior/peer to help!',
                                style: TextStyle(
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: question.answers.length,
                              itemBuilder: (ctx, idx) {
                                final ans = question.answers[idx];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: ans.isAccepted
                                        ? AppColors.emerald.withValues(alpha: 0.10)
                                        : (isDark ? AppColors.darkSurfaceElevated : AppColors.warmCream),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: ans.isAccepted
                                          ? AppColors.emerald
                                          : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                                      width: ans.isAccepted ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            ans.authorName,
                                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                                          ),
                                          const Spacer(),
                                          if (ans.isAccepted)
                                            const Text(
                                              'Best Answer ✓',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.emerald,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(ans.content, style: const TextStyle(fontSize: 13, height: 1.4)),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              CampusDataService().toggleUpvoteAnswer(question.id, ans.id);
                                              setSheetState(() {});
                                              onUpdate?.call();
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  ans.userUpvoted ? Icons.thumb_up_rounded : Icons.thumb_up_alt_outlined,
                                                  size: 14,
                                                  color: ans.userUpvoted ? AppColors.coral : Colors.grey,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${ans.upvotes}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color: ans.userUpvoted ? AppColors.coral : Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          if (!ans.isAccepted)
                                            TextButton(
                                              onPressed: () {
                                                CampusDataService().markBestAnswer(question.id, ans.id);
                                                setSheetState(() {});
                                                onUpdate?.call();
                                              },
                                              child: const Text('Mark Best', style: TextStyle(fontSize: 11, color: AppColors.coral, fontWeight: FontWeight.bold)),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: isAnonymousReply,
                          activeColor: AppColors.coral,
                          onChanged: (v) => setSheetState(() => isAnonymousReply = v ?? false),
                        ),
                        const Text('Reply anonymously', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: answerCtrl,
                            decoration: const InputDecoration(
                              hintText: 'Write your academic answer...',
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          style: IconButton.styleFrom(backgroundColor: AppColors.coral),
                          onPressed: () {
                            if (answerCtrl.text.trim().isNotEmpty) {
                              CampusDataService().addAnswer(
                                questionId: question.id,
                                content: answerCtrl.text.trim(),
                                isAnonymous: isAnonymousReply,
                              );
                              answerCtrl.clear();
                              setSheetState(() {});
                              onUpdate?.call();
                            }
                          },
                          icon: const Icon(Icons.send_rounded, size: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
          width: 1.2,
        ),
        boxShadow: AppColors.softShadow(Colors.black, blur: 8, offset: const Offset(0, 3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showAnswers(context),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: AppColors.softLavender.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.softLavender),
                      ),
                      child: Text(
                        question.subject,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF5B41A8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (question.isAnonymous)
                      Row(
                        children: [
                          Icon(Icons.shield_outlined, size: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText),
                          const SizedBox(width: 4),
                          Text(
                            'Anonymous',
                            style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText),
                          ),
                        ],
                      )
                    else
                      Text(
                        question.authorName,
                        style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText),
                      ),
                    const Spacer(),
                    Text(
                      question.timeAgo,
                      style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  question.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  question.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.secondaryText,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        CampusDataService().toggleUpvoteQuestion(question.id);
                        onUpdate?.call();
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: question.userUpvoted
                              ? AppColors.coral.withValues(alpha: 0.15)
                              : (isDark ? AppColors.darkSurfaceElevated : AppColors.warmCream),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: question.userUpvoted
                                ? AppColors.coral
                                : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              question.userUpvoted ? Icons.arrow_upward_rounded : Icons.arrow_upward_outlined,
                              size: 14,
                              color: question.userUpvoted ? AppColors.coral : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${question.upvotes}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: question.userUpvoted ? AppColors.coral : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        const Icon(Icons.mode_comment_outlined, size: 14, color: AppColors.secondaryText),
                        const SizedBox(width: 4),
                        Text(
                          '${question.answerCount} answers',
                          style: const TextStyle(fontSize: 11, color: AppColors.secondaryText, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (question.isResolved)
                      const Text(
                        'Solved ✓',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.emerald),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


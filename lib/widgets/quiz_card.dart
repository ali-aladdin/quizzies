import 'package:flutter/material.dart';

import '../models/quiz.dart';

class QuizCard extends StatelessWidget {
  const QuizCard({
    required this.quiz,
    required this.onTap,
    super.key,
  });

  final Quiz quiz;
  final VoidCallback onTap;

  static const _gradientPairs = [
    [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    [Color(0xFFDB2777), Color(0xFFF472B6)],
    [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
    [Color(0xFF10B981), Color(0xFF34D399)],
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = _gradientPairs[quiz.id.hashCode.abs() % _gradientPairs.length];
    final created = '${quiz.createdAt.month}/${quiz.createdAt.day}/${quiz.createdAt.year}';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: palette),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: palette.last.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  avatar: const Icon(Icons.quiz, size: 16),
                  label: Text('${quiz.questions.length} questions'),
                  backgroundColor: Colors.white.withOpacity(0.2),
                  labelStyle: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
                ),
                Text(
                  created,
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              quiz.title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              quiz.description,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.9)),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(Icons.person_outline, color: Colors.white70, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    quiz.createdBy,
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

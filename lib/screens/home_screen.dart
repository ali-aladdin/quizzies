import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/quiz.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/quiz_card.dart';
import 'sign_in_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final quizProvider = context.watch<QuizProvider>();
    final quizzes = quizProvider.quizzes;

    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Quizzies'),
        actions: [
          IconButton(
            tooltip: 'Create Quiz',
            onPressed: () => Navigator.pushNamed(context, '/create-quiz'),
            icon: const Icon(Icons.auto_awesome_outlined),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () {
              auth.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                SignInScreen.routeName,
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HomeHeader(
              username: auth.currentUser?.username ?? 'Quizzer',
              quizCount: quizzes.length,
              attempts: quizProvider.results.length,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: quizzes.isEmpty
                  ? _EmptyState(onCreateQuiz: () => Navigator.pushNamed(context, '/create-quiz'))
                  : _QuizGrid(
                      quizzes: quizzes,
                      onQuizTap: (quiz) {
                        Navigator.pushNamed(context, '/quiz', arguments: quiz.id);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizGrid extends StatelessWidget {
  const _QuizGrid({required this.quizzes, required this.onQuizTap});

  final List<Quiz> quizzes;
  final void Function(Quiz quiz) onQuizTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width >= 1100
        ? 3
        : width >= 750
            ? 2
            : 1;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: width >= 750 ? 4 / 3 : 4 / 2.8,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        final quiz = quizzes[index];
        return QuizCard(
          quiz: quiz,
          onTap: () => onQuizTap(quiz),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreateQuiz});

  final VoidCallback onCreateQuiz;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.lightbulb_outline, size: 42, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 18),
              Text(
                'No quizzes yet',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Create your first quiz to get started.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: onCreateQuiz,
                icon: const Icon(Icons.add),
                label: const Text('Create Quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.username,
    required this.quizCount,
    required this.attempts,
  });

  final String username;
  final int quizCount;
  final int attempts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $username 👋',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Sharpen your mind with fresh quizzes curated for curious people.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 520;
                return Flex(
                  direction: isWide ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment:
                      isWide ? CrossAxisAlignment.start : CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _StatChip(
                        icon: Icons.extension_outlined,
                        label: 'Quizzes available',
                        value: quizCount.toString(),
                      ),
                    ),
                    SizedBox(width: isWide ? 12 : 0, height: isWide ? 0 : 12),
                    Expanded(
                      child: _StatChip(
                        icon: Icons.emoji_events_outlined,
                        label: 'Attempts logged',
                        value: attempts.toString(),
                      ),
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  label,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

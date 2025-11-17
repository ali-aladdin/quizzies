import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/quiz.dart';
import '../models/quiz_result.dart';
import '../providers/quiz_provider.dart';
import '../widgets/answer_option_tile.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/question_result_tile.dart';
import 'home_screen.dart';

class SolveQuizArguments {
  SolveQuizArguments(this.quizId);

  final String quizId;
}

class SolveQuizScreen extends StatefulWidget {
  const SolveQuizScreen({super.key});

  static const routeName = '/quiz';

  @override
  State<SolveQuizScreen> createState() => _SolveQuizScreenState();
}

class _SolveQuizScreenState extends State<SolveQuizScreen> {
  final Map<String, int?> _selectedAnswers = {};

  void _onSelect(String questionId, int? choiceIndex) {
    setState(() => _selectedAnswers[questionId] = choiceIndex);
  }

  void _submitQuiz(Quiz quiz) {
    final quizProvider = context.read<QuizProvider>();
    final result = quizProvider.submitQuiz(
      quiz: quiz,
      selectedAnswers: _selectedAnswers,
    );
    Navigator.pushReplacementNamed(
      context,
      ResultScreen.routeName,
      arguments: ResultScreenArguments(quiz: quiz, result: result),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final quizId = args is String ? args : (args is SolveQuizArguments ? args.quizId : null);
    final quiz = context.select<QuizProvider, Quiz?>(
      (provider) => quizId != null ? provider.getQuizById(quizId) : null,
    );

    if (quiz == null) {
      return const Scaffold(
        body: Center(child: Text('Quiz not found.')),
      );
    }

    final answered = _selectedAnswers.values.whereType<int>().length;
    final progress = quiz.questions.isEmpty ? 0.0 : answered / quiz.questions.length;
    final theme = Theme.of(context);
    return GradientScaffold(
      appBar: AppBar(title: Text(quiz.title)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz.description,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Created by ${quiz.createdBy}',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(value: progress),
                    const SizedBox(height: 4),
                    Text('$answered of ${quiz.questions.length} answered'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: quiz.questions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final question = quiz.questions[index];
                  final selectedIndex = _selectedAnswers[question.id];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                                child: Text('${index + 1}', style: theme.textTheme.bodyMedium),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  question.text,
                                  style: theme.textTheme.titleMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...List.generate(question.choices.length, (choiceIndex) {
                            final choice = question.choices[choiceIndex];
                            return AnswerOptionTile(
                              value: choiceIndex,
                              groupValue: selectedIndex,
                              label: choice.text,
                              onChanged: (value) => _onSelect(question.id, value),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _submitQuiz(quiz),
                icon: const Icon(Icons.celebration_outlined),
                label: const Text('Submit Answers'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreenArguments {
  const ResultScreenArguments({required this.quiz, required this.result});

  final Quiz quiz;
  final QuizResult result;
}

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  static const routeName = '/quiz/result';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! ResultScreenArguments) {
      return const Scaffold(body: Center(child: Text('No results available.')));
    }

    final quiz = args.quiz;
    final result = args.result;

    final theme = Theme.of(context);
    return GradientScaffold(
      appBar: AppBar(title: const Text('Results')),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz.title,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You answered ${result.score} out of ${result.totalQuestions} correctly.',
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: result.totalQuestions == 0
                          ? 0
                          : result.score / result.totalQuestions,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: quiz.questions.length,
                itemBuilder: (context, index) {
                  final question = quiz.questions[index];
                  final selected = result.answers.firstWhere(
                    (answer) => answer.questionId == question.id,
                    orElse: () => QuizAnswer(questionId: question.id, selectedChoiceIndex: null),
                  );
                  return QuestionResultTile(
                    question: question,
                    selectedIndex: selected.selectedChoiceIndex,
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  HomeScreen.routeName,
                  (route) => false,
                ),
                icon: const Icon(Icons.home_outlined),
                label: const Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

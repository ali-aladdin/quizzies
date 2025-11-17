import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/quiz_provider.dart';
import 'screens/add_quiz_screen.dart';
import 'screens/home_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/solve_quiz_screen.dart';

void main() {
  runApp(const LovableQuizzesApp());
}

class LovableQuizzesApp extends StatelessWidget {
  const LovableQuizzesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child: Builder(
        builder: (context) {
          final colorScheme = ColorScheme.fromSeed(
            seedColor: const Color(0xFF7C3AED),
            brightness: Brightness.light,
          );
          final baseTheme = ThemeData(
            useMaterial3: true,
            colorScheme: colorScheme,
          );
          return MaterialApp(
            title: 'Lovable Quizzes',
            theme: baseTheme.copyWith(
              scaffoldBackgroundColor: const Color(0xFFF8FAFC),
              textTheme: baseTheme.textTheme.apply(
                bodyColor: const Color(0xFF111827),
                displayColor: const Color(0xFF0F172A),
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                foregroundColor: colorScheme.onSurface,
                centerTitle: true,
                titleTextStyle: baseTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              cardTheme: CardTheme(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
                color: Colors.white,
                surfaceTintColor: Colors.white,
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.indigo.shade100),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.indigo.shade100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colorScheme.primary, width: 1.8),
                ),
                labelStyle: TextStyle(color: Colors.indigo.shade600),
              ),
              filledButtonTheme: FilledButtonThemeData(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
              ),
              chipTheme: baseTheme.chipTheme.copyWith(
                backgroundColor: colorScheme.primaryContainer,
                selectedColor: colorScheme.primary,
                labelStyle: TextStyle(color: colorScheme.onPrimaryContainer),
              ),
            ),
            routes: {
              SignInScreen.routeName: (_) => const SignInScreen(),
              SignUpScreen.routeName: (_) => const SignUpScreen(),
              HomeScreen.routeName: (_) => const HomeScreen(),
              AddQuizScreen.routeName: (_) => const AddQuizScreen(),
              ResultScreen.routeName: (_) => const ResultScreen(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == SolveQuizScreen.routeName) {
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => const SolveQuizScreen(),
                );
              }
              return null;
            },
            home: const _RootRouter(),
          );
        },
      ),
    );
  }
}

class _RootRouter extends StatelessWidget {
  const _RootRouter();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isAuthenticated) {
          return const HomeScreen();
        }
        return const SignInScreen();
      },
    );
  }
}

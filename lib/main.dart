import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/method_select_screen.dart';
import 'screens/category_select_screen.dart';
import 'screens/category_detail_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/quiz_result_screen.dart';
import 'screens/daily_quiz_screen.dart';
import 'screens/random_word_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/set_selection_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/general_set_screen.dart';
import 'screens/reflex_quiz/reflex_quiz_screen.dart';
import 'screens/reflex_quiz/reflex_quiz_result.dart';
import 'screens/learning_methods/flashcards_screen.dart';
import 'screens/learning_methods/writing_practice_screen.dart';
import 'screens/learning_methods/listening_practice_screen.dart';
import 'screens/word_study/word_study_category_screen.dart';
import 'screens/word_study/word_study_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deutsch Trainer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6A11CB)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6A11CB), brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        '/methods': (context) => const MethodSelectScreen(),
        '/categories': (context) => const CategorySelectScreen(methodName: ''),
        DailyQuizScreen.routeName: (context) => const DailyQuizScreen(),
        RandomWordScreen.routeName: (context) => const RandomWordScreen(),
        StatsScreen.routeName: (context) => const StatsScreen(),
        SetSelectionScreen.routeName: (context) => const SetSelectionScreen(),
        SettingsScreen.routeName: (context) => const SettingsScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/categories':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            final method = args['method'] as String? ?? 'Reflex Quiz';
            return MaterialPageRoute(
              builder: (_) => CategorySelectScreen(methodName: method),
            );
          case '/category-detail':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            return MaterialPageRoute(
              builder: (_) => CategoryDetailScreen(
                categoryKey: args['categoryKey'] as String? ?? '',
                title: args['title'] as String? ?? '',
              ),
            );
          case '/general-set':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            return MaterialPageRoute(
              builder: (_) => GeneralSetScreen(
                setIndex: args['setIndex'] as int? ?? 1,
                title: args['title'] as String? ?? '',
              ),
            );
          case '/quiz-with-params':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            return MaterialPageRoute(
              builder: (_) => QuizScreen(
                title: args['title'] as String? ?? 'Quiz',
                jsonPath: args['jsonPath'] as String? ?? '',
              ),
            );
          case '/reflex-quiz':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            final categoryName = args['categoryName'] as String? ?? '';
            return MaterialPageRoute(
              builder: (_) => ReflexQuizScreen(categoryName: categoryName),
            );
          case '/reflex-quiz/result':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            return MaterialPageRoute(
              builder: (_) => ReflexQuizResultScreen(
                score: args['score'] as int? ?? 0,
                total: args['total'] as int? ?? 0,
                categoryName: args['categoryName'] as String? ?? '',
              ),
            );
          case '/flashcards':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            final categoryName = args['categoryName'] as String? ?? '';
            return MaterialPageRoute(
              builder: (_) => FlashcardsScreen(categoryName: categoryName),
            );
          case '/writing':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            final categoryName = args['categoryName'] as String? ?? '';
            return MaterialPageRoute(
              builder: (_) => WritingPracticeScreen(categoryName: categoryName),
            );
          case '/listening':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            final categoryName = args['categoryName'] as String? ?? '';
            return MaterialPageRoute(
              builder: (_) => ListeningPracticeScreen(categoryName: categoryName),
            );
          case '/word-study-categories':
            return MaterialPageRoute(
              builder: (_) => const WordStudyCategoryScreen(),
            );
          case '/word-study':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            return MaterialPageRoute(
              builder: (_) => WordStudyScreen(
                categoryKey: args['categoryKey'] as String? ?? '',
                title: args['title'] as String? ?? '',
              ),
            );
          default:
            return null;
        }
      },
    );
  }
}


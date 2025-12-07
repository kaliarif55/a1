import 'package:flutter/material.dart';
import '../widgets/menu_card.dart';
import 'set_selection_screen.dart';
import 'daily_quiz_screen.dart';
import 'random_word_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';
import 'package:almancaoyun/screens/method_select_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1C1F26),
              Color(0xFF2A2F3A),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    // App Title Section
                    const SizedBox(height: 20),
                    Text(
                      'Deutsch Trainer',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Almanca kelime öğrenme uygulaması',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Hero Illustration Placeholder
                    const SizedBox(height: 40),
                    Container(
                      height: 200,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.language,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Menu Grid Section
                    const SizedBox(height: 40),
                    GridView.count(
                      crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        MenuCard(
                          title: 'Learning Methods',
                          icon: Icons.school,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, MethodSelectScreen.routeName);
                          },
                        ),
                        MenuCard(
                          title: 'Daily Quiz',
                          icon: Icons.calendar_today,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, DailyQuizScreen.routeName);
                          },
                        ),
                        MenuCard(
                          title: 'Random Word',
                          icon: Icons.shuffle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9C27B0), Color(0xFFBA68C8)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, RandomWordScreen.routeName);
                          },
                        ),
                        MenuCard(
                          title: 'Statistics',
                          icon: Icons.bar_chart,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, StatsScreen.routeName);
                          },
                        ),
                      ],
                    ),

                    // Bottom spacing for better UX
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

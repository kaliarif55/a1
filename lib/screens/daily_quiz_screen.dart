import 'package:flutter/material.dart';

class DailyQuizScreen extends StatelessWidget {
  const DailyQuizScreen({super.key});

  static const routeName = '/daily-quiz';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Günlük Quiz'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: const Center(
        child: Text(
          'Günlük Quiz\n\nBurada günlük kelime testi yapılacak.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

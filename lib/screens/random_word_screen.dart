import 'package:flutter/material.dart';

class RandomWordScreen extends StatelessWidget {
  const RandomWordScreen({super.key});

  static const routeName = '/random-word';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rastgele Kelime'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: const Center(
        child: Text(
          'Rastgele Kelime\n\nBurada rastgele kelimeler gösterilecek.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

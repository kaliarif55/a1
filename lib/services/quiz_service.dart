import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../models/word.dart';
import '../models/question.dart';

class QuizService {
  Future<List<Word>> loadWords(String jsonPath) async {
    try {
      final jsonString = await rootBundle.loadString(jsonPath);
      final jsonData = json.decode(jsonString) as List<dynamic>;
      return jsonData.map((item) => Word.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to load words from $jsonPath: $e');
    }
  }

  List<Question> generateQuestions(List<Word> words) {
    if (words.length < 4) {
      throw Exception('Need at least 4 words to generate questions');
    }

    final questions = <Question>[];

    for (final correctWord in words) {
      // Get 3 wrong answers from other words in the list
      final wrongWords = words
          .where((word) => word != correctWord)
          .toList();

      // Shuffle to get random wrong answers
      wrongWords.shuffle();

      // Take first 3 wrong answers
      final selectedWrongWords = wrongWords.take(3).toList();

      // Create options list: correct answer + 3 wrong answers
      final options = [
        correctWord.tr, // correct answer
        ...selectedWrongWords.map((word) => word.tr), // wrong answers
      ];

      // Shuffle options
      options.shuffle();

      final question = Question(
        questionText: correctWord.de,
        correctAnswer: correctWord.tr,
        options: options,
      );

      questions.add(question);
    }

    // Shuffle questions for random order
    questions.shuffle();

    return questions;
  }

  Future<List<Question>> loadQuestions(String jsonPath) async {
    final words = await loadWords(jsonPath);
    return generateQuestions(words);
  }
}

import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/word_item.dart';

/// Utility for loading quiz data from bundled JSON files.
class JsonLoader {
  static const String _dataPrefix = 'assets/data/';

  /// Backwards compatible instance wrapper.
  Future<List<WordItem>> loadWords(String name) async {
    final items = await loadCategory(name);
    if (items.isEmpty) {
      throw Exception('Kategori "$name" için kelime bulunamadı. Path: $_dataPrefix$name.json');
    }
    final words = items.map((e) => WordItem(de: e['de'] ?? '', tr: e['tr'] ?? '')).toList();
    // Filter out any words with empty de or tr
    return words.where((w) => w.de.isNotEmpty && w.tr.isNotEmpty).toList();
  }

  /// Returns entries for a given category name.
  /// Each entry is expected to be a map with `de` and `tr` keys.
  static Future<List<Map<String, String>>> loadCategory(String name) async {
    try {
      final path = '$_dataPrefix$name.json';
      print('Loading category from path: $path');
      final jsonString = await rootBundle.loadString(path);
      final data = json.decode(jsonString);
      if (data is List) {
        final result = data
            .whereType<Map>()
            .map(
              (e) => e.map(
                (key, value) => MapEntry(
                  key.toString(),
                  value.toString(),
                ),
              ),
            )
            .toList();
        print('Loaded ${result.length} words from $name');
        return result;
      } else {
        print('Warning: Data from $path is not a List, it is ${data.runtimeType}');
      }
    } catch (e) {
      // Log error for debugging
      print('Error loading category $name from path $_dataPrefix$name.json: $e');
      // Return empty list but log the error
    }
    return [];
  }

  /// Lists all available category names.
  /// Currently uses hardcoded list, but can be extended to scan manifest.
  static Future<List<String>> listAllCategories() async {
    try {
      // Try to load from manifest first
      try {
        final manifestContent = await rootBundle.loadString('AssetManifest.json');
        final Map<String, dynamic> manifestMap = json.decode(manifestContent);
        final categoryFiles = manifestMap.keys.where(
          (key) => key.startsWith(_dataPrefix) && key.endsWith('.json'),
        );
        final names = categoryFiles
            .map((path) => path.replaceFirst(_dataPrefix, '').replaceAll('.json', ''))
            .toSet()
            .toList()
          ..sort();
        if (names.isNotEmpty) {
          return names;
        }
      } catch (_) {
        // Manifest reading failed, fall back to hardcoded list
      }

      // Fallback: Hardcoded list of available categories (Türkçe isimler)
      return [
        'aksesuar',
        'doktorda',
        'elektronik_mağaza',
        'general_set_1',
        'general_set_2',
        'general_set_3',
        'gün_ve_ay',
        'havalimanı',
        'hotel',
        'kitap_evi',
        'kıyafet_mağazası',
        'kozmetik',
        'kuaför',
        'market',
        'numbers',
        'önemli_fiiller',
        'otel',
        'otobüs_ulaşım',
        'police',
        'polis',
        'postane',
        'renk_ve_mevsim',
        'restaurant',
        'restoran',
        'sayılar',
        'seasons',
        'skiing',
        'spor',
        'sports',
        'supermarket',
        'taksi',
        'tiyatro',
        'traffic',
        'trafik_sinyali',
        'travel',
        'tren',
        'tur',
        'yolda',
      ];
    } catch (_) {
      // Final fallback
      return [
        'aksesuar',
        'doktorda',
        'elektronik_mağaza',
        'general_set_1',
        'general_set_2',
        'general_set_3',
        'gün_ve_ay',
        'havalimanı',
        'hotel',
        'kitap_evi',
        'kıyafet_mağazası',
        'kozmetik',
        'kuaför',
        'market',
        'numbers',
        'önemli_fiiller',
        'otel',
        'otobüs_ulaşım',
        'police',
        'polis',
        'postane',
        'renk_ve_mevsim',
        'restaurant',
        'restoran',
        'sayılar',
        'seasons',
        'skiing',
        'spor',
        'sports',
        'supermarket',
        'taksi',
        'tiyatro',
        'traffic',
        'trafik_sinyali',
        'travel',
        'tren',
        'tur',
        'yolda',
      ];
    }
  }
}

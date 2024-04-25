import 'dart:convert';

import 'package:helpa/src/features/summary/models/summary.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class SummariesDataProvider {
  Future<List<SummaryModel>> fetchSummaries();
  Future<void> deleteAllSummaries();
  Future<void> deleteSummary(SummaryModel summary);
  Future<void> saveSummary(SummaryModel summary);
  Future<void> editSummary(SummaryModel summary);
}

final class SummariesDataProvider$Storage implements SummariesDataProvider {
  SummariesDataProvider$Storage({
    required this.storage,
  });

  final SharedPreferences storage;
  final _summariesStorageKey = 'summaries';

  @override
  Future<List<SummaryModel>> fetchSummaries() async {
    final summariesJson = storage.getStringList(_summariesStorageKey) ?? [];
    final summaries = summariesJson
        .map(
          (summary) => SummaryModel.fromJson(
            jsonDecode(summary),
          ),
        )
        .toList();
    return summaries;
  }

  @override
  Future<void> deleteAllSummaries() async {
    await storage.remove(_summariesStorageKey);
  }

  @override
  Future<void> deleteSummary(SummaryModel summary) async {
    final summariesString = storage.getStringList(_summariesStorageKey) ?? [];
    final summaries = summariesString
        .map(
          (summaryJson) => SummaryModel.fromJson(jsonDecode(summaryJson)),
        )
        .toList();
    // Удаляем записи с этим id
    summaries.removeWhere((e) => e.id == summary.id);
    final summariesJson = summaries.map((e) => jsonEncode(e)).toList();
    await storage.setStringList(_summariesStorageKey, summariesJson);
  }

  @override
  Future<void> saveSummary(SummaryModel summary) async {
    final summaries = storage.getStringList(_summariesStorageKey) ?? [];
    summaries.add(jsonEncode(summary));
    await storage.setStringList(_summariesStorageKey, summaries);
  }

  @override
  Future<void> editSummary(SummaryModel summary) async {
    final summariesString = storage.getStringList(_summariesStorageKey) ?? [];
    final summaries = summariesString.map(
      (summaryJson) {
        final decodedSummary = SummaryModel.fromJson(jsonDecode(summaryJson));
        if (decodedSummary.id == summary.id) {
          // Editing
          return decodedSummary.copyWith(
            topic: summary.topic,
            text: summary.text,
          );
        } else {
          return decodedSummary;
        }
      },
    ).toList();
    final summariesJson = summaries.map((e) => jsonEncode(e)).toList();
    await storage.setStringList(_summariesStorageKey, summariesJson);
  }
}

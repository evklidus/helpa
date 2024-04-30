import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:helpa/src/common/widget/custom_text_field.dart';
import 'package:helpa/src/features/interview/widget/interview_screen.dart';
import 'package:helpa/src/features/summary/data/summaries_data_provider.dart';
import 'package:helpa/src/features/summary/models/summary.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template summary_screen}
/// SummaryScreen widget.
/// {@endtemplate}
class SummaryScreen extends StatefulWidget {
  /// {@macro summary_screen}
  const SummaryScreen({
    super.key,
    this.summary,
  });

  final SummaryModel? summary;

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

/// State for widget SummaryScreen.
class _SummaryScreenState extends State<SummaryScreen> {
  late final TextEditingController _topicController;
  late final TextEditingController _textController;

  bool _isSummaryChanged = false;

  final _maxSummaries = 10000;

  @override
  void initState() {
    super.initState();
    _topicController = TextEditingController(text: widget.summary?.topic);
    _textController = TextEditingController(text: widget.summary?.text);
  }

  Future<void> saveSummary(SummaryModel summary) async {
    final prefs = await SharedPreferences.getInstance();
    await SummariesDataProvider$Storage(storage: prefs).saveSummary(summary);
  }

  Future<void> editSummary(SummaryModel summary) async {
    final prefs = await SharedPreferences.getInstance();
    await SummariesDataProvider$Storage(storage: prefs).editSummary(summary);
  }

  Future<void> deleteSummary(SummaryModel summary) async {
    final prefs = await SharedPreferences.getInstance();
    await SummariesDataProvider$Storage(storage: prefs).deleteSummary(summary);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Конспект'),
        actions: [
          if (widget.summary != null)
            IconButton(
              tooltip: 'Начать собеседование',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => InterviewScreen(
                    summary: widget.summary!,
                  ),
                ),
              ),
              icon: const Icon(Icons.start_rounded),
            ),
          if (widget.summary != null)
            IconButton(
              tooltip: 'Удалить запись',
              onPressed: () {
                deleteSummary(widget.summary!);
                Navigator.of(context).pop();
                const snackBar = SnackBar(content: Text('Запись удалена'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              icon: const Icon(Icons.delete_forever_rounded),
            ),
          if (_isSummaryChanged)
            // TODO: Дублируется при нажатии сохранить более 1-го раза
            TextButton(
              onPressed: () {
                final summary = SummaryModel(
                  id: widget.summary?.id ?? Random().nextInt(_maxSummaries),
                  topic: _topicController.text.trim(),
                  text: _textController.text.trim(),
                );
                setState(() => _isSummaryChanged = false);
                if (widget.summary != null) {
                  editSummary(summary);
                } else {
                  saveSummary(summary);
                }
              },
              child: const Text('Сохранить'),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            CustomTextField(
              controller: _topicController,
              decoration: const InputDecoration.collapsed(hintText: 'Тема'),
              textInputAction: TextInputAction.done,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              onChanged: (val) {
                if (val != widget.summary?.topic) {
                  setState(() => _isSummaryChanged = true);
                }
              },
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _textController,
              decoration: const InputDecoration.collapsed(hintText: 'Текст'),
              onChanged: (val) {
                if (val != widget.summary?.text) {
                  setState(() => _isSummaryChanged = true);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

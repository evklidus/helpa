import 'package:flutter/material.dart';
import 'package:helpa/src/features/interview/widget/interview_screen.dart';
import 'package:helpa/src/features/summary/data/summaries_data_provider.dart';
import 'package:helpa/src/features/summary/models/summary.dart';
import 'package:helpa/src/features/home/widget/summary_widget.dart';
import 'package:helpa/src/features/summary/widget/summary_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template home_screen}
/// HomeScreen widget.
/// {@endtemplate}
class HomeScreen extends StatefulWidget {
  /// {@macro home_screen}
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// State for widget HomeScreen.
class _HomeScreenState extends State<HomeScreen> {
  late Future<List<SummaryModel>> _data;

  Future<List<SummaryModel>> fetchSummaries() async {
    final prefs = await SharedPreferences.getInstance();
    final summaries =
        await SummariesDataProvider$Storage(storage: prefs).fetchSummaries();
    return summaries;
  }

  Future<void> deleteAllSummaries() async {
    final prefs = await SharedPreferences.getInstance();
    await SummariesDataProvider$Storage(storage: prefs).deleteAllSummaries();
    _data = Future.value([]);
    setState(() {});
  }

  Future<void> _onRefresh() async {
    _data = fetchSummaries();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _data = fetchSummaries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Helpa'),
        actions: [
          IconButton(
            tooltip: 'Новый конспект',
            onPressed: () => Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) => const SummaryScreen(),
                  ),
                )
                .then((_) => _onRefresh()),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            tooltip: 'Начать собеседование',
            onPressed: () => Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) => const InterviewScreen(),
                  ),
                )
                .then((_) => _onRefresh()),
            icon: const Icon(Icons.start_rounded),
          ),
          IconButton(
            tooltip: 'Удалить все записи',
            onPressed: () => deleteAllSummaries(),
            icon: const Icon(Icons.delete_forever_rounded),
          ),
        ],
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: _onRefresh,
        child: FutureBuilder<List<SummaryModel>>(
          future: _data,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            final data = snapshot.data;
            if (data?.isEmpty ?? true) {
              return const Center(
                child: Text('Нет записей'),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: data!.length,
              itemBuilder: (context, index) => SummaryWidget(
                summary: data[index],
                onRefresh: _onRefresh,
              ),
              separatorBuilder: (context, index) => const SizedBox(
                height: 12,
              ),
            );
          },
        ),
      ),
    );
  }
}

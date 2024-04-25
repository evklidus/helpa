import 'package:flutter/material.dart';
import 'package:helpa/src/features/summary/models/summary.dart';
import 'package:helpa/src/features/summary/widget/summary_screen.dart';

/// {@template summary_widget}
/// SummaryWidget widget.
/// {@endtemplate}
class SummaryWidget extends StatelessWidget {
  /// {@macro summary_widget}
  const SummaryWidget({
    super.key,
    required this.summary,
    this.onRefresh,
  });

  final SummaryModel summary;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SummaryScreen(
              summary: summary,
            ),
          ),
        ).then((value) => onRefresh?.call()),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.black12,
          ),
          child: Text(summary.topic),
        ),
      );
}

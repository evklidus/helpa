import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AnimatedPersonWidget extends StatefulWidget {
  const AnimatedPersonWidget({
    super.key,
    this.onQuestionStart,
    required this.flutterTts,
    required this.quastion,
  });

  final Future Function()? onQuestionStart;
  final FlutterTts flutterTts;
  final String quastion;

  @override
  _AnimatedPersonWidgetState createState() => _AnimatedPersonWidgetState();
}

class _AnimatedPersonWidgetState extends State<AnimatedPersonWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  final List<String> _currentWords = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1, milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0.75, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    widget.flutterTts.setCompletionHandler(() => _controller.stop());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startSpeechAnimation() {
    _currentWords.clear();
    _controller.repeat(reverse: true);
    widget.onQuestionStart?.call();
  }

  @override
  Widget build(BuildContext context) {
    final isCupertino = Platform.isIOS || Platform.isMacOS;
    final width = MediaQuery.sizeOf(context).width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              child: Icon(
                isCupertino ? CupertinoIcons.person : Icons.person,
                size: width / 8,
                color: Colors.blue,
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: startSpeechAnimation,
          child: const Text('Озвучить вопрос'),
        ),
        const SizedBox(height: 20),
        StatefulBuilder(
          builder: (context, setState) {
            if (widget.flutterTts.progressHandler == null) {
              widget.flutterTts.setProgressHandler(
                (String text, int startOffset, int endOffset, String word) =>
                    setState(
                  () => _currentWords.add(word),
                ),
              );
            }
            return Text(_currentWords.join(' '));
          },
        ),
      ],
    );
  }
}

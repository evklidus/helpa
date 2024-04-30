import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AnimatedPersonWidget extends StatefulWidget {
  const AnimatedPersonWidget({
    super.key,
    this.onQuestionStart,
    required this.flutterTts,
  });

  final Future Function()? onQuestionStart;
  final FlutterTts flutterTts;

  @override
  State<AnimatedPersonWidget> createState() => _AnimatedPersonWidgetState();
}

class _AnimatedPersonWidgetState extends State<AnimatedPersonWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  final List<String> _currentWords = [];

  String get _text => _currentWords.join(' ');

  final answerTextStyle = const TextStyle(
    color: Colors.blueAccent,
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );

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

    widget.flutterTts.setProgressHandler(
      (String text, int startOffset, int endOffset, String word) => setState(
        () => _currentWords.add(word),
      ),
    );
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
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value,
                child: Icon(
                  isCupertino ? CupertinoIcons.person : Icons.person,
                  size: shortestSide / 6,
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
          SizedBox(
            width: shortestSide,
            child: AnimatedCrossFade(
              crossFadeState: _text.isNotEmpty
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 150),
              firstChild: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Ответьте на следующую тему: ',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: _text,
                      style: answerTextStyle,
                    ),
                  ],
                ),
              ),
              secondChild: Center(
                child: Text(
                  '...',
                  style: answerTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AnimatedPersonWidget extends StatefulWidget {
  const AnimatedPersonWidget({
    super.key,
    this.onQuastionStart,
  });

  final VoidCallback? onQuastionStart;

  @override
  _AnimatedPersonWidgetState createState() => _AnimatedPersonWidgetState();
}

class _AnimatedPersonWidgetState extends State<AnimatedPersonWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startSpeechAnimation() {
    // TODO: Остановить, когда зачитыватся текст
    _controller.repeat(reverse: true);
    widget.onQuastionStart?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              child: const Icon(
                Icons.person,
                size: 100,
                color: Colors.blue,
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: startSpeechAnimation,
          child: const Text('Воспроизвести речь'),
        ),
      ],
    );
  }
}

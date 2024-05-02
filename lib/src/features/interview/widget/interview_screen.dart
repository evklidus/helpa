import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:helpa/src/common/utils/text_comparator.dart';
import 'package:helpa/src/common/widget/custom_text_field.dart';
import 'package:helpa/src/features/interview/widget/animated_person_widget.dart';
import 'package:helpa/src/features/summary/models/summary.dart';

/// {@template interview_screen}
/// InterviewScreen widget.
/// {@endtemplate}
class InterviewScreen extends StatefulWidget {
  /// {@macro interview_screen}
  const InterviewScreen({
    super.key,
    required this.summary,
  });

  final SummaryModel summary;

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

/// State for widget InterviewScreen.
class _InterviewScreenState extends State<InterviewScreen> {
  CameraController? _cameraController;
  late final TextEditingController _answerController;
  late final List<CameraDescription> _cameras;
  late final FlutterTts _flutterTts;
  (bool, double)? _compareResult;

  Future<void> loadCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.max);
    _cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError(
      (Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              // Handle access errors here.
              break;
            default:
              // Handle other errors here.
              break;
          }
        }
      },
    ).ignore();
  }

  Future<void> _speak() => _flutterTts.speak(widget.summary.topic);

  Future<void> _stop() => _flutterTts.stop();

  Future<void> onQuastionStart() async {
    await _speak();
  }

  @override
  void initState() {
    super.initState();
    loadCamera();
    _flutterTts = FlutterTts();
    _answerController = TextEditingController();
  }

  @override
  void dispose() {
    _stop();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedPersonWidget(
              onQuestionStart: onQuastionStart,
              flutterTts: _flutterTts,
            ),
            const SizedBox(height: 32),
            if (_cameraController?.value.isInitialized ?? false) ...[
              const SizedBox(height: 32),
              CameraPreview(_cameraController!),
            ],
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width / 6,
              ),
              child: CustomTextField(
                controller: _answerController,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _compareResult = TextComparator().compare(
                  widget.summary.text,
                  _answerController.text,
                );
                setState(() {});
              },
              child: const Text('Проверить'),
            ),
            if (_compareResult != null) ...[
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    _compareResult!.$1.toString(),
                    style: TextStyle(
                      color: _compareResult!.$1 ? Colors.green : Colors.red,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Схожесть ${_compareResult!.$2.toInt()}%',
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}

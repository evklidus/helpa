import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
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
  late List<CameraDescription> _cameras;
  late final FlutterTts _flutterTts;

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
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedPersonWidget(
              onQuestionStart: onQuastionStart,
              flutterTts: _flutterTts,
            ),
            if (_cameraController?.value.isInitialized ?? false)
              CameraPreview(_cameraController!)
          ],
        ),
      ),
    );
  }
}

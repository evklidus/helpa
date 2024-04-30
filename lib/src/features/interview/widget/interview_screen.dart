import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:helpa/src/features/interview/widget/animated_person_widget.dart';

/// {@template interview_screen}
/// InterviewScreen widget.
/// {@endtemplate}
class InterviewScreen extends StatefulWidget {
  /// {@macro interview_screen}
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

/// State for widget InterviewScreen.
class _InterviewScreenState extends State<InterviewScreen> {
  CameraController? _cameraController;
  late List<CameraDescription> _cameras;

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
    );
  }

  @override
  void initState() {
    super.initState();
    loadCamera();
  }

  onQuastionStart() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedPersonWidget(
              onQuastionStart: onQuastionStart,
            ),
            if (_cameraController?.value.isInitialized ?? false)
              CameraPreview(_cameraController!)
          ],
        ),
      ),
    );
  }
}

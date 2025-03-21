import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class FaceRecognitionScreen extends StatefulWidget {
  final CameraController cameraController;

  FaceRecognitionScreen(this.cameraController);

  @override
  _FaceRecognitionScreenState createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  bool faceDetected = false;

  @override
  void initState() {
    super.initState();
    _startFaceDetection();
  }

  void _startFaceDetection() async {
    await Future.delayed(Duration(seconds: 3)); // Simulating Face Detection

    setState(() {
      faceDetected = true;
    });

    await Future.delayed(Duration(seconds: 1)); // Wait 1 second before closing
    Navigator.pop(context, faceDetected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(widget.cameraController),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: faceDetected
                  ? Text("Face Detected!", style: TextStyle(color: Colors.green, fontSize: 20))
                  : Text("Detecting Face...", style: TextStyle(color: Colors.red, fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.cameraController.dispose(); // Dispose camera when exiting
    super.dispose();
  }
}

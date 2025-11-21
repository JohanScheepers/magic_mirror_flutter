import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class CameraService {
  static CameraService? _instance;
  static int _referenceCount = 0;

  CameraController? _controller;
  bool _isInitialized = false;

  // Private constructor
  CameraService._();

  // Singleton accessor
  static CameraService get instance {
    _instance ??= CameraService._();
    return _instance!;
  }

  CameraController? get controller => _controller;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    _referenceCount++;

    // If already initialized, just return
    if (_isInitialized && _controller != null) {
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      // Use front camera (index 1) if available, otherwise use first camera
      final camera = cameras.length > 1 ? cameras[1] : cameras[0];

      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  void dispose() {
    _referenceCount--;

    // Only dispose if no more references
    if (_referenceCount <= 0) {
      _controller?.dispose();
      _controller = null;
      _isInitialized = false;
      _referenceCount = 0;
    }
  }
}

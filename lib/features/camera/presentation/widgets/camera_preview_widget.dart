import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../data/camera_service.dart';

class CameraPreviewWidget extends StatefulWidget {
  const CameraPreviewWidget({super.key});

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  late final CameraService _cameraService;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _cameraService = CameraService.instance;
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    await _cameraService.initialize();
    if (mounted) {
      setState(() {
        _isInitialized = _cameraService.isInitialized;
      });
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized ||
        _cameraService.controller == null ||
        !_cameraService.controller!.value.isInitialized) {
      return Container(color: Colors.black);
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _cameraService.controller!.value.previewSize!.height,
          height: _cameraService.controller!.value.previewSize!.width,
          child: CameraPreview(_cameraService.controller!),
        ),
      ),
    );
  }
}

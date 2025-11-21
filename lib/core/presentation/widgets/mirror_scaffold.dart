import 'package:flutter/material.dart';
import '../../../features/camera/presentation/widgets/camera_preview_widget.dart';

class MirrorScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  const MirrorScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background: Camera Preview (Full Screen)
        const Positioned.fill(child: CameraPreviewWidget()),

        // Foreground: The actual page content
        Scaffold(
          backgroundColor: Colors.transparent, // Make scaffold transparent
          appBar: appBar,
          body: body,
          floatingActionButton: floatingActionButton,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class FullScreenImagePage extends StatefulWidget {
  final String imageUrl;

  const FullScreenImagePage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  _FullScreenImagePageState createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  double _scale = 1.0; // Default scale is 1 (100%)
  final double _zoomInScale = 1.5; // Scale factor for zooming in (50%)
  final double _zoomOutScale = 1.0; // Default scale (100%)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,  // Remove the app bar shadow for a cleaner look
      ),
      body: GestureDetector(
        onTap: () {
          // Close the page when the user taps anywhere
          Navigator.of(context).pop();
        },
        onDoubleTap: () {
          // Toggle between zoom in (50%) and reset (100%) on double tap
          setState(() {
            if (_scale == _zoomOutScale) {
              _scale = _zoomInScale; // Zoom in by 50%
            } else {
              _scale = _zoomOutScale; // Reset to 100%
            }
          });
        },
        child: Center(
          child: InteractiveViewer(
            panEnabled: true, // Enable dragging
            boundaryMargin: EdgeInsets.all(20),
            minScale: 0.1,
            maxScale: 4.0,
            scaleEnabled: true,
            child: Transform.scale(
              scale: _scale, // Apply dynamic scale
              child: Container(
                alignment: Alignment.center,
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.contain, // Ensures the image fits within the screen
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

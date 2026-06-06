import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ShimmerLoader extends StatelessWidget {
  final double height;
  final double width;

  const ShimmerLoader({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
    )
    .animate(onPlay: (controller) => controller.repeat())
    .shimmer(duration: 1500.ms, color: Colors.grey[100]);
  }
}

import 'package:flutter/material.dart';
import 'package:milestoneone/view/global/colors.dart';

class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  GradientIcon({super.key, required this.icon, this.size});

  final Color gradientStart = AppColors.accent1.withOpacity(0.8);
  final Color gradientEnd = AppColors.accent2.withOpacity(0.8);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        colors: [gradientStart, gradientEnd],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds),
      child: Icon(
        icon,
        size: size,
      ),
    );
  }
}

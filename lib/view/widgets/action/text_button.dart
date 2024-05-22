import 'package:flutter/material.dart';
import 'package:milestoneone/view/global/colors.dart';

class AppTextButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const AppTextButton({super.key, required this.text, this.onPressed});

  final Color _gradientStart = AppColors.accent1;
  final Color _gradientEnd = AppColors.accent2;

  @override
  Widget build(BuildContext context) {
    // Text button with gradient text
    return TextButton(
      onPressed: onPressed,
      child: ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => LinearGradient(
          colors: [_gradientStart, _gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0, 0.7],
        ).createShader(bounds),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

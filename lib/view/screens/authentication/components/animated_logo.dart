import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Animate(
      onComplete: (AnimationController controller) {
        controller.repeat(reverse: true);
      },
      effects: [
        ShimmerEffect(
          duration: 2.seconds,
          curve: Curves.easeOutExpo,
          delay: 800.ms,
        )
      ],
      child: Animate(
        effects: [
          SlideEffect(
            delay: 1.seconds,
            duration: 2.seconds,
            curve: Curves.easeOutExpo,
          ),
          FadeEffect(
            delay: 1.seconds,
            duration: 2.seconds,
            curve: Curves.easeOutExpo,
          ),
        ],
        child: Image.asset(
          'assets/logo_image.png',
          height: 100.h,
        ),
      ),
    );
  }
}

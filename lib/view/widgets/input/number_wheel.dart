import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wheel_slider/wheel_slider.dart';

import '../../global/colors.dart';
import '../../global/text_styles.dart';

class NumberWheel extends StatefulWidget {
  final int range;
  final int initialNumber;
  final int currentIndex;
  final void Function(dynamic) onNumberChanged;
  const NumberWheel({super.key, required this.range, required this.initialNumber, required this.currentIndex, required this.onNumberChanged});

  @override
  State<NumberWheel> createState() => _NumberWheelState();
}

class _NumberWheelState extends State<NumberWheel> {
  @override
  Widget build(BuildContext context) {
    return WheelSlider.number(
      totalCount: widget.range,
      initValue: widget.initialNumber,
      onValueChanged: widget.onNumberChanged,
      currentIndex: widget.currentIndex,
      perspective: 0.004,
      unSelectedNumberStyle: TextStyles.smallBodyThin,
      selectedNumberStyle: TextStyles.smallBody.apply(color: AppColors.accent1),
      isVibrate: false,
      showPointer: true,
      customPointer: Padding(
        padding: EdgeInsets.only(top: 25.r),
        child: Icon(Icons.arrow_drop_up_rounded, color: AppColors.accent1, size: 20.r),
      ),
    );
  }
}

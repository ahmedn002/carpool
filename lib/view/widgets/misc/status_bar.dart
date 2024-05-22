import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:milestoneone/view/global/colors.dart';
import 'package:milestoneone/view/global/text_styles.dart';
import 'package:milestoneone/view/utilities/extensions.dart';

class ProgressBar extends StatefulWidget {
  final List<String> bubbleNames;
  final int selectedIndex;
  final double? width;

  ProgressBar({super.key, required this.bubbleNames, required this.selectedIndex, this.width});

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  final Duration _animationDuration = const Duration(milliseconds: 750);
  late final double _visibleProgressBarWidth;
  final double _smallBarHeight = 12.h;
  final double _bigBarHeight = 12.h;
  final double _bubbleRadius = 17.r;
  late final double _edgeOffset;
  late final double _bubbleMargin;
  late final double _calculatedBarLength;

  @override
  void initState() {
    _visibleProgressBarWidth = widget.width ?? 0.7.sw;
    _edgeOffset = widget.bubbleNames.length < 5 ? 45.w : 20.w;

    final int divisor = widget.bubbleNames.length <= 5 ? widget.bubbleNames.length : 5;
    final double freeSpace = _visibleProgressBarWidth - 2 * _edgeOffset - _bubbleRadius * 2;
    _bubbleMargin = (freeSpace - 2 * _bubbleRadius * (divisor - 1)) / (divisor - 1);
    _calculatedBarLength = 2 * _edgeOffset + (widget.bubbleNames.length - 1) * (_bubbleRadius * 2 + _bubbleMargin) + _bubbleRadius * 2;
    print('$_calculatedBarLength // $_visibleProgressBarWidth');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double greenBarProgressWidth = _edgeOffset + (widget.selectedIndex + 1) * (_bubbleRadius * 2 + _bubbleMargin) - _bubbleMargin / 2;
    if (widget.selectedIndex == widget.bubbleNames.length - 1) greenBarProgressWidth = _calculatedBarLength;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: _calculatedBarLength,
        height: _bubbleRadius * 3,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              top: _bubbleRadius - _smallBarHeight / 2,
              child: Container(
                width: _calculatedBarLength,
                height: _smallBarHeight,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100.sp), color: AppColors.grey),
              ),
            ),
            ...widget.bubbleNames.mapIndexed((index, name) {
              final double leftOffset = _edgeOffset + index * (_bubbleRadius * 2 + _bubbleMargin);
              final bool isLast = index == widget.bubbleNames.length - 1;
              final bool isPassed = index <= widget.selectedIndex;

              if (!isPassed) {
                return Positioned(
                  left: leftOffset,
                  child: Padding(
                    padding: EdgeInsets.only(right: isLast ? 0 : _bubbleMargin),
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: _bubbleRadius,
                          backgroundColor: isPassed ? AppColors.accent1 : AppColors.grey,
                        ),
                        Positioned(
                          top: 38.h,
                          child: AnimatedDefaultTextStyle(
                            duration: _animationDuration,
                            curve: Curves.easeOutExpo,
                            style: TextStyles.smallBodyThin.apply(
                              color: isPassed ? AppColors.text : AppColors.secondaryText,
                              fontWeightDelta: isPassed ? 2 : 0,
                              fontSizeFactor: 0.7,
                            ),
                            child: Text(widget.bubbleNames[index].capitalize, textAlign: TextAlign.center),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox();
            }),
            SizedBox(
              width: greenBarProgressWidth,
              height: _bubbleRadius * 3,
              child: ShaderMask(
                blendMode: BlendMode.srcATop,
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [AppColors.accent1, AppColors.accent2],
                  ).createShader(rect);
                },
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: _bubbleRadius - _smallBarHeight / 2,
                      child: Container(
                        width: greenBarProgressWidth,
                        height: _smallBarHeight,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100.sp), color: AppColors.grey),
                      ),
                    ),
                    ...widget.bubbleNames.mapIndexed((index, name) {
                      final double leftOffset = _edgeOffset + index * (_bubbleRadius * 2 + _bubbleMargin);
                      final bool isLast = index == widget.bubbleNames.length - 1;
                      final bool isPassed = index <= widget.selectedIndex;
                      final bool isSelected = index == widget.selectedIndex;

                      return Positioned(
                        left: leftOffset,
                        child: Padding(
                          padding: EdgeInsets.only(right: isLast ? 0 : _bubbleMargin),
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                radius: _bubbleRadius,
                                backgroundColor: isPassed ? AppColors.accent1 : AppColors.grey,
                              ),
                              Positioned(
                                top: 38.h,
                                child: AnimatedDefaultTextStyle(
                                  duration: _animationDuration,
                                  curve: Curves.easeOutExpo,
                                  style: TextStyles.smallBodyThin.apply(
                                    color: isPassed ? AppColors.text : AppColors.secondaryText,
                                    fontWeightDelta: isPassed ? 2 : 0,
                                    fontSizeFactor: 0.7,
                                  ),
                                  child: Text(widget.bubbleNames[index].capitalize, textAlign: TextAlign.center),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

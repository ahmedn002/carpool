import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../global/colors.dart';

class CustomExpansionTile extends StatefulWidget {
  final Widget upper;
  final Widget? lower;
  final Widget expanded;
  const CustomExpansionTile({super.key, required this.upper, this.lower, required this.expanded});

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _tileController;
  late final AnimationController _expansionController;
  late Animation<double> _animation;

  late Widget _expandedWidget;
  bool _shouldAnimate = false;
  bool _tapEnabled = true;
  @override
  void initState() {
    _tileController = AnimationController(vsync: this, duration: const Duration(milliseconds: 750));
    _animation = CurvedAnimation(parent: _tileController, curve: Curves.easeOutExpo);
    _expandedWidget = const SizedBox.shrink();
    super.initState();
  }

  @override
  void dispose() {
    _tileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_expanded && _shouldAnimate) {
      _shouldAnimate = false;
      Future.delayed(750.ms, () {
        setState(() => _tapEnabled = true);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _expandedWidget = widget.expanded);
      });
    } else if (!_expanded && _shouldAnimate) {
      _shouldAnimate = false;
      // Future.delayed(const Duration(milliseconds: 750), () {
      //   _tileController.forward();
      // });
      Future.delayed(750.ms, () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _expandedWidget = const SizedBox.shrink();
            _tapEnabled = true;
          });
        });
      });
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.r),
      ),
      child: Material(
        color: AppColors.elevationOne,
        child: InkWell(
          splashColor: AppColors.secondaryText.withOpacity(0.1),
          onTap: _tapEnabled
              ? () {
                  _shouldAnimate = true;
                  _tapEnabled = false;
                  if (_expanded) {
                    _animation = CurvedAnimation(parent: _tileController, curve: Curves.easeInExpo);
                    _tileController.reverse();
                    _expansionController.reverse();
                  } else {
                    _animation = CurvedAnimation(parent: _tileController, curve: Curves.easeOutExpo);
                    _tileController.forward();
                    _expansionController.forward();
                  }
                  setState(() => _expanded = !_expanded);
                }
              : null,
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: widget.upper),
                          5.horizontalSpace,
                          AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) => Transform.rotate(
                              angle: _animation.value * 3.14,
                              child: CircleAvatar(
                                radius: 15.r,
                                backgroundColor: AppColors.background,
                                child: Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: AppColors.secondaryText,
                                  size: 30.r,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      AnimatedSize(
                        duration: 750.ms,
                        curve: Curves.easeOutExpo,
                        child: _expandedWidget
                            .animate(
                              onInit: (controller) {
                                _expansionController = controller;
                              },
                              autoPlay: false,
                            )
                            .then(delay: 750.ms, duration: 750.ms, curve: Curves.easeOutExpo)
                            .scale(duration: 750.ms, curve: Curves.easeOutExpo)
                            .fade(duration: 750.ms, curve: Curves.easeOutExpo),
                      ),
                      if (widget.lower != null) widget.lower!,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

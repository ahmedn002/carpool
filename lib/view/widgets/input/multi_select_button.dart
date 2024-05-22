// Segmented control for selecting multiple options

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:milestoneone/view/global/colors.dart';

class MultiSelectButton extends StatefulWidget {
  final List<MultiSelectItem> items;
  final void Function(MultiSelectItem?)? onChanged;
  final int initialIndex;
  final double scale;
  final bool emptySelectionAllowed;
  const MultiSelectButton({super.key, required this.items, this.onChanged, this.scale = 1, this.initialIndex = 0, this.emptySelectionAllowed = false});

  @override
  State<MultiSelectButton> createState() => _MultiSelectButtonState();
}

class _MultiSelectButtonState extends State<MultiSelectButton> {
  late Set<MultiSelectItem> _selectedItem;

  @override
  void initState() {
    if (widget.initialIndex >= 0 && widget.initialIndex < widget.items.length) {
      _selectedItem = {widget.items[widget.initialIndex]};
    } else {
      _selectedItem = {};
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      width: 1.sw - 40.w,
      child: SegmentedButton<MultiSelectItem>(
        segments: widget.items
            .map(
              (item) => ButtonSegment<MultiSelectItem>(
                value: item,
                icon: item.icon,
                label: Text(item.title, style: TextStyle(fontSize: 16.sp * widget.scale)),
              ),
            )
            .toList(),
        selected: _selectedItem,
        multiSelectionEnabled: false,
        onSelectionChanged: (item) {
          setState(() {
            _selectedItem = item;
          });
          if (item.isEmpty) {
            widget.onChanged?.call(null);
            return;
          }
          widget.onChanged?.call(item.first);
        },
        emptySelectionAllowed: widget.emptySelectionAllowed,
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return AppColors.accent1;
            }
            return AppColors.secondaryText;
          }),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return AppColors.accent1.withOpacity(0.1);
            }
            return Colors.transparent;
          }),
        ),
      ),
    );
  }
}

class MultiSelectItem {
  final String title;
  final Widget icon;

  const MultiSelectItem({
    required this.title,
    required this.icon,
  });
}

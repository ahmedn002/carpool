import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:milestoneone/view/global/colors.dart';
import 'package:milestoneone/view/global/text_styles.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final void Function()? onEditingComplete;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? suffix;
  final Widget? prefixIcon;
  final bool enabled;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.suffix,
    this.prefixIcon,
    this.enabled = true,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  // Always show suffix text even if not focused

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      controller: widget.controller,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      obscureText: widget.obscureText!,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      style: TextStyles.body,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 10.w,
          // vertical: 15.h,
        ),
        filled: true,
        hintText: widget.hintText,
        hintStyle: TextStyles.body.apply(color: AppColors.secondaryText),
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 15.w),
          child: widget.suffix,
        ),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),
        prefixIcon: widget.prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.r),
          borderSide: BorderSide.none,
        ),
        fillColor: AppColors.elevationOne,
      ),
    );
  }
}

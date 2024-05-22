import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:milestoneone/view/global/colors.dart';

class ImageInput extends StatefulWidget {
  final double radius;
  final void Function(File)? onImageSelected;
  const ImageInput({super.key, required this.radius, this.onImageSelected});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppColors.elevationOne,
      radius: widget.radius + 2.r,
      child: GestureDetector(
        onTap: () async {
          final ImagePicker picker = ImagePicker();
          final XFile? image = await picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            setState(() => _image = File(image.path));
            widget.onImageSelected?.call(_image!);
          }
        },
        child: Container(
          height: widget.radius * 2,
          width: widget.radius * 2,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(200.r),
          ),
          child: _image == null ? Icon(Icons.camera_alt, color: AppColors.secondaryText.withOpacity(0.5), size: widget.radius) : Image.file(_image!, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

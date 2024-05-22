import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../global/colors.dart';

class GradientAvatar extends StatelessWidget {
  final double radius;
  final String imageUrl;
  const GradientAvatar({super.key, required this.radius, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(200.r), gradient: const LinearGradient(colors: [AppColors.accent1, AppColors.accent2])),
      child: Center(
        child: CircleAvatar(
          radius: radius - 2.r,
          backgroundColor: AppColors.elevationOne,
          backgroundImage: CachedNetworkImageProvider(imageUrl),
        ),
      ),
    );
  }
}

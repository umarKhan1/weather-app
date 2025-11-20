import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weatherapp/core/extensions/spacing_extensions.dart';

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: cs.surfaceContainerHigh.withAlpha(120),
      highlightColor: cs.surfaceContainerHigh.withAlpha(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _roundedBlock(height: 200.h),
          24.vGap,
          _textLine(width: 80.w),
          12.vGap,
          for (int i = 0; i < 2; i++) ...[
            _roundedBlock(height: 140.h),
            16.vGap,
          ],
        ],
      ),
    );
  }

  Widget _roundedBlock({required double height}) => Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28.r),
        ),
      );

  Widget _textLine({required double width}) => Container(
        height: 18.h,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
        ),
      );
}

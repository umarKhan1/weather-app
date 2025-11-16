import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weatherapp/core/extensions/spacing_extensions.dart';

class Metric extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isRequired;
  const Metric({super.key, required this.label, required this.icon, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return  Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        isRequired? Icon(icon, size: 16.sp, color: cs.onPrimary):SizedBox(),
        4.hGap,
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: cs.onPrimary,
                fontWeight: isRequired? FontWeight.w900 : FontWeight.normal,
                fontSize: isRequired? (Theme.of(context).textTheme.labelMedium?.fontSize ?? 12).sp : 20.sp,
              ),
        ),
      ],
    );
  }
}

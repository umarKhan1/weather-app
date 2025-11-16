import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weatherapp/features/dashboard/domain/entities/news_item.dart';

class NewsCard extends StatelessWidget {
  final NewsItem item;
  const NewsCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withAlpha(10),
            blurRadius: 16.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            child: SizedBox(
              height: 120.h,
              child: DecoratedBox(
                decoration: const BoxDecoration(color: Colors.black),
                child: Center(
                  child: Image.asset(
                    item.imagePath,
                    fit: BoxFit.cover,
                    width: 200.w,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
            child: Text(
              item.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: Theme.of(context).textTheme.titleMedium?.fontSize?.sp,
                  ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
            child: Row(
              children: [
                Text(
                  _formatTime(item.publishedAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.outline.withAlpha(160),
                        fontSize: Theme.of(context).textTheme.bodySmall?.fontSize?.sp,
                      ),
                ),
                const Spacer(),
                Text(
                  item.source,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.outline.withAlpha(160),
                        fontSize: Theme.of(context).textTheme.bodySmall?.fontSize?.sp,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} minutes ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:weatherapp/core/di/service_locator.dart';
import 'package:weatherapp/core/extensions/spacing_extensions.dart';
import 'package:weatherapp/features/locations/presentation/cubit/location_search_cubit.dart';
import 'package:weatherapp/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:weatherapp/features/locations/presentation/cubit/saved_locations_cubit.dart';
import 'package:weatherapp/features/locations/presentation/widgets/weather_icon.dart';

class AddLocationPage extends StatelessWidget {
  const AddLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders.withLocationSearch(
      child: const _AddLocationView(),
    );
  }
}

class _AddLocationView extends StatefulWidget {
  const _AddLocationView();

  @override
  State<_AddLocationView> createState() => _AddLocationViewState();
}

class _AddLocationViewState extends State<_AddLocationView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xffE5E5E5),
      appBar: AppBar(
        backgroundColor: const Color(0xffE5E5E5),
        title: const Text('Add City'),
        actions: [
          IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Styled search field
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(28.r),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withAlpha(10),
                    blurRadius: 16.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Enter cities',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _controller.clear();
                            context.read<LocationSearchCubit>().queryChanged('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                ),
                onChanged: context.read<LocationSearchCubit>().queryChanged,
                textInputAction: TextInputAction.search,
                onSubmitted: context.read<LocationSearchCubit>().queryChanged,
              ),
            ),
            16.vGap,
            BlocConsumer<LocationSearchCubit, LocationSearchState>(
              listener: (context, state) {
                if (state.selected != null) {
                  // Update drawer list and reload dashboard using persisted selection
                  context.read<SavedLocationsCubit>().load();
                  context.read<DashboardCubit>().load(refreshLocation: false);
                  context.pop();
                }
              },
              builder: (context, state) {
                return Expanded(
                  child: Column(
                    children: [
                      if (state.loading) const LinearProgressIndicator(minHeight: 2),
                      if (state.error != null) Padding(padding: EdgeInsets.only(top: 8.h), child: Text(state.error!, style: TextStyle(color: theme.colorScheme.error))),
                      12.vGap,
                      Expanded(
                        child: state.results.isEmpty && !state.loading
                            ? Center(child: Text('Start typing to search', style: theme.textTheme.bodyMedium))
                            : ListView.separated(
                                itemCount: state.results.length,
                                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                                itemBuilder: (_, i) {
                                  final r = state.results[i];
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surface,
                                      borderRadius: BorderRadius.circular(20.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.colorScheme.shadow.withAlpha(10),
                                          blurRadius: 16.r,
                                          offset: Offset(0, 4.h),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                      leading: const Icon(Icons.place, color: Color(0xFF2C3E50)),
                                      title: Text(
                                        r.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                                      ),
                                      subtitle: Text(
                                        r.subtitle ?? '—',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: WeatherIcon(code: r.conditionCode),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                                      onTap: () => context.read<LocationSearchCubit>().select(r),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

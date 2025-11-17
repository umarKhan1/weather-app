import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:weatherapp/core/di/service_locator.dart';
import 'package:weatherapp/core/extensions/spacing_extensions.dart';
import 'package:weatherapp/features/locations/presentation/cubit/location_search_cubit.dart';
import 'package:weatherapp/features/dashboard/presentation/cubit/dashboard_cubit.dart';

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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Add Location')),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search city, region, or country',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              onChanged: context.read<LocationSearchCubit>().queryChanged,
              textInputAction: TextInputAction.search,
              onSubmitted: context.read<LocationSearchCubit>().queryChanged,
            ),
            12.vGap,
            BlocConsumer<LocationSearchCubit, LocationSearchState>(
              listener: (context, state) {
                if (state.selected != null) {
                  context.read<DashboardCubit>().load();
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
                                separatorBuilder: (_, __) => const Divider(height: 1),
                                itemBuilder: (_, i) {
                                  final r = state.results[i];
                                  return ListTile(
                                    title: Text(r.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                                    subtitle: Text('Lat ${r.lat.toStringAsFixed(3)}, Lon ${r.lon.toStringAsFixed(3)}'),
                                    leading: const Icon(Icons.place_outlined),
                                    onTap: () => context.read<LocationSearchCubit>().select(r),
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

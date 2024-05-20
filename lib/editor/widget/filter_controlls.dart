import 'dart:typed_data';

import 'package:style_transfer/app/app.dart';

class FilterControlls extends StatelessWidget {
  const FilterControlls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterBloc, FilterState>(
      builder: (context, state) => switch (state) {
        FilterDone(filters: final filters) => FiltersListView(filters: filters),
        FilterLoading(filters: final filters) => FiltersListView(
            filters: filters,
            loading: true,
          ),
      },
    );
  }
}

class FiltersListView extends StatefulWidget {
  const FiltersListView({
    required this.filters,
    this.loading = false,
    super.key,
  });

  final bool loading;
  final List<Uint8List> filters;

  @override
  State<FiltersListView> createState() => _FiltersListViewState();
}

class _FiltersListViewState extends State<FiltersListView> {
  final scrollController = ScrollController();
  int? selectedIndex;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<StylerBloc>();

    return BlocListener<FilterBloc, FilterState>(
      listener: (context, state) {
        selectedIndex = null;
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: RawScrollbar(
          scrollbarOrientation: ScrollbarOrientation.bottom,
          thumbVisibility: true,
          trackVisibility: true,
          thickness: 5,
          controller: scrollController,
          thumbColor: context.colors.primary,
          radius: const Radius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.filters.length + (widget.loading ? 1 : 0),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: selectedIndex == index
                        ? context.colors.primary.withOpacity(0.5)
                        : Colors.transparent,
                  ),
                  margin: const EdgeInsets.all(6),
                  child: InkWell(
                    onTap: () {
                      bloc.selectedFilter(widget.filters[index]);
                      selectedIndex = index;
                      setState(() {});
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: index < widget.filters.length
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(widget.filters[index]),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

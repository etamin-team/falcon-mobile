import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/features/create_template/data/model/mnn_model.dart';
import 'package:wm_doctor/core/widgets/export.dart';
import 'package:wm_doctor/gen/locale_keys.g.dart';
import '../cubit/mnn_cubit.dart';

class MNNPage extends StatefulWidget {
  final List<MnnModel> mnn;
  final ValueChanged<MnnModel> model;
  final List<MnnModel> initialSelectedItems;
  final Function(List<MnnModel>) onSelectionComplete;

  const MNNPage({
    super.key,
    required this.mnn,
    required this.model,
    required this.initialSelectedItems,
    required this.onSelectionComplete,
  });

  @override
  State<MNNPage> createState() => _MNNPageState();

  static List<MnnModel> getSelectedItems() => [];
}

class _MNNPageState extends State<MNNPage> {
  final TextEditingController searchController = TextEditingController();
  late List<MnnModel> selectedItems;
  int currentPage = 1;
  final int pageSize = 30;
  bool hasMoreData = true;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  double? _lastScrollOffset;
  List<MnnModel> displayedItems = [];
  Timer? _searchDebounce;
  Timer? _displayTimer;

  @override
  void initState() {
    super.initState();
    selectedItems = List<MnnModel>.from(widget.initialSelectedItems);
    displayedItems = widget.mnn;
    // Initial data load
    context.read<MnnCubit>().getMnn(page: currentPage, size: pageSize);

    // Scroll listener for pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9 &&
          hasMoreData &&
          !isLoading) {
        _lastScrollOffset = _scrollController.position.pixels;
        loadMore();
      }
    });

    // Search input listener
    searchController.addListener(() {
      _searchDebounce?.cancel();
      _searchDebounce = Timer(const Duration(milliseconds: 500), () {
        setState(() {
          currentPage = 1;
          hasMoreData = true;
          displayedItems = [];
        });
        context.read<MnnCubit>().getMnnSearch(
          searchController.text.trim(),
          page: currentPage,
          size: pageSize,
        );
      });
    });
  }

  void loadMore() {
    if (hasMoreData && !isLoading) {
      setState(() => isLoading = true);
      currentPage++;
      if (searchController.text.isNotEmpty) {
        context.read<MnnCubit>().getMnnSearch(
          searchController.text.trim(),
          page: currentPage,
          size: pageSize,
        );
      } else {
        context.read<MnnCubit>().getMnn(page: currentPage, size: pageSize);
      }
    }
  }

  void displayItemsIncrementally(List<MnnModel> newItems) {
    _displayTimer?.cancel();
    int index = 0;
    _displayTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (index < newItems.length && mounted) {
        setState(() {
          displayedItems.add(newItems[index]);
        });
        index++;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    _searchDebounce?.cancel();
    _displayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(LocaleKeys.create_recep_inns.tr()),
        actions: [
          TextButton(
            onPressed: () {
              widget.onSelectionComplete(selectedItems);
              Navigator.pop(context);
            },
            child: Text(
              LocaleKeys.texts_add_mnn.tr(),
              style: TextStyle(
                color: AppColors.blueColor,
                fontSize: Dimens.space16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: Dimens.space10),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: AppTextField(
              padding: const EdgeInsets.only(bottom: 15, top: 10),
              controller: searchController,
              hintText: LocaleKeys.texts_search.tr(),
              backgroundColor: AppColors.white,
            ).paddingSymmetric(horizontal: Dimens.space20),
          ),
          BlocConsumer<MnnCubit, MnnState>(
            listener: (context, state) {
              if (state is MnnSuccess) {
                if (currentPage == 1) {
                  displayedItems = [];
                }
                final newItems = state.list;
                if (newItems.length < pageSize) {
                  setState(() => hasMoreData = false);
                }
                displayItemsIncrementally(newItems);
                setState(() => isLoading = false);

                // Restore scroll position
                if (_lastScrollOffset != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollController.jumpTo(_lastScrollOffset!);
                  });
                }
              } else if (state is MnnError) {
                setState(() => isLoading = false);
                // Optionally show a snackbar or toast for the error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMsg)),
                );
              }
            },
            builder: (context, state) {
              if (state is MnnLoading && displayedItems.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state is MnnError && displayedItems.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.errorMsg,
                          style:  TextStyle(fontSize: Dimens.space14),
                        ),
                        UniversalButton.outline(
                          height: 50,
                          width: 200,
                          text: LocaleKeys.home_refresh.tr(),
                          onPressed: () {
                            setState(() {
                              currentPage = 1;
                              hasMoreData = true;
                              isLoading = false;
                              _lastScrollOffset = null;
                              displayedItems = [];
                            });
                            if (searchController.text.isNotEmpty) {
                              context.read<MnnCubit>().getMnnSearch(
                                searchController.text.trim(),
                                page: currentPage,
                                size: pageSize,
                              );
                            } else {
                              context.read<MnnCubit>().resetAndGetMnn(
                                page: currentPage,
                                size: pageSize,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (displayedItems.isEmpty && state is! MnnError) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      "No Results Found",
                      style: TextStyle(fontSize: Dimens.space14),
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final item = displayedItems[index];
                    final isChecked = selectedItems.contains(item);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isChecked) {
                            selectedItems.remove(item);
                          } else {
                            selectedItems.add(item);
                          }
                        });
                      },
                      child: Container(
                        margin:  EdgeInsets.only(
                          bottom: 10,
                          left: Dimens.space20,
                          right: Dimens.space20,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(
                            color: isChecked ? AppColors.blueColor : AppColors.white,
                          ),
                          borderRadius: BorderRadius.circular(Dimens.space10),
                        ),
                        child: ListTile(
                          dense: true,
                          contentPadding:  EdgeInsets.symmetric(horizontal: Dimens.space20),
                          title: Container(
                            padding:  EdgeInsets.all(Dimens.space16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimens.space16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "МНН (Лат):",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        item.name ?? "",
                                        overflow: TextOverflow.clip,
                                      ),
                                      const Text(
                                        "Лекарственная форма (РУ):",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        item.type?.isEmpty ?? true ? "Null" : item.type!,
                                      ),
                                      const Text(
                                        "Дозировка (РУ):",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        item.dosage?.isEmpty ?? true ? "Null" : item.dosage!,
                                      ),
                                      const Text(
                                        "WM (РУ):",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        item.wm_ru?.isEmpty ?? true ? "Null" : item.wm_ru!,
                                      ),
                                    ],
                                  ),
                                ),
                                CheckboxTheme(
                                  data: CheckboxThemeData(
                                    fillColor: WidgetStateProperty.all(AppColors.blueColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(Dimens.space5),
                                    ),
                                    checkColor: WidgetStateProperty.all(AppColors.white),
                                    side: const BorderSide(color: AppColors.blueColor, width: 3),
                                  ),
                                  child: Checkbox(
                                    value: isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          selectedItems.add(item);
                                        } else {
                                          selectedItems.remove(item);
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: displayedItems.length,
                ),
              );
            },
          ),
          SliverToBoxAdapter(
            child: isLoading
                ? Padding(
              padding: EdgeInsets.symmetric(vertical: Dimens.space20),
              child: const Center(child: CircularProgressIndicator()),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
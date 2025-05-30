import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/features/create_template/data/model/mnn_model.dart';

import '../../../../core/widgets/export.dart';
import '../../../../gen/locale_keys.g.dart';
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

  static List<MnnModel> getSelectedItems() {
    return [];
  }
}

class _MNNPageState extends State<MNNPage> {
  final searchController = TextEditingController();
  late List<MnnModel> selectedItems;
  int currentPage = 1;
  final int pageSize = 30;
  bool hasMoreData = true;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  double? _lastScrollOffset;
  List<MnnModel> displayedItems = [];
  Timer? _displayTimer;

  get state => null;

  @override
  void initState() {
    super.initState();
    selectedItems = List<MnnModel>.from(widget.initialSelectedItems);
    context.read<MnnCubit>().getMnn(page: currentPage, size: pageSize);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9 &&
          hasMoreData &&
          !isLoading) {
        _lastScrollOffset = _scrollController.position.pixels;
        loadMore();
      }
    });
  }

  void loadMore() {
    if (hasMoreData && !isLoading) {
      setState(() {
        isLoading = true;
      });
      currentPage++;
      context.read<MnnCubit>().getMnn(page: currentPage, size: pageSize);
    }
  }

  void displayItemsIncrementally(List<MnnModel> newItems) {
    if (_displayTimer != null && _displayTimer!.isActive) {
      _displayTimer!.cancel();
    }

    int index = 0;
    _displayTimer = Timer.periodic(Duration(milliseconds: 0), (timer) {
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
              "Add MNNs",
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
              padding: EdgeInsets.only(bottom: 15, top: 10),
              controller: searchController,
              hintText: LocaleKeys.texts_search.tr(),
              onChanged: (value) {
                setState(() {});
              },
              backgroundColor: AppColors.white,
            ).paddingSymmetric(horizontal: Dimens.space20),
          ),
          BlocConsumer<MnnCubit, MnnState>(
            listener: (context, state) {
              if (state is MnnSuccess) {
                print("Loaded ${state.list.length} items");
                if (currentPage == 1) {
                  displayedItems = [];
                }
                List<MnnModel> newItems = state.list
                    .skip(currentPage == 1 ? 0 : (currentPage - 1) * pageSize)
                    .take(pageSize)
                    .toList();
                if (newItems.length < pageSize) {
                  setState(() {
                    hasMoreData = false;
                  });
                }
                displayItemsIncrementally(newItems);
                setState(() {
                  isLoading = false;
                });
                // Restore scroll position after data load
                if (_lastScrollOffset != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollController.jumpTo(_lastScrollOffset!);
                  });
                }
              } else if (state is MnnError) {
                print("MNN ERROR: ${state.errorMsg}");
                setState(() {
                  isLoading = false;
                });
              }
            },
            builder: (context, state) {
              List<MnnModel> filteredList = displayedItems.where((element) {
                return (element.name ?? "")
                    .toLowerCase()
                    .startsWith(searchController.text.trim().toLowerCase());
              }).toList();

              if (filteredList.isEmpty && state is! MnnError && !isLoading) {
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
                    final item = filteredList[index];
                    final isChecked = selectedItems.contains(item);
                    print(
                        "$index-item :::: ${item.name}\n$selectedItems\n\n$index-item ==>> isChecked ::: $isChecked");
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isChecked) {
                            selectedItems.remove(item);
                          } else {
                            selectedItems.add(item);
                            print(
                                "ID: ${item.id} name: ${item.name} latin: ${item.latinName} type: ${item.type} dosage: ${item.dosage} wm_ru: ${item.wm_ru} pharmacothera: ${item.pharmacothera}");
                          }
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10, left: Dimens.space20, right: Dimens.space20),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(
                            color: isChecked ? AppColors.blueColor : AppColors.white,
                          ),
                          borderRadius: BorderRadius.circular(Dimens.space10),
                        ),
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: Dimens.space20),
                          title: Container(
                            padding: EdgeInsets.all(Dimens.space16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimens.space16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "МНН (Лат):",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 20),
                                        child: Text(
                                          item.name.toString(),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                      Text(
                                        "Лекарственная форма (РУ):",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                      Text(
                                        item.type!.isEmpty ? "Null" : item.type.toString(),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "Дозировка (РУ):",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 15),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        item.dosage!.isEmpty
                                            ? "Null"
                                            : item.dosage.toString(),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "WM (РУ):",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 15),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        item.wm_ru!.isEmpty ? "Null" : item.wm_ru.toString(),
                                        overflow: TextOverflow.ellipsis,
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
                                    side: BorderSide(color: AppColors.blueColor, width: 3),
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
                  childCount: filteredList.length,
                ),
              );
            },
          ),
          SliverToBoxAdapter(
            child: state is MnnError
                ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    LocaleKeys.home_home_error.tr(),
                    style: TextStyle(
                      fontSize: Dimens.space14,
                      fontWeight: FontWeight.w500,
                    ),
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
                      context
                          .read<MnnCubit>()
                          .resetAndGetMnn(page: currentPage, size: pageSize);
                    },
                  ),
                ],
              ),
            )
                : hasMoreData && isLoading
                ? Padding(
              padding: EdgeInsets.symmetric(vertical: Dimens.space20),
              child: Center(child: CircularProgressIndicator()),
            )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/core/network/api_client.dart';
import 'package:wm_doctor/core/widgets/export.dart';
import 'package:wm_doctor/features/home/data/model/template_model.dart';
import 'package:wm_doctor/features/home/presentation/cubit/home_cubit.dart';
import 'package:wm_doctor/gen/locale_keys.g.dart';
import '../../../../core/utils/dependencies_injection.dart';
import '../../../create_template/presentation/page/create_template.dart';

class TemplatePage extends StatefulWidget {
  final bool isBottom;
  final ValueChanged<TemplateModel> onChange;

   TemplatePage(
      {super.key, this.isBottom = false, required this.onChange});

  @override
  State<TemplatePage> createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {
  final searchController = TextEditingController();
  List<TemplateModel> _allTemplates = [];
  String filterBy = "";

  @override
  void initState() {
    super.initState();
    context
        .read<HomeCubit>()
        .getTemplate(saved: '', sortBy: '', searchText: '');
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFFF5F6FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        title: Text(
          LocaleKeys.template_template.tr(),
          style:  TextStyle(
            fontFamily: 'VelaSans',
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: Text(
              LocaleKeys.texts_back.tr(),
              style:  TextStyle(
                fontFamily: 'VelaSans',
                fontWeight: FontWeight.w600,
                fontSize: Dimens.space16,
                color: AppColors.blueColor,
              ),
            ),
          ).paddingOnly(right: Dimens.space20),
        ],
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeGetTemplateSuccess) {
            _allTemplates = state.list;
            setState(() {});
          } else if (state is HomeGetTemplateError) {
            debugPrint('Template fetch error: ${state.failure}');
          }
        },
        builder: (context, state) {
          if (state is HomeGetTemplateLoading) {
            return  Center(child: CircularProgressIndicator());
          }

          final searchText = searchController.text.toLowerCase();
          final filteredTemplates = searchText.isEmpty
              ? _allTemplates
              : _allTemplates
                  .where((element) =>
                      element.name?.toLowerCase().startsWith(searchText) ??
                      false)
                  .toList();
          final sortedTemplates = _applyFilter(filteredTemplates);
          final savedList =
              sortedTemplates.where((element) => element.saved).toList();
          final templateList =
              sortedTemplates.where((element) => !element.saved).toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                 SizedBox(height: Dimens.space20),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(Dimens.space20),
                  ),
                  padding:  EdgeInsets.all(Dimens.space16),
                  child: Column(
                    children: [
                      Row(
                        spacing: Dimens.space10,
                        children: [
                          SvgPicture.asset(Assets.icons.filter),
                          Text(
                            LocaleKeys.texts_filters.tr(),
                            style:  TextStyle(
                              fontFamily: 'VelaSans',
                              fontSize: Dimens.space18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                       SizedBox(height: Dimens.space10),
                      AppTextField(
                        controller: searchController,
                        hintText: LocaleKeys.texts_search.tr(),
                        prefixIcon:  Icon(CupertinoIcons.search),
                      ),
                       SizedBox(height: Dimens.space10),
                      Row(
                        spacing: Dimens.space5,
                        children: [
                          _buildFilterButton(
                              "byAlphabet", LocaleKeys.texts_by_alphabet.tr()),
                          _buildFilterButton(
                              "byImportant", LocaleKeys.texts_by_priority.tr()),
                          _buildFilterButton(
                              "byTime", LocaleKeys.texts_by_chronology.tr()),
                        ],
                      ),
                    ],
                  ),
                ),
                if (savedList.isNotEmpty) ...[
                   SizedBox(height: Dimens.space20),
                  _buildTemplateSection(
                    title: LocaleKeys.template_important.tr(),
                    icon: Assets.icons.stars,
                    templates: savedList,
                    isSaved: true,
                  ),
                ],
                if (templateList.isNotEmpty) ...[
                   SizedBox(height: Dimens.space20),
                  _buildTemplateSection(
                    title: LocaleKeys.template_all.tr(),
                    icon: Assets.icons.list,
                    templates: templateList,
                    isSaved: false,
                  ),
                ],
                 SizedBox(height: Dimens.space20),
              ],
            ).paddingSymmetric(horizontal: Dimens.space20),
          );
        },
      ),
      bottomNavigationBar: widget.isBottom
          ? null
          : UniversalButton.filled(
              height: Dimens.space60,
              cornerRadius: Dimens.space16,
              text: LocaleKeys.template_add_template.tr(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  CreateTemplate()),
                );
              },
            ).paddingOnly(
              right: Dimens.space20,
              left: Dimens.space20,
              bottom: Dimens.space20,
            ),
    );
  }

  Widget _buildFilterButton(String filter, String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            filterBy = filter;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: filterBy == filter
                ? AppColors.blueColor
                : AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(Dimens.space10),
          ),
          padding:  EdgeInsets.symmetric(
              horizontal: Dimens.space5, vertical: Dimens.space16),
          alignment: Alignment.center,
          child: FittedBox(
            child: Text(
              textAlign: TextAlign.center,
              label,
              style: TextStyle(
                color: filterBy == filter ? Colors.white : Colors.black,
                fontFamily: 'VelaSans',
                fontWeight: FontWeight.w600,
                fontSize: Dimens.space12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateSection({
    required String title,
    required String icon,
    required List<TemplateModel> templates,
    required bool isSaved,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(Dimens.space20),
      ),
      padding:  EdgeInsets.all(Dimens.space16),
      child: Column(
        spacing: Dimens.space10,
        children: [
          Row(
            spacing: Dimens.space10,
            children: [
              SvgPicture.asset(icon),
              Text(
                title,
                style:  TextStyle(
                  fontFamily: 'VelaSans',
                  fontSize: Dimens.space18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          ...templates.map((template) {
            return InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                if (widget.isBottom) {
                  widget.onChange(template);
                  Navigator.of(context, rootNavigator: true).pop();
                } else {
                  // _showToast(context,  "", Colors.redAccent)
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => TemplatePage2(model: template),
                  //   ),
                  // );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.backgroundColor,
                ),
                padding:  EdgeInsets.symmetric(
                  horizontal: Dimens.space20,
                  vertical: Dimens.space16,
                ),
                child: Row(
                  spacing: Dimens.space10,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        template.name ?? "",
                        overflow: TextOverflow.ellipsis,
                        style:  TextStyle(
                          fontFamily: 'VelaSans',
                          fontSize: Dimens.space12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                     SizedBox(width: Dimens.space5),
                    GestureDetector(
                      onTap: () => _toggleSavedStatus(template, isSaved),
                      child: SvgPicture.asset(
                        isSaved
                            ? Assets.icons.bookMarkFilled
                            : Assets.icons.bookMarkOuline,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  List<TemplateModel> _applyFilter(List<TemplateModel> templates) {
    if (filterBy == "byAlphabet") {
      return List.from(templates)
        ..sort((a, b) => (a.name ?? "").compareTo(b.name ?? ""));
    } else if (filterBy == "byImportant") {
      return templates.where((element) => element.saved).toList();
    } else if (filterBy == "byTime") {
      return List.from(templates)
        ..sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
    }
    return templates;
  }

  void _showToast(BuildContext context, String message, Color backgroundColor) {
    toastification.show(
      style: ToastificationStyle.flat,
      context: context,
      alignment: Alignment.topCenter,
      title: Text(message),
      autoCloseDuration:  Duration(seconds: 2),
      showProgressBar: false,
      primaryColor: Colors.white,
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
    );
  }

  Future<void> _toggleSavedStatus(TemplateModel template, bool isSaved) async {
    try {
      final newSavedStatus = !isSaved;
      final request = await sl<ApiClient>().postMethod(
        pathUrl: "/doctor/save-template/${template.id}?save=$newSavedStatus",
        body: {},
        isHeader: true,
      );
      if (request.isSuccess) {
        setState(() {
          final index = _allTemplates.indexWhere((p) => p.id == template.id);
          if (index != -1) {
            _allTemplates[index] = template.copyWith(saved: newSavedStatus);
          }
        });
      }
    } catch (e) {
      debugPrint("Saved status change error: $e");
    }
  }
}

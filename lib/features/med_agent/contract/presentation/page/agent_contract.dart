import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/core/model/language_model.dart';
import 'package:wm_doctor/features/med_agent/contract/presentation/cubit/contract_cubit.dart';
import 'package:wm_doctor/features/med_agent/contract_details/presentation/cubit/contract_details_cubit.dart';
import 'package:wm_doctor/features/med_agent/contract_details/presentation/page/contract_details.dart';
import 'package:wm_doctor/features/regions/presentation/cubit/regions_cubit.dart';
import 'package:wm_doctor/core/utils/dependencies_injection.dart';
import 'package:wm_doctor/core/widgets/export.dart';
import 'package:wm_doctor/features/auth/sign_up/data/model/region_model.dart';
import 'package:wm_doctor/features/auth/sign_up/domain/entity/regison_entity.dart';
import 'package:wm_doctor/features/med_agent/contract/data/model/contract_model.dart';

class AgentContract extends StatefulWidget {
  const AgentContract({super.key});

  @override
  State<AgentContract> createState() => _AgentContractState();
}

class _AgentContractState extends State<AgentContract> {
  LanguageModel regionName = LanguageModel(uz: '', ru: '', en: '');
  LanguageModel doctorType = LanguageModel(uz: '', ru: '', en: '');
  int selectedDistrictId = 0;
  int selectedWorkPlaceId = 0;
  String selectedDistrictName = 'District';
  String selectedWorkPlaceName = 'WorkPlace';
  String workplaceName = "";
  String selectedDoctorType="ALL";
  List<WorkPlaceDto> workPlaceList = [];
  int districtId = 0;
  int workplaceId = 0;
  final searchController = TextEditingController();
  Timer? _debounce;
  List<District> districtList = [];

  void clearData() {
    regionName = LanguageModel(uz: '', ru: '', en: '');
    doctorType = LanguageModel(uz: '', ru: '', en: '');
    workplaceName = "";
    districtId = 0;
    workplaceId = 0;
  }

  @override
  void dispose() {
    clearData();
    _debounce?.cancel();
    searchController.dispose();
    context.read<ContractCubit>().getContracts();
    context.read<RegionsCubit>().getRegions();
    super.dispose();
  }

  void _onFilterChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1200), () {
      getContractsByFilter();
      if (kDebugMode) {
        print("Search filter applied after debounce");
      }
    });
  }

  @override
  void initState() {
    context.read<ContractCubit>().getContracts();
    // Listen to RegionsCubit state changes
    context.read<RegionsCubit>().stream.listen((state) {
      if (state is DistrictsSuccess) {
        setState(() {
          districtList = state.districts;
          if (state.districts.isNotEmpty) {
            selectedDistrictId = state.districts.first.districtId;
            selectedDistrictName = state.districts.first.name;
            getWorkPlaces();
          } else {
            selectedDistrictId = 0;
            selectedDistrictName = "Not Found";
          }
          if (kDebugMode) {
            print("-----------------------------------------------------district");
          }
        });
      } else if (state is DistrictsError) {
      } else if (state is WorkplaceSuccesss) {
        setState(() {
          workPlaceList = state.workplace;
          if (state.workplace.isNotEmpty) {
            selectedWorkPlaceId = state.workplace.first.id!;
            selectedWorkPlaceName = state.workplace.first.name!;
          } else {
            selectedWorkPlaceId = 0;
            selectedWorkPlaceName = "Not Found";
          }
          if (kDebugMode) {
            print("-----------------------------------------------------workplaces");
          }
        });
      } else if (state is WorkplaceErrorr) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error fetching workplaces: ${state.failure}')),
        // );
      }
    });
    super.initState();
  }

  void getWorkPlaces() async {
    context.read<RegionsCubit>().getWorkplacesByDistrictId(selectedDistrictId);
    Future.delayed(const Duration(milliseconds: 500), () {
      getContractsByFilter();
    });
  }

  List<String> prepareNameParts(String nameQuery) {
    if (nameQuery.trim().isEmpty) {
      return [];
    }
    List<String> nameParts = nameQuery.split(" ");
    List<String> cleanParts = [];
    for (String part in nameParts) {
      if (part.trim().isNotEmpty) {
        cleanParts.add(part.trim());
      }
    }
    return cleanParts;
  }



  void getContractsByFilter() {
    List<String> filteredParts = prepareNameParts(searchController.text);
    String firstName = filteredParts.isNotEmpty ? filteredParts[0].toLowerCase() : "";
    String lastName = filteredParts.length > 1 ? filteredParts[filteredParts.length - 1].toLowerCase() : "";
    String middleName = filteredParts.length > 2 ? filteredParts[1].toLowerCase() : "";

    context.read<ContractCubit>().getContractsWithFilter(
      districtId: selectedDistrictId.toString(),
      firstName: firstName,
      fieldName: selectedDoctorType,
      workPlaceId: selectedWorkPlaceId,
      lastName: lastName,
      middleName: middleName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          "Договора",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimens.space30),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Dimens.space20),
        child: Column(
          spacing: Dimens.space20,
          children: [
            const SizedBox(),
            Container(
              padding: EdgeInsets.all(Dimens.space20),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(Dimens.space20)),
              child: Column(
                spacing: Dimens.space10,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Регион",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: Dimens.space18),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                              value: selectedDistrictId == 0 ? null : selectedDistrictId,
                              onChanged: (int? newValue) {
                                setState(() {
                                  selectedDistrictId = newValue ?? 0;
                                  selectedDistrictName = (newValue != null
                                      ? districtList
                                      .firstWhere(
                                        (district) => district.districtId == newValue,
                                  )
                                      .name
                                      : 'District');
                                  getWorkPlaces();
                                });
                              },
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black,
                                size: 30,
                              ),
                              style: const TextStyle(fontSize: 18, color: Colors.black),
                              dropdownColor: Colors.white,
                              items: districtList
                                  .map<DropdownMenuItem<int>>((District value) {
                                return DropdownMenuItem<int>(
                                  value: value.districtId,
                                  child: Text(
                                    value.name,
                                    style: const TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              hint: const Text("WorkPlaces"),
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                              value: selectedWorkPlaceId == 0 ? null : selectedWorkPlaceId,
                              onChanged: (int? newValue) {
                                setState(() {
                                  selectedWorkPlaceId = newValue ?? 0;
                                  selectedWorkPlaceName = (newValue != null
                                      ? workPlaceList
                                      .firstWhere(
                                        (workPlace) => workPlace.id == newValue,
                                  )
                                      .name
                                      : 'WorkPlace')!;
                                  getContractsByFilter();
                                });
                              },
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black,
                                size: 30,
                              ),
                              style: const TextStyle(fontSize: 18, color: Colors.black),
                              dropdownColor: Colors.white,
                              items: workPlaceList
                                  .map<DropdownMenuItem<int>>((WorkPlaceDto value) {
                                return DropdownMenuItem<int>(
                                  value: value.id,
                                  child: Text(
                                    value.name!,
                                    style: const TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: const Text(
                                "Doctor Types",
                                overflow: TextOverflow.ellipsis,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                              value: selectedDoctorType,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedDoctorType = newValue!;
                                  getContractsByFilter();
                                });
                              },
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black,
                                size: 30,
                              ),
                              style: const TextStyle(fontSize: 18, color: Colors.black),
                              dropdownColor: AppColors.backgroundColor,
                              items: DoctorTypes.specialists
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow.fade,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppTextField(
                    onChanged: (value) {
                      _onFilterChanged();
                    },
                    controller: searchController,
                    hintText: "Ф.И.О. врача",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        _onFilterChanged();
                      },
                    )
                        : null,
                  ),
                ],
              ),
            ),
            BlocConsumer<ContractCubit, ContractState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                if (state is ContractSuccess) {
                  return Container(
                    padding: EdgeInsets.all(Dimens.space20),
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(Dimens.space20)),
                    child: Column(
                      spacing: Dimens.space10,
                      children: [
                        Row(
                          spacing: Dimens.space10,
                          children: [
                            SvgPicture.asset(Assets.icons.list),
                            Text(
                              "Все",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Dimens.space18),
                            )
                          ],
                        ),
                        ...List.generate(
                          state.list.length,
                              (index) {
                            return contractListItem(model: state.list[index]);
                          },
                        )
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            SizedBox(
              height: Dimens.space20,
            ),
          ],
        ),
      ),
    );
  }

  Widget contractListItem({required ContractModel model}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => sl<ContractDetailsCubit>(),
                  child: ContractDetails(
                    id: model.doctorId ?? "",
                  ),
                )));
      },
      child: Container(
        padding: EdgeInsets.all(Dimens.space16),
        decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(Dimens.space16)),
        child: Column(
          spacing: Dimens.space10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimens.space10, vertical: Dimens.space8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.space5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(CupertinoIcons.person_fill),
                      SizedBox(
                        width: Dimens.space10,
                      ),
                      Text(
                        "${model.user?.firstName ?? ""} ${model.user?.lastName}",
                        style: TextStyle(
                            fontSize: Dimens.space16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Icon(CupertinoIcons.right_chevron, size: 20)
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 5.0),
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimens.space10, vertical: Dimens.space8),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(Dimens.space5)),
                    child: Text(
                      "Договор №${model.id}",
                      style: TextStyle(
                          fontSize: Dimens.space16, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Dimens.space10,
              children: List.generate(
                model.medicineWithQuantityDoctorDTOS?.take(6).length ?? 0,
                    (index) => Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimens.space10, vertical: Dimens.space8),
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(Dimens.space5)),
                        child: Text(
                            "${model.medicineWithQuantityDoctorDTOS?[index].medicine?.name ?? ""} ${model.medicineWithQuantityDoctorDTOS?[index].medicine?.volume ?? ""}"),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
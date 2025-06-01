import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:wm_doctor/core/extensions/widget_extensions.dart';
import 'package:wm_doctor/features/med_agent/add_doctor/presentation/page/agent_add_doctor.dart';
import 'package:wm_doctor/features/regions/presentation/cubit/regions_cubit.dart';
import 'package:wm_doctor/gen/locale_keys.g.dart';
import '../../../../../core/services/secure_storage.dart';
import '../../../../../core/utils/dependencies_injection.dart';
import '../../../../../core/widgets/export.dart';
import '../../../../auth/sign_up/data/model/region_model.dart';
import '../../../../auth/sign_up/domain/entity/regison_entity.dart';
import '../../../contract/data/model/contract_model.dart';
import '../../../home/data/model/doctors_model.dart';
import '../../../home/presentation/cubit/doctor/doctor_cubit.dart';
import '../cubit/add_doctor_cubit.dart';

class DoctorsPageD extends StatefulWidget {
  final ValueChanged<String> id;
  final ValueChanged<String> firstName;
  final ValueChanged<String> lastName;
  final ValueChanged<String> type;
  final ValueChanged<String> level;
  final ValueChanged<String> phone;

  const DoctorsPageD({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.id,
    required this.type,
    required this.level,
    required this.phone,
  });

  @override
  State<DoctorsPageD> createState() => _DoctorsPageDState();
}

class _DoctorsPageDState extends State<DoctorsPageD> {
  bool hasContract = true;
  List<District> districtList = [];
  String selectedDistrictName = 'District';
  String selectedWorkPlaceName = 'WorkPlace';
  int selectedDistrictId = 0;
  int selectedWorkPlaceId = 0;
  List<WorkPlaceDto> workPlaceList = [];
  var selectedDoctorType;
  final searchController = TextEditingController();
  List<DoctorsModel> filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    getDistricts();
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
          print("-----------------------------------------------------district");
        });
      } else if (state is DistrictsError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching districts: ${state.failure}')),
        );
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
        });
      } else if (state is WorkplaceErrorr) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching workplaces: ${state.failure}')),
        );
      }
    });
  }

  void getDistricts() async {
    String token = await SecureStorage().read(key: "accessToken") ?? "";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String id = decodedToken["regionId"].toString();
    context.read<RegionsCubit>().getDistrictsByRegionID(id);
  }

  void getWorkPlaces() async {
    context.read<RegionsCubit>().getWorkplacesByDistrictId(selectedDistrictId);
    Future.delayed(Duration(milliseconds: 400), () {
      getUsersByFilter();
    });
  }

  void getUsersByFilter() async {
    context.read<DoctorCubit>().getDoctorsWithFilters(
      selectedDistrictId,
      selectedWorkPlaceId,
      selectedDoctorType,
      hasContract,
    );
  }

  void clearData() {
    districtList = [];
    workPlaceList = [];
    selectedDistrictId = 0;
    selectedWorkPlaceId = 0;
    selectedDoctorType = null;
    selectedDistrictName = 'District';
    selectedWorkPlaceName = 'WorkPlace';
    searchController.clear();
    context.read<DoctorCubit>().clear(); // Moved cubit clear to clearData
    context.read<RegionsCubit>().clear();
  }

  @override
  void dispose() {
    clearData(); // Call clearData to reset all state when widget is disposed
    searchController.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorCubit, DoctorState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        if (state is DoctorSuccess) {
          filteredDoctors = state.list.where((region) {
            final doctorFirstName = region.firstName;
            return doctorFirstName
                .toString()
                .toLowerCase()
                .contains(searchController.text.toLowerCase().trim());
          }).toList();
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: AppBar(
              forceMaterialTransparency: true,
              automaticallyImplyLeading: false,
              title: GestureDetector(
                onTap: () {
                  clearData();
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: Dimens.space5,
                  children: [
                    Icon(
                      Icons.arrow_back_ios_outlined,
                      color: AppColors.blueColor,
                    ),
                    Text(
                      LocaleKeys.texts_back.tr(),
                      style: TextStyle(
                        fontFamily: 'VelaSans',
                        fontSize: Dimens.space16,
                        color: AppColors.blueColor,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                UniversalButton.filled(
                  text: "Add Doctor",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => sl<AddDoctorCubit>(),
                          child: AgentAddDoctor(),
                        ),
                      ),
                    );
                  },
                  width: 160,
                  margin: EdgeInsets.all(Dimens.space10),
                  cornerRadius: Dimens.space10,
                ),
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Dimens.space10,
              children: [
                Text(
                  "Выберите врача",
                  style: TextStyle(
                    fontFamily: 'VelaSans',
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                AppTextField(
                  backgroundColor: AppColors.white,
                  controller: searchController,
                  hintText: LocaleKeys.texts_search.tr(),
                  prefixIcon: Icon(CupertinoIcons.search),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
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
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                style: TextStyle(fontSize: 18, color: Colors.black),
                                dropdownColor: Colors.white,
                                items: districtList
                                    .map<DropdownMenuItem<int>>((District value) {
                                  return DropdownMenuItem<int>(
                                    value: value.districtId,
                                    child: Text(
                                      value.name,
                                      style: TextStyle(fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                hint: Text("WorkPlaces"),
                                borderRadius: BorderRadius.all(Radius.circular(15)),
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
                                    getUsersByFilter();
                                  });
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                style: TextStyle(fontSize: 18, color: Colors.black),
                                dropdownColor: Colors.white,
                                items: workPlaceList
                                    .map<DropdownMenuItem<int>>((WorkPlaceDto value) {
                                  return DropdownMenuItem<int>(
                                    value: value.id,
                                    child: Text(
                                      value.name!,
                                      style: TextStyle(fontSize: 16),
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
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                hint: Text(
                                  "Doctor Types",
                                  overflow: TextOverflow.ellipsis,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                value: selectedDoctorType,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedDoctorType = newValue;
                                    getUsersByFilter();
                                  });
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                style: TextStyle(fontSize: 18, color: Colors.black),
                                dropdownColor: Colors.white,
                                items: DoctorTypes.specialists
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(fontSize: 14),
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
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: Dimens.space10,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: Dimens.space10,
                            children: List.generate(
                              filteredDoctors.length,
                                  (index) {
                                return GestureDetector(
                                  onTap: () {
                                    if (filteredDoctors[index].contractAvailable!) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Этот доктор уже имеет контракт, пожалуйста, выберите другого',
                                          ),
                                        ),
                                      );
                                    } else {
                                      widget.id(filteredDoctors[index].userId ?? '');
                                      widget.firstName(filteredDoctors[index].firstName ?? '');
                                      widget.lastName(filteredDoctors[index].lastName ?? '');
                                      widget.level(filteredDoctors[index].fieldName ?? '');
                                      widget.type(filteredDoctors[index].position ?? '');
                                      widget.phone(filteredDoctors[index].phoneNumber ?? '');
                                      clearData();
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: Dimens.space4),
                                    padding: EdgeInsets.all(Dimens.space14),
                                    decoration: BoxDecoration(
                                      color: filteredDoctors[index].contractAvailable!
                                          ? Color(0xFF00FF79)
                                          : Color(0xFFFFFFFF),
                                      borderRadius: BorderRadius.circular(Dimens.space10),
                                    ),
                                    alignment: AlignmentDirectional.centerStart,
                                    child: Text(
                                      '${filteredDoctors[index].firstName ?? ''} ${filteredDoctors[index].lastName ?? ''}',
                                      style: TextStyle(
                                        fontSize: Dimens.space16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: Dimens.space20),
          );
        }
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
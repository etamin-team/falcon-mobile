import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/core/utils/dependencies_injection.dart';
import 'package:wm_doctor/core/widgets/export.dart';
import 'package:wm_doctor/features/auth/sign_up/data/model/region_model.dart';
import 'package:wm_doctor/features/med_agent/contract/data/model/contract_model.dart';
import 'package:wm_doctor/features/med_agent/contract/presentation/cubit/contract_cubit.dart';
import 'package:wm_doctor/features/med_agent/contract_details/presentation/cubit/contract_details_cubit.dart';
import 'package:wm_doctor/features/med_agent/contract_details/presentation/page/contract_details.dart';
import 'package:wm_doctor/features/regions/presentation/cubit/regions_cubit.dart';
import 'package:wm_doctor/gen/locale_keys.g.dart';

import '../../../../auth/sign_up/domain/entity/regison_entity.dart';

class AgentContract extends StatefulWidget {
  const AgentContract({super.key});

  @override
  State<AgentContract> createState() => _AgentContractState();
}

class _AgentContractState extends State<AgentContract> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  var _selectedDistrictId = 0;
  var _selectedWorkPlaceId = 0;
  String _selectedDistrictName = "";
  String _selectedWorkPlaceName = "";
  String _selectedDoctorType = "ALL";
  List<District> _districtList = [];
  List<WorkPlaceDto> _workPlaceList = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _searchController.addListener(_onFilterChanged);
  }

  void _initializeData() {
    context.read<ContractCubit>().getContracts();
    context.read<RegionsCubit>().getRegions();

    context.read<RegionsCubit>().stream.listen((state) {
      setState(() {
        if (state is RegionsSuccess) {
          _districtList = state.regions.first.districts;
          if (state.regions.first.districts.isNotEmpty) {
            _selectedDistrictId =
                state.regions.first.districts.first.districtId;
            _selectedDistrictName = state.regions.first.districts.first.name;
            _fetchWorkPlaces();
          } else {
            _selectedDistrictId = 0;
            _selectedDistrictName = LocaleKeys.med_add_doctor_select_region_hint.tr();
          }
        } else if (state is WorkplaceSuccesss) {
          _workPlaceList = state.workplace;
          if (state.workplace.isNotEmpty) {
            _selectedWorkPlaceId = state.workplace.first.id!;
            _selectedWorkPlaceName = state.workplace.first.name!;
          } else {
            _selectedWorkPlaceId = 0;
            _selectedWorkPlaceName = LocaleKeys.med_add_doctor_select_workplace_hint.tr();
          }
        } else if (state is WorkplaceErrorr) {
          _showErrorSnackBar(state.failure as String);
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onFilterChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onFilterChanged() {
    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 500), _fetchContractsByFilter);
  }

  void _fetchWorkPlaces() {
    context.read<RegionsCubit>().getWorkplacesByDistrictId(_selectedDistrictId);
    Future.delayed(Duration(milliseconds: 500), _fetchContractsByFilter);
  }

  void _fetchContractsByFilter() {
    final nameParts = _prepareNameParts(_searchController.text);
    context.read<ContractCubit>().getContractsWithFilter(
          districtId:
              _selectedDistrictId == 0 ? "" : _selectedDistrictId.toString(),
          firstName: nameParts.isNotEmpty ? nameParts[0] : "",
          fieldName: _selectedDoctorType,
          workPlaceId: _selectedWorkPlaceId,
          lastName: nameParts.length > 1 ? nameParts[nameParts.length - 1] : "",
          middleName: nameParts.length > 2 ? nameParts[1] : "",
        );
  }

  List<String> _prepareNameParts(String nameQuery) {
    return nameQuery
        .trim()
        .split(" ")
        .where((part) => part.isNotEmpty)
        .map((part) => part.toLowerCase())
        .toList();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          LocaleKeys.med_contract_title.tr(),
          style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: Dimens.space30),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Dimens.space20),
        child: Column(
          children: [
            SizedBox(height: Dimens.space20),
            _buildFilterContainer(),
            BlocConsumer<ContractCubit, ContractState>(
              listener: (context, state) {
                if (state is ContractError) {
                  _showErrorSnackBar(state.failure as String);
                }
              },
              builder: (context, state) => _buildContractList(state),
            ),
            SizedBox(height: Dimens.space20),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterContainer() {
    return Container(
      padding: EdgeInsets.all(Dimens.space20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(Dimens.space20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            LocaleKeys.med_contract_filters.tr(),
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: Dimens.space18),
          ),
          SizedBox(height: Dimens.space10),
          Row(
            children: [
              Expanded(child: _buildDistrictDropdown()),
              SizedBox(width: Dimens.space10),
              Expanded(child: _buildWorkplaceDropdown()),
            ],
          ),
          SizedBox(height: Dimens.space10),
          _buildDoctorTypeDropdown(),
          AppTextField(
            controller: _searchController,
            hintText: LocaleKeys.med_contract_search.tr(),
            prefixIcon: Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _onFilterChanged();
                    },
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDistrictDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          borderRadius: BorderRadius.circular(15),
          value: _selectedDistrictId == 0 ? null : _selectedDistrictId,
          hint: Text(_selectedDistrictName),
          onChanged: (int? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedDistrictId = newValue;
                _selectedDistrictName = _districtList
                    .firstWhere((district) => district.districtId == newValue)
                    .name;
                _fetchWorkPlaces();
              });
            }
          },
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 30),
          style: TextStyle(fontSize: 18, color: Colors.black),
          dropdownColor: Colors.white,
          items: _districtList
              .map((district) => DropdownMenuItem<int>(
                    value: district.districtId,
                    child: Text(district.name,
                        style: TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildWorkplaceDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          borderRadius: BorderRadius.circular(15),
          value: _selectedWorkPlaceId == 0 ? null : _selectedWorkPlaceId,
          hint: Text(_selectedWorkPlaceName),
          onChanged: (int? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedWorkPlaceId = newValue;
                _selectedWorkPlaceName = _workPlaceList
                    .firstWhere((workPlace) => workPlace.id == newValue)
                    .name!;
                _fetchContractsByFilter();
              });
            }
          },
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 30),
          style: TextStyle(fontSize: 18, color: Colors.black),
          dropdownColor: Colors.white,
          items: _workPlaceList
              .map((workPlace) => DropdownMenuItem<int>(
                    value: workPlace.id,
                    child: Text(workPlace.name!,
                        style: TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildDoctorTypeDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          borderRadius: BorderRadius.circular(15),
          value: _selectedDoctorType,
          hint: Text(
            "LocaleKeys",
            overflow: TextOverflow.ellipsis,
          ),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedDoctorType = newValue;
                _fetchContractsByFilter();
              });
            }
          },
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 30),
          style: TextStyle(fontSize: 18, color: Colors.black),
          dropdownColor: AppColors.backgroundColor,
          items: DoctorTypes.specialists
              .map((value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildContractList(ContractState state) {
    if (state is ContractLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (state is ContractSuccess) {
      return Container(
        margin: EdgeInsets.only(top: Dimens.space20),
        padding: EdgeInsets.all(Dimens.space20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(Dimens.space20),
        ),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(Assets.icons.list),
                SizedBox(width: Dimens.space10),
                Text(
                  LocaleKeys.med_contract_all.tr(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: Dimens.space18),
                ),
              ],
            ),
            SizedBox(height: Dimens.space10),
            if (state.list.isEmpty)
              Text(LocaleKeys.med_contract_no_results.tr())
            else
              ...state.list
                  .map((model) => _buildContractListItem(model))
                  ,
          ],
        ),
      );
    }
    return SizedBox();
  }

  Widget _buildContractListItem(ContractModel model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => sl<ContractDetailsCubit>(),
              child: ContractDetails(id: model.doctorId ?? ""),
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: Dimens.space10),
        padding: EdgeInsets.all(Dimens.space16),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(Dimens.space16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(CupertinoIcons.person_fill),
                    SizedBox(width: Dimens.space10),
                    Text(
                      "${model.user?.firstName ?? ""} ${model.user?.lastName ?? ""}",
                      style: TextStyle(
                          fontSize: Dimens.space16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Icon(CupertinoIcons.right_chevron, size: 20),
              ],
            ),
            SizedBox(height: Dimens.space10),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimens.space10, vertical: Dimens.space8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(Dimens.space5),
              ),
              child: Text(
                "${LocaleKeys.med_contract_number.tr()} ${model.id}",
                style: TextStyle(fontSize: Dimens.space16),
              ),
            ),
            SizedBox(height: Dimens.space10),
            if (model.medicineWithQuantityDoctorDTOS != null)
              ...model.medicineWithQuantityDoctorDTOS!
                  .take(6)
                  .map((medicine) => Container(
                        margin: EdgeInsets.only(bottom: Dimens.space5),
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimens.space10,
                            vertical: Dimens.space8),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(Dimens.space5),
                        ),
                        child: Text(
                            "${medicine.medicine?.name ?? ""} ${medicine.medicine?.volume ?? ""}"),
                      ))
                  ,
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wm_doctor/features/create_recept/presentation/page/create_recep.dart';
import 'package:wm_doctor/features/home/presentation/page/HomePage.dart';
import 'package:wm_doctor/features/main/presentation/cubit/main_page_cubit.dart';
import 'package:wm_doctor/features/med_agent/contract/presentation/page/agent_contract.dart';
import 'package:wm_doctor/features/med_agent/profile/presentation/page/agent_profile.dart';
import 'package:wm_doctor/features/medicine/presentation/cubit/medicine_cubit.dart';
import 'package:wm_doctor/features/profile/presentation/page/profile.dart';
import 'package:wm_doctor/features/regions/presentation/cubit/regions_cubit.dart';
import 'package:wm_doctor/features/workplace/presentation/cubit/workplace_cubit.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../../../core/widgets/export.dart';
import '../../../../gen/locale_keys.g.dart';
import '../../../../main.dart';
import '../../../auth/sign_up/presentation/page/sign_page.dart';
import '../../../auth/sign_up/presentation/page/sign_up_success.dart';
import '../../../create_template/data/model/mnn_model.dart';
import '../../../med_agent/home/presentation/page/agent_home_page.dart';

class MainPage extends StatefulWidget {
    final bool fromCheck;

  const MainPage({super.key, this.fromCheck = false});

   @override
     State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isDialogOpen = false;
  bool isDataDownload = false;

  late StreamSubscription<InternetConnectionStatus> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = connectionChecker.onStatusChange.listen(
          (status) {
        if (status == InternetConnectionStatus.connected) {
          debugPrint("internet ulandi ✅=============================");
          if (isDialogOpen) {
            isDialogOpen = false;
          }
          if (!isDataDownload) {
            if (!widget.fromCheck) {
              context.read<MainPageCubit>().checkToken();
            }
            context.read<RegionsCubit>().getRegions();
          }
          internet = true;
        } else {
          debugPrint("❌ internet uzildi =============================");
          internet = false;
          isDialogOpen = true;
        }
      },
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainPageCubit, MainPageState>(
      listener: (context, state) async {
        if (state is MainPageSuccess) {
          setState(() {
            isDataDownload = true;
          });
          debugPrint(state.status);
          if (state.status == "ENABLED") {
            context.read<MedicineCubit>().getMedicine();
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => SignUpSuccessPage(
                    title: LocaleKeys.sign_in_sign_in_title.tr(),
                    text: LocaleKeys.sign_in_sign_in_text.tr(),
                  )),
                  (route) => false,
            );
          }
        }
        if (state is MainPageError) {
          if (state.failure.statusCode == 401 ||
              state.failure.statusCode == 403) {
            await FlutterSecureStorage().deleteAll();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SignPage()),
                  (route) => false,
            );
          }
        }
      },
      builder: (context, state) {
        if (state is MainPageSuccess) {
          if (state.role == "MEDAGENT" && state.status == "ENABLED") {
            return Scaffold(
              body: IndexedStack(
                index: state.selectedIndex,
                children: [
                  AgentHomePage(),
                  AgentContract(),
                  AgentProfile(),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.white,
                currentIndex: state.selectedIndex,
                onTap: (value) {
                  context.read<MainPageCubit>().changeSelectedIndex(value);
                },
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.grey,
                selectedLabelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 12,
                ),
                items: [
                  _buildBottomNavigationBarItem(
                    icon: 'assets/icons/home.svg',
                    label: LocaleKeys.main_main.tr(),
                    index: 0,
                    isSelected: state.selectedIndex == 0,
                  ),
                  _buildBottomNavigationBarItem(
                    icon: 'assets/icons/document.svg',
                    label: LocaleKeys.main_contracts.tr(),
                    index: 1,
                    isSelected: state.selectedIndex == 1,
                  ),
                  _buildBottomNavigationBarItem(
                    icon: 'assets/icons/profile.svg',
                    label: LocaleKeys.main_profile.tr(),
                    index: 2,
                    isSelected: state.selectedIndex == 2,
                  ),
                ],
              ),
            );
          } else if (state.role == "DOCTOR" && state.status == "ENABLED") {
            return Scaffold(
              body: IndexedStack(
                index: state.selectedIndex,
                children: [
                  HomePage(),
                  CreateRecep(List<MnnModel>.empty(),),
                  ProfilePage(),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.white,
                currentIndex: state.selectedIndex,
                onTap: (value) {
                  context.read<MainPageCubit>().changeSelectedIndex(value);
                },
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.grey,
                selectedLabelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 12,
                ),
                items: [
                  _buildBottomNavigationBarItem(
                    icon: 'assets/icons/home.svg',
                    label: LocaleKeys.main_main.tr(),
                    index: 0,
                    isSelected: state.selectedIndex == 0,
                  ),
                  _buildBottomNavigationBarItem(
                    icon: 'assets/icons/add.svg',
                    label: LocaleKeys.main_create_recep.tr(),
                    index: 1,
                    isSelected: state.selectedIndex == 1,
                  ),
                  _buildBottomNavigationBarItem(
                    icon: 'assets/icons/profile.svg',
                    label: LocaleKeys.main_profile.tr(),
                    index: 2,
                    isSelected: state.selectedIndex == 2,
                  ),
                ],
              ),
            );
          } else {
            // Handle invalid role or status
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: Dimens.space20,
                  children: [
                    Text(
                      "Cannot login: Invalid role (${state.role}) or status (${state.status})",
                      style: TextStyle(
                        fontSize: Dimens.space16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Role: ${state.role}",
                      style: TextStyle(
                        fontSize: Dimens.space14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    UniversalButton.filled(
                      height: 50,
                      width: 200,
                      text: "Logout",
                      onPressed: () async {
                        await FlutterSecureStorage().deleteAll();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => SignPage()),
                              (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        }
        if (state is MainPageError) {
          return Scaffold(
            body: Center(
              child: Column(
                spacing: Dimens.space20,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Something went wrong",
                    style: TextStyle(
                      fontSize: Dimens.space14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  UniversalButton.outline(
                    height: 50,
                    width: 200,
                    text: "Refresh",
                    onPressed: () {
                      context.read<MainPageCubit>().checkToken();
                    },
                  ),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: CupertinoActivityIndicator(),
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required String icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        icon,
        color: isSelected ? Colors.black : Colors.grey,
        height: isSelected ? 30 : 24,
        width: isSelected ? 30 : 24,
      ),
      label: label,
    );
  }
}
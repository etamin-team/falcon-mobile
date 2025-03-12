import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wm_doctor/core/styles/app_themes.dart';
import 'package:wm_doctor/features/auth/sign_in/presentation/cubit/sign_in_cubit.dart';
import 'package:wm_doctor/features/auth/sign_up/presentation/cubit/sign_up_cubit.dart';
import 'package:wm_doctor/features/auth/sign_up/presentation/page/sign_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/features/create_recept/presentation/cubit/create_recep_cubit.dart';
import 'package:wm_doctor/features/create_template/presentation/cubit/create_template_cubit.dart';
import 'package:wm_doctor/features/home/presentation/cubit/home_cubit.dart';
import 'package:wm_doctor/features/main/presentation/cubit/main_page_cubit.dart';
import 'package:wm_doctor/features/main/presentation/page/main_page.dart';
import 'package:wm_doctor/features/med_agent/contract/presentation/cubit/contract_cubit.dart';
import 'package:wm_doctor/features/med_agent/home/presentation/cubit/agent_home_cubit.dart';
import 'package:wm_doctor/features/med_agent/home/presentation/cubit/doctor/doctor_cubit.dart';
import 'package:wm_doctor/features/med_agent/profile/presentation/cubit/agent_profile_data/agent_profile_data_cubit.dart';
import 'package:wm_doctor/features/medicine/presentation/cubit/medicine_cubit.dart';
import 'package:wm_doctor/features/profile/presentation/cubit/out_contract/out_contract_cubit.dart';
import 'package:wm_doctor/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:wm_doctor/features/profile/presentation/cubit/profile_data/profile_data_cubit.dart';
import 'package:wm_doctor/features/profile/presentation/cubit/statistics/statistics_cubit.dart';
import 'package:wm_doctor/features/regions/presentation/cubit/regions_cubit.dart';
import 'package:wm_doctor/features/reset_password/presentation/cubit/reset_password_cubit.dart';
import 'package:wm_doctor/features/workplace/presentation/cubit/workplace_cubit.dart';
import 'core/network/interceptor.dart';
import 'core/services/secure_storage.dart';
import 'core/utils/dependencies_injection.dart';
import 'features/medicine/presentation/cubit/mnn_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await serviceLocator();
  runApp(EasyLocalization(
      supportedLocales: const [
        Locale('uz'), // O'zbekcha
        Locale('ru'), // Ruscha
        Locale('en'), // Inglizcha
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('ru'),
      child: MyApp()));
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    // StatusBarni shaffof qilish (yoki kerakli rangni o'rnating)
    statusBarIconBrightness:
        Brightness.dark, // StatusBar ikonalari qora rangda bo'lishi uchun
  ));
}

final connectionChecker = InternetConnectionChecker.instance;
bool internet = true;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  bool isHaveToken = false;
  bool isDialogOpen = false;

  // late StreamSubscription<InternetConnectionStatus> _subscription;

  @override
  void initState() {
    checkToken();
    // _subscription = connectionChecker.onStatusChange.listen(
    //   (status) {
    //
    //       if (status == InternetConnectionStatus.connected) {
    //         debugPrint("internet ulandi ✅=============================");
    //         // if (isDialogOpen) {
    //         //   Navigator.of(navigatorKey.currentContext!, rootNavigator: true).pop();
    //         //   isDialogOpen = false;
    //         // }
    //         internet = true;
    //       } else {
    //         debugPrint("internet uzildi ❌=============================");
    //         internet = false;
    //         // showInternetDialog(context);
    //         // isDialogOpen=true;
    //       }
    //
    //   },
    // );
    super.initState();
  }

  @override
  void dispose() {
    // _subscription.cancel(); // Resurslarni tozalash
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<SignUpCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<SignInCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<HomeCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<CreateTemplateCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<MainPageCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<MnnCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<RegionsCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<ProfileCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<ProfileDataCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<CreateRecepCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<WorkplaceCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<MedicineCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<ResetPasswordCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<StatisticsCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<OutContractCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<AgentProfileDataCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<AgentHomeCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<DoctorCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<ContractCubit>(),
        ),
        // BlocProvider(
        //   create: (context) => sl<ContractDetailsCubit>(),
        // ),
        // BlocProvider(
        //   create: (context) => sl<EditContractCubit>(),
        // ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        locale: context.locale,
        // Hozirgi tanlangan til
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        title: "-app-",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
            // Shrift hajmi o'zgarmas
            child: child!,
          );
        },
        home: mainView(),
      ),
    );
  }

  Widget mainView() {
    if (!isLoading) {
      if (isHaveToken) {
        return MainPage();
      } else {
        return SignPage();
      }
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void checkToken() async {
    final token = await SecureStorage().read(key: 'accessToken') ?? "";
    if (token != "") {
      isHaveToken = true;
    }
    isLoading = false;
    setState(() {});
  }
}

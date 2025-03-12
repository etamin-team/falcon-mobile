import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:wm_doctor/features/auth/sign_in/data/repository/sign_in_repository_impl.dart';
import 'package:wm_doctor/features/auth/sign_in/presentation/cubit/sign_in_cubit.dart';
import 'package:wm_doctor/features/auth/sign_up/data/repository/sign_up_repository_impl.dart';
import 'package:wm_doctor/features/auth/sign_up/presentation/cubit/sign_up_cubit.dart';
import 'package:wm_doctor/features/create_recept/data/repository/create_recep_repository_impl.dart';
import 'package:wm_doctor/features/create_recept/presentation/cubit/create_recep_cubit.dart';
import 'package:wm_doctor/features/create_template/data/repository/craete_template_repository_impl.dart';
import 'package:wm_doctor/features/create_template/presentation/cubit/create_template_cubit.dart';
import 'package:wm_doctor/features/home/data/repository/home_repository_impl.dart';
import 'package:wm_doctor/features/home/presentation/cubit/home_cubit.dart';
import 'package:wm_doctor/features/main/data/repository/main_repository_impl.dart';
import 'package:wm_doctor/features/main/presentation/cubit/main_page_cubit.dart';
import 'package:wm_doctor/features/med_agent/add_doctor/data/repository/add_doctor_repository_impl.dart';
import 'package:wm_doctor/features/med_agent/add_doctor/presentation/cubit/add_doctor_cubit.dart';
import 'package:wm_doctor/features/med_agent/contract/data/repository/contract_repository_impl.dart';
import 'package:wm_doctor/features/med_agent/contract/presentation/cubit/contract_cubit.dart';
import 'package:wm_doctor/features/med_agent/contract_details/data/repository/contract_details_repository_impl.dart';
import 'package:wm_doctor/features/med_agent/contract_details/presentation/cubit/contract_details_cubit.dart';
import 'package:wm_doctor/features/med_agent/edit_contract/data/repository/edit_contract_repository_impl.dart';
import 'package:wm_doctor/features/med_agent/edit_contract/presentation/cubit/edit_contract_cubit.dart';
import 'package:wm_doctor/features/med_agent/home/data/repository/agent_home_repository_impl.dart';
import 'package:wm_doctor/features/med_agent/home/presentation/cubit/agent_home_cubit.dart';
import 'package:wm_doctor/features/med_agent/home/presentation/cubit/doctor/doctor_cubit.dart';
import 'package:wm_doctor/features/med_agent/profile/data/repository/agent_profile_repository_impl.dart';
import 'package:wm_doctor/features/medicine/data/repository/medicine_repository_impl.dart';
import 'package:wm_doctor/features/medicine/presentation/cubit/medicine_cubit.dart';
import 'package:wm_doctor/features/profile/data/repository/profile_repository_impl.dart';
import 'package:wm_doctor/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:wm_doctor/features/profile/presentation/cubit/profile_data/profile_data_cubit.dart';
import 'package:wm_doctor/features/profile/presentation/cubit/statistics/statistics_cubit.dart';
import 'package:wm_doctor/features/regions/data/repository/regions_repository_impl.dart';
import 'package:wm_doctor/features/regions/presentation/cubit/regions_cubit.dart';
import 'package:wm_doctor/features/reset_password/data/repository/reset_password_repository_impl.dart';
import 'package:wm_doctor/features/reset_password/presentation/cubit/reset_password_cubit.dart';
import 'package:wm_doctor/features/workplace/data/repository/workplace_repository_impl.dart';
import 'package:wm_doctor/features/workplace/presentation/cubit/workplace_cubit.dart';
import '../../features/med_agent/profile/presentation/cubit/agent_profile_data/agent_profile_data_cubit.dart';
import '../../features/profile/presentation/cubit/out_contract/out_contract_cubit.dart';
import '../network/api_client.dart';
import '../network/api_telegram_client.dart';
import '../styles/app_colors.dart';

GetIt sl = GetIt.instance;

Future<void> serviceLocator({
  bool isUnitTest = false,
  bool isHiveEnable = true,
  String prefixBox = '',
}) async {
  /// For unit testing only
  if (isUnitTest) {
    await sl.reset();
  }
  sl.registerSingleton<ApiClient>(ApiClient());
  sl.registerSingleton<ApiTelegramClient>(ApiTelegramClient());
  _styles();
  _dataSources();
  _repositories();
  _useCase();
  _blocs();
  // if (isHiveEnable) {
  //   await _initHiveBoxes(
  //     isUnitTest: isUnitTest,
  //     prefixBox: prefixBox,
  //   );
  // }
}

/// styles
void _styles() {
  sl.registerSingleton<AppColors>(AppColors());
  // sl.registerLazySingleton<UsersRepository>(() => UsersRepositoryImpl(sl()));
}

/// Register repositories
void _repositories() {
  final Dio dio = Dio();
  sl.registerSingleton<Dio>(dio);
  // sl.registerLazySingleton<SignUpRepositoryImpl>(() => SignUpRepositoryImpl());
  sl.registerLazySingleton<SignUpRepositoryImpl>(() => SignUpRepositoryImpl());
  sl.registerLazySingleton<SignInRepositoryImpl>(() => SignInRepositoryImpl());
  sl.registerLazySingleton<HomeRepositoryImpl>(() => HomeRepositoryImpl());
  sl.registerLazySingleton<CreateTemplateRepositoryImpl>(
      () => CreateTemplateRepositoryImpl());
  sl.registerLazySingleton<MainRepositoryImpl>(() => MainRepositoryImpl());
  sl.registerLazySingleton<RegionsRepositoryImpl>(
      () => RegionsRepositoryImpl());
  sl.registerLazySingleton<ProfileRepositoryImpl>(
      () => ProfileRepositoryImpl());
  sl.registerLazySingleton<CreateRecepRepositoryImpl>(
      () => CreateRecepRepositoryImpl());
  sl.registerLazySingleton<WorkplaceRepositoryImpl>(
      () => WorkplaceRepositoryImpl());
  sl.registerLazySingleton<MedicineRepositoryImpl>(
      () => MedicineRepositoryImpl());
  sl.registerLazySingleton<ResetPasswordRepositoryImpl>(
      () => ResetPasswordRepositoryImpl());
  sl.registerLazySingleton<AgentProfileRepositoryImpl>(
      () => AgentProfileRepositoryImpl());
  sl.registerLazySingleton<AgentHomeRepositoryImpl>(
      () => AgentHomeRepositoryImpl());
  sl.registerLazySingleton<AddDoctorRepositoryImpl>(
      () => AddDoctorRepositoryImpl());
  sl.registerLazySingleton<ContractRepositoryImpl>(
      () => ContractRepositoryImpl());
  sl.registerLazySingleton<ContractDetailsRepositoryImpl>(
      () => ContractDetailsRepositoryImpl());
  sl.registerLazySingleton<EditContractRepositoryImpl>(
      () => EditContractRepositoryImpl());
}

/// Register dataSources
void _dataSources() {
  // sl.registerLazySingleton<AuthRemoteDatasource>(() => AuthRemoteDatasourceImpl(sl()),
}

void _useCase() {
  /// Auth
  // sl.registerLazySingleton(() => SignUpUseCase());

  /// Users
  // sl.registerLazySingleton(() => GetUsers(sl()));
}

void _blocs() {
  // sl.registerFactory(() => SignUpBloc(repositoryImpl: sl<SignUpRepositoryImpl>()));
  sl.registerFactory(() => SignUpCubit(sl<SignUpRepositoryImpl>()));
  sl.registerFactory(() => SignInCubit(sl<SignInRepositoryImpl>()));
  sl.registerFactory(() => HomeCubit(sl<HomeRepositoryImpl>()));
  sl.registerFactory(
      () => CreateTemplateCubit(sl<CreateTemplateRepositoryImpl>()));
  sl.registerFactory(() => MainPageCubit(sl<MainRepositoryImpl>()));
  sl.registerFactory(() => RegionsCubit(sl<RegionsRepositoryImpl>()));
  sl.registerFactory(() => ProfileCubit(sl<ProfileRepositoryImpl>()));
  sl.registerFactory(() => CreateRecepCubit(sl<CreateRecepRepositoryImpl>()));
  sl.registerFactory(() => WorkplaceCubit(sl<WorkplaceRepositoryImpl>()));
  sl.registerFactory(() => MedicineCubit(sl<MedicineRepositoryImpl>()));
  sl.registerFactory(() => ProfileDataCubit(sl<ProfileRepositoryImpl>()));
  sl.registerFactory(
      () => ResetPasswordCubit(sl<ResetPasswordRepositoryImpl>()));
  sl.registerFactory(() => StatisticsCubit(sl<ProfileRepositoryImpl>()));
  sl.registerFactory(() => OutContractCubit(sl<ProfileRepositoryImpl>()));
  sl.registerFactory(
      () => AgentProfileDataCubit(sl<AgentProfileRepositoryImpl>()));
  sl.registerFactory(() => AgentHomeCubit(sl<AgentHomeRepositoryImpl>()));
  sl.registerFactory(() => AddDoctorCubit(sl<AddDoctorRepositoryImpl>()));
  sl.registerFactory(() => DoctorCubit(sl<AgentHomeRepositoryImpl>()));
  sl.registerFactory(() => ContractCubit(sl<ContractRepositoryImpl>()));
  sl.registerFactory(
      () => ContractDetailsCubit(sl<ContractDetailsRepositoryImpl>()));
  sl.registerFactory(() => EditContractCubit(sl<EditContractRepositoryImpl>()));
}

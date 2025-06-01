import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wm_doctor/gen/locale_keys.g.dart';

import '../../../../core/widgets/export.dart';
import '../../../home/presentation/cubit/home_cubit.dart';

class ReceiptSuccessPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _ReceiptSuccessPageState();

}

class _ReceiptSuccessPageState extends State<ReceiptSuccessPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/icons/success.svg",
                  height: 50, width: 50),
              SizedBox(height: 20),
              Text(
                textAlign: TextAlign.center,
                LocaleKeys.create_recep_send_recep_successful.tr(),
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<HomeCubit>().getTemplate(saved: "", sortBy: "", searchText: "");
                  Navigator.pop(context,true);
                },
                style: ElevatedButton.styleFrom(
                  shadowColor: AppColors.blueColor,
                  padding: EdgeInsets.all(12),
                  backgroundColor: AppColors.blueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(LocaleKeys.create_recep_success_button.tr(),style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        ),
    );
  }
}
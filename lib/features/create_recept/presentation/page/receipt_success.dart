import 'package:flutter/cupertino.dart';
import 'package:wm_doctor/features/home/presentation/page/HomePage.dart';

import '../../../../core/widgets/export.dart';
import '../../../main/presentation/page/main_page.dart';

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
                'Рецент успешно\nотправлен!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                },
                style: ElevatedButton.styleFrom(
                  shadowColor: AppColors.blueColor,
                  padding: EdgeInsets.all(12),
                  backgroundColor: AppColors.blueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('НА ГЛАВНУЮ',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        ),
    );
  }
}
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:wm_doctor/core/network/api_client.dart';
import 'package:wm_doctor/features/profile/presentation/page/profile.dart';
import 'package:wm_doctor/gen/locale_keys.g.dart';

import '../../../../core/services/secure_storage.dart';
import '../../../../core/utils/dependencies_injection.dart';
import '../../../../core/widgets/export.dart';
import '../../../auth/sign_up/presentation/page/sign_page.dart';
import '../../data/model/user_model.dart';

mixin ProfileUtility on State<ProfilePage> {
  void changeAddress({required UserModel model, required districtId}) async {
    String token = await SecureStorage().read(key: "accessToken") ?? "";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String uuid = decodedToken["sub"];
    final request = await sl<ApiClient>()
        .putMethod(pathUrl: "/user/$uuid", isHeader: true, body: {
      "userId": model.userId,
      "firstName": model.firstName,
      "lastName": model.lastName,
      "middleName": model.middleName,
      "dateOfBirth": model.dateOfBirth,
      "phoneNumber": model.phoneNumber,
      "number": model.number,
      "email": model.email,
      "position": model.position,
      "fieldName": model.fieldName,
      "gender": model.gender,
      "status": model.status,
      "creatorId": model.creatorId,
      "workplaceId": model.workplaceId,
      "districtId": districtId,
      "role": model.role
    });
    if (request.isSuccess) {
      debugPrint("place updated========================");
    } else {
      debugPrint(
          "place error======================== >> ${request.response.toString()}");
    }
  }

  void showLogOutDiaolog({required BuildContext ctx}) {
    showCupertinoDialog(
      context: ctx,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(LocaleKeys.home_delete_attention.tr(),
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: Dimens.space18)),
          content: Text(
          LocaleKeys.home_exit_attention_text.tr(),
            style: TextStyle(fontSize: Dimens.space16),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(LocaleKeys.home_cancel.tr(),     style: TextStyle(fontSize: Dimens.space14),),
              onPressed: () {
                Navigator.of(context).pop(); // Dialogni yopish
              },
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(LocaleKeys.home_exit.tr(),     style: TextStyle(fontSize: Dimens.space14,color: Colors.red),),
              onPressed: () async{
                await FlutterSecureStorage().deleteAll();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignPage()),
                      (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showResult(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Dialogni yopish
              },
            ),
          ],
        );
      },
    );
  }
}

import 'package:easy_localization/easy_localization.dart';

import '../model/language_model.dart';
import '../widgets/export.dart';

String dataTranslate({required BuildContext ctx,required LanguageModel model}) {
  String currentLang = ctx.locale.languageCode;
  if(currentLang=="uz"){
    return model.uz;
  }else if(currentLang=="ru"){
    return model.ru;
  }else if(currentLang=="en"){
    return model.en;
  }
  return model.uz;
}

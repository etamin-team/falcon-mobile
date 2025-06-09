import '../../../../../core/model/language_model.dart';

class RegionEntity {
  static List<Map<String, dynamic>> uzbekistanRegions = [
    {
      "region": "Toshkent viloyati",
      "districts": [
        "Bekobod tumani",
        "Bo'stonliq tumani",
        "Chirchiq shahri",
        "Ohangaron tumani",
        "Oqqo‘rg‘on tumani",
        "Parkent tumani",
        "Piskent tumani",
        "Quyichirchiq tumani",
        "Toshkent tumani",
        "Yangiyo‘l tumani",
      ],
    },
    {
      "region": "Andijon viloyati",
      "districts": [
        "Andijon shahri",
        "Asaka tumani",
        "Baliqchi tumani",
        "Buloqboshi tumani",
        "Izboskan tumani",
        "Jalaquduq tumani",
        "Marhamat tumani",
        "Oltinko‘l tumani",
        "Paxtaobod tumani",
        "Shahrixon tumani",
        "Qo‘rg‘ontepa tumani",
        "Xo‘jaobod tumani",
        "Bo‘z tumani",
      ],
    },
    {
      "region": "Namangan viloyati",
      "districts": [
        "Namangan shahri",
        "Chortoq tumani",
        "Chust tumani",
        "Kosonsoy tumani",
        "Mingbuloq tumani",
        "Norin tumani",
        "Pop tumani",
        "To‘raqo‘rg‘on tumani",
        "Uychi tumani",
        "Yangiqo‘rg‘on tumani",
      ],
    },
    {
      "region": "Farg‘ona viloyati",
      "districts": [
        "Farg‘ona shahri",
        "Marg‘ilon shahri",
        "Qo‘qon shahri",
        "Oltiariq tumani",
        "Quva tumani",
        "Rishton tumani",
        "So‘x tumani",
        "Toshloq tumani",
        "Uchko‘prik tumani",
        "Yozyovon tumani",
        "Dang‘ara tumani",
        "Beshariq tumani",
        "Furqat tumani",
      ],
    },
    {
      "region": "Samarqand viloyati",
      "districts": [
        "Samarqand shahri",
        "Bulung‘ur tumani",
        "Ishtixon tumani",
        "Jomboy tumani",
        "Kattaqo‘rg‘on tumani",
        "Narpay tumani",
        "Oqdaryo tumani",
        "Payariq tumani",
        "Pastdarg‘om tumani",
        "Qo‘shrabot tumani",
        "Toyloq tumani",
        "Urgut tumani",
      ],
    },
    {
      "region": "Buxoro viloyati",
      "districts": [
        "Buxoro shahri",
        "G‘ijduvon tumani",
        "Jondor tumani",
        "Kogon tumani",
        "Olot tumani",
        "Peshku tumani",
        "Qorako‘l tumani",
        "Qorovulbozor tumani",
        "Romitan tumani",
        "Shofirkon tumani",
        "Vobkent tumani",
      ],
    },
    {
      "region": "Qashqadaryo viloyati",
      "districts": [
        "Qarshi shahri",
        "Chiroqchi tumani",
        "Dehqonobod tumani",
        "G‘uzor tumani",
        "Kasbi tumani",
        "Kitob tumani",
        "Koson tumani",
        "Mirishkor tumani",
        "Muborak tumani",
        "Nishon tumani",
        "Shahrisabz tumani",
        "Yakkabog‘ tumani",
      ],
    },
    {
      "region": "Surxondaryo viloyati",
      "districts": [
        "Termiz shahri",
        "Angor tumani",
        "Boysun tumani",
        "Denov tumani",
        "Jarqo‘rg‘on tumani",
        "Muzrabot tumani",
        "Oltinsoy tumani",
        "Qiziriq tumani",
        "Qumqo‘rg‘on tumani",
        "Sariosiyo tumani",
        "Sherobod tumani",
        "Sho‘rchi tumani",
      ],
    },
    {
      "region": "Jizzax viloyati",
      "districts": [
        "Jizzax shahri",
        "Arnasoy tumani",
        "Baxmal tumani",
        "Do‘stlik tumani",
        "Forish tumani",
        "G‘allaorol tumani",
        "Sharof Rashidov tumani",
        "Mirzacho‘l tumani",
        "Paxtakor tumani",
        "Yangiobod tumani",
        "Zafarobod tumani",
        "Zarbdor tumani",
      ],
    },
    {
      "region": "Xorazm viloyati",
      "districts": [
        "Urganch shahri",
        "Bog‘ot tumani",
        "Gurlan tumani",
        "Qo‘shko‘pir tumani",
        "Shovot tumani",
        "Xonqa tumani",
        "Hazorasp tumani",
        "Xiva tumani",
        "Yangiariq tumani",
        "Yangibozor tumani",
      ],
    },
    {
      "region": "Navoiy viloyati",
      "districts": [
        "Navoiy shahri",
        "Konimex tumani",
        "Qiziltepa tumani",
        "Nurota tumani",
        "Tomdi tumani",
        "Uchquduq tumani",
        "Xatirchi tumani",
        "Zarafshon shahri",
      ],
    },
    {
      "region": "Qoraqalpog‘iston Respublikasi",
      "districts": [
        "Nukus shahri",
        "Amudaryo tumani",
        "Beruniy tumani",
        "Chimboy tumani",
        "Ellikqal’a tumani",
        "Kegeyli tumani",
        "Mo‘ynoq tumani",
        "Qonliko‘l tumani",
        "Qo‘ng‘irot tumani",
        "Qorao‘zak tumani",
        "Shumanay tumani",
        "Taxtako‘pir tumani",
        "To‘rtko‘l tumani",
      ],
    },
  ];
}

class DoctorTypes {
  static List<String> englishSelect = [
    "Neurologist",
    "Surgeon",
    "Pediatrician",
    "Ophthalmologist",
    "Dermatologist",
    "Endocrinologist",
    "Gastroenterologist",
    "Traumatologist",
  ];
  static List<String> uzbekSelect = [
    "Nevropatolog",
    "Jarroh",
    "Pediatr",
    "Oftalmolog",
    "Dermatolog",
    "Endokrinolog",
    "Gastroenterolog",
    "Travmatolog",
  ];

  static List<String> russianSelect = [
    "Невролог",
    "Хирург",
    "Педиатр",
    "Офтальмолог",
    "Дерматолог",
    "Эндокринолог",
    "Гастроэнтеролог",
    "Травматолог",
  ];
  static List<String> specialistsSelect = [
    "NEUROLOGIST",
    "SURGEON",
    "PEDIATRICIAN",
    "OPHTHALMOLOGIST",
    "DERMATOLOGIST",
    "ENDOCRINOLOGIST",
    "GASTROENTEROLOGIST",
    "TRAUMATOLOGIST",
  ];

  static List<String> english = [
    "All",
    "Neurologist",
    "Surgeon",
    "Pediatrician",
    "Ophthalmologist",
    "Dermatologist",
    "Endocrinologist",
    "Gastroenterologist",
    "Traumatologist",
  ];
  static List<String> uzbek = [
    "Barchasi",
    "Nevropatolog",
    "Jarroh",
    "Pediatr",
    "Oftalmolog",
    "Dermatolog",
    "Endokrinolog",
    "Gastroenterolog",
    "Travmatolog",
  ];

  static List<String> russian = [
    "Невролог",
    "Хирург",
    "Педиатр",
    "Офтальмолог",
    "Дерматолог",
    "Эндокринолог",
    "Гастроэнтеролог",
    "Травматолог",
  ];

  static List<String> specialists = [
    "ALL",
    "NEUROLOGIST",
    "SURGEON",
    "PEDIATRICIAN",
    "OPHTHALMOLOGIST",
    "DERMATOLOGIST",
    "ENDOCRINOLOGIST",
    "GASTROENTEROLOGIST",
    "TRAUMATOLOGIST",
  ];

  static List<String> doctorDegreesEn = [
    "MEDICAL STUDENT",
    "INTERN",
    "RESIDENT",
    "FELLOW",
    "ATTENDING PHYSICIAN",
    "SENIOR CONSULTANT",
    "ASSOCIATE PROFESSOR",
    "PROFESSOR",
    "CHIEF PHYSICIAN",
    "MEDICAL DIRECTOR",
    "DOCTOR OF MEDICINE (MD)",
    "DOCTOR OF OSTEOPATHIC MEDICINE (DO)",
    "MASTER OF PUBLIC HEALTH (MPH)",
    "PHD IN MEDICAL SCIENCES",
  ];
  static List<String> doctorDegreesUz = [
    "TIBBIYOT TALABASI",
    "INTERN",
    "REZIDENT",
    "STAJYOR",
    "ISHLAYOTGAN SHIFOKOR",
    "KATTA MASLAHATCHI",
    "ASSOTSIATSIYALASHGAN PROFESSOR",
    "PROFESSOR",
    "BOSH SHIFOKOR",
    "TIBBIY DIREKTOR",
    "TIBBIYOT DOKTORI (MD)",
    "OSTEOPATIYA DOKTORI (DO)",
    "JAMOAT SALOMATLIGI MAGISTRI (MPH)",
    "TIBBIYOT FANLARI NOMZODI (PHD)",
  ];

  static List<String> doctorDegreesRu = [
    "СТУДЕНТ МЕДИЦИНСКОГО ВУЗА",
    "ИНТЕРН",
    "РЕЗИДЕНТ",
    "СТАЖЁР",
    "ДЕЖУРНЫЙ ВРАЧ",
    "СТАРШИЙ КОНСУЛЬТАНТ",
    "ДОЦЕНТ",
    "ПРОФЕССОР",
    "ГЛАВНЫЙ ВРАЧ",
    "МЕДИЦИНСКИЙ ДИРЕКТОР",
    "ДОКТОР МЕДИЦИНСКИХ НАУК (MD)",
    "ДОКТОР ОСТЕОПАТИИ (DO)",
    "МАГИСТР ОБЩЕСТВЕННОГО ЗДРАВООХРАНЕНИЯ (MPH)",
    "КАНДИДАТ МЕДИЦИНСКИХ НАУК (PHD)",
  ];
}

class MedicineType {
  static List<String> uzbek = [
    "Siroplar",
    "Inyektsiyalar",
    "Tabletkalar",
    "Gel",
    "Shamchalar",
    "Kapsulalar",
    "Suspenziyalar",
    "Granulalar",
    "Pastilkalar",
    "Sprey",
    "Krem",
    "Og'iz tomchilari",
    "Aerozollar",
    "Og'iz eritmalari",
    "Paketlar"
  ];

  static List<String> russian = [
    "Сиропы",
    "Инъекции",
    "Таблетки",
    "Гель",
    "Суппозитории",
    "Капсулы",
    "Суспензии",
    "Гранулы",
    "Леденцы",
    "Спрей",
    "Крем",
    "Пероральные капли",
    "Аэрозоли",
    "Пероральные растворы",
    "Саше"
  ];

  static List<String> english = [
    "Syrups",
    "Injections",
    "Tablets",
    "Gel",
    "Suppositories",
    "Capsules",
    "Suspensions",
    "Granules",
    "Lozenges",
    "Spray",
    "Cream",
    "Oral Drops",
    "Aerosols",
    "Oral Solutions",
    "Sachets"
  ];
}

LanguageModel checkMedicineType({required String name}) {
  final listUz = MedicineType.uzbek;
  final listRu = MedicineType.russian;
  final listEn = MedicineType.english;

  for (int a = 0; a < listUz.length; a++) {
    if (listUz[a].toUpperCase() == name.toUpperCase() ||
        listRu[a].toUpperCase() == name.toUpperCase() ||
        listEn[a].toUpperCase() == name.toUpperCase()) {
      return LanguageModel(uz: listUz[a], ru: listRu[a]);
      // return LanguageModel(uz: listUz[a], ru: listRu[a], en: listEn[a]);
    }
  }

  return LanguageModel(uz: name, ru: name);
  // return LanguageModel(uz: name, ru: name, en: name);
}

LanguageModel findDoctorType({required String name}) {
  final listUz = DoctorTypes.uzbek;
  final listRu = DoctorTypes.russian;
  final listEn = DoctorTypes.english;

  for (int a = 0; a < listUz.length; a++) {
    if (listUz[a].toUpperCase() == name.toUpperCase() ||
        listRu[a].toUpperCase() == name.toUpperCase() ||
        listEn[a].toUpperCase() == name.toUpperCase()) {
      return LanguageModel(uz: listUz[a], ru: listRu[a]);
      // return LanguageModel(uz: listUz[a], ru: listRu[a], en: listEn[a]);
    }
  }

  return LanguageModel(uz: name, ru: name);
  // return LanguageModel(uz: name, ru: name, en: name);
}

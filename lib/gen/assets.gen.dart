/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsExtrasGen {
  const $AssetsExtrasGen();

  /// File path: assets/extras/wh_gradient.png
  AssetGenImage get whGradient =>
      const AssetGenImage('assets/extras/wh_gradient.png');

  /// List of all assets
  List<AssetGenImage> get values => [whGradient];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/add.svg
  String get add => 'assets/icons/add.svg';

  /// File path: assets/icons/book_mark_filled.svg
  String get bookMarkFilled => 'assets/icons/book_mark_filled.svg';

  /// File path: assets/icons/book_mark_ouline.svg
  String get bookMarkOuline => 'assets/icons/book_mark_ouline.svg';

  /// File path: assets/icons/bookmark.svg
  String get bookmark => 'assets/icons/bookmark.svg';

  /// File path: assets/icons/calendar.svg
  String get calendar => 'assets/icons/calendar.svg';

  /// File path: assets/icons/copy.svg
  String get copy => 'assets/icons/copy.svg';

  /// File path: assets/icons/delete.svg
  String get delete => 'assets/icons/delete.svg';

  /// File path: assets/icons/directory.svg
  String get directory => 'assets/icons/directory.svg';

  /// File path: assets/icons/document.svg
  String get document => 'assets/icons/document.svg';

  /// File path: assets/icons/filter.svg
  String get filter => 'assets/icons/filter.svg';

  /// File path: assets/icons/folder.svg
  String get folder => 'assets/icons/folder.svg';

  /// File path: assets/icons/global.svg
  String get global => 'assets/icons/global.svg';

  /// File path: assets/icons/graph.svg
  String get graph => 'assets/icons/graph.svg';

  /// File path: assets/icons/home.svg
  String get home => 'assets/icons/home.svg';

  /// File path: assets/icons/jar.svg
  String get jar => 'assets/icons/jar.svg';

  /// File path: assets/icons/list.svg
  String get list => 'assets/icons/list.svg';

  /// File path: assets/icons/list.svg
  String get person_heart => 'assets/icons/person_heart.svg';

  /// File path: assets/icons/log_out.svg
  String get logOut => 'assets/icons/log_out.svg';

  /// File path: assets/icons/minus.svg
  String get minus => 'assets/icons/minus.svg';

  /// File path: assets/icons/pen.svg
  String get pen => 'assets/icons/pen.svg';

  /// File path: assets/icons/person.svg
  String get person => 'assets/icons/person.svg';

  /// File path: assets/icons/pills.svg
  String get pills => 'assets/icons/pills.svg';

  /// File path: assets/icons/plus.svg
  String get plus => 'assets/icons/plus.svg';

  /// File path: assets/icons/profile.svg
  String get profile => 'assets/icons/profile.svg';

  /// File path: assets/icons/repeat.svg
  String get repeat => 'assets/icons/repeat.svg';

  /// File path: assets/icons/ru.svg
  String get ru => 'assets/icons/ru.svg';

  /// File path: assets/icons/stars.svg
  String get stars => 'assets/icons/stars.svg';

  /// File path: assets/icons/stethoscope.svg
  String get stethoscope => 'assets/icons/stethoscope.svg';

  /// File path: assets/icons/usa.svg
  String get usa => 'assets/icons/usa.svg';

  /// File path: assets/icons/uz.svg
  String get uz => 'assets/icons/uz.svg';

  /// List of all assets
  List<String> get values => [
        add,
        bookMarkFilled,
        bookMarkOuline,
        bookmark,
        calendar,
        copy,
        delete,
        directory,
        document,
        filter,
        folder,
        global,
        graph,
        home,
        jar,
        list,
        logOut,
        minus,
        pen,
        person,
        pills,
        plus,
        profile,
        repeat,
        ru,
        stars,
        stethoscope,
        usa,
        uz
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/bg_log.jpg
  AssetGenImage get bgLog => const AssetGenImage('assets/images/bg_log.jpg');

  /// File path: assets/images/profile_image.png
  AssetGenImage get profileImage =>
      const AssetGenImage('assets/images/profile_image.png');

  /// List of all assets
  List<AssetGenImage> get values => [bgLog, profileImage];
}

class $AssetsLottieGen {
  const $AssetsLottieGen();

  /// File path: assets/lottie/internet.json
  String get internet => 'assets/lottie/internet.json';

  /// List of all assets
  List<String> get values => [internet];
}

class $AssetsTranslationsGen {
  const $AssetsTranslationsGen();

  /// File path: assets/translations/en.json
  String get en => 'assets/translations/en.json';

  /// File path: assets/translations/ru.json
  String get ru => 'assets/translations/ru.json';

  /// File path: assets/translations/uz.json
  String get uz => 'assets/translations/uz.json';

  /// List of all assets
  List<String> get values => [en, ru, uz];
}

class Assets {
  Assets._();

  static const $AssetsExtrasGen extras = $AssetsExtrasGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLottieGen lottie = $AssetsLottieGen();
  static const $AssetsTranslationsGen translations = $AssetsTranslationsGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

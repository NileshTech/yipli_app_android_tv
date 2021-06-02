import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class YipliAssets {
  static const yipliLogoPath = "assets/images/yipli_logo.png";
  static const yipliMatImagePath = 'assets/images/mats/maticonnew.png';
  static const yipliMatImage = 'assets/images/mats/colour_mat.jpg';
  static const yipliAddPlayerSliderImage_02 = "assets/images/Slider-02.png";
}

class YipliConstants {
  static const featureDiscoveryAddNewMatId = "featureDiscoveryAddNewMatId";
  static const featureDiscoveryAddNewPlayerId =
      "featureDiscoveryAddNewPlayerId";

  //Yipli Home features
  static const featureDiscoveryDrawerButtonId =
      "featureDiscoveryDrawerButtonId";

  static const featureDiscoveryPlayerProfileId =
      "featureDiscoveryPlayerProfileId";

  static const featureAdventureGamingId = "featureDiscoveryAdventureGamingId";
  static const featureFitnessGamingId = "featureFitnessGamingId";

  static const featureDiscoveryYipliFeedId = "featureDiscoveryYipliFeedId";

  static const featureDiscoverySwitchPlayerId =
      "featureDiscoverySwitchPlayerId";

  static const String yipliHomeFeaturesDisabledKey =
      "yipliHomeFeaturesDisabledKey";

  static final DateFormat onlyDateFormat = DateFormat("yyyy-MM-dd");

  static String matIconFile = "assets/images/mats/maticonnew.png";

  static String lastOpenedDateTime;

  static Size getProfilePicDimensionsSmall(BuildContext context) {
    return new Size(MediaQuery.of(context).size.height / 10,
        MediaQuery.of(context).size.height / 10);
  }

  static Size getProfilePicDimensionsLarge(BuildContext context) {
    return new Size(MediaQuery.of(context).size.height / 7,
        MediaQuery.of(context).size.height / 7);
  }

  static const AudioAssetDirPath = "asset:///assets/audio/OnBoarding/";
}

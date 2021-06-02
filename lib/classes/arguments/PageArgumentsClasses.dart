import 'package:flutter_app/pages/a_pages_index.dart';

class MatPageArguments {
  String macAddress;
  bool isOnboardingFlow;
  // UserOnBoardingFlows flowValue = UserOnBoardingFlows.NA;

  MatPageArguments({this.macAddress, this.isOnboardingFlow});
}

class PlayerPageArguments {
  List<PlayerModel> allPlayerDetails;
  bool isOnboardingFlow;
  // UserOnBoardingFlows flowValue = UserOnBoardingFlows.NA;

  PlayerPageArguments({this.allPlayerDetails, this.isOnboardingFlow});
}

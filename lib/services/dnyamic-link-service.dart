import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_app/pages/a_pages_index.dart';

class DynamicLinkService {
  static bool isexecuted = false;

  static final DynamicLinkService _dynamicLinkService =
      DynamicLinkService._internal();

  factory DynamicLinkService() => _dynamicLinkService;

  DynamicLinkService._internal();

  Future handleDynamicLinks() async {
    // 1. Get the initial dynamic link if the app is opened with a dynamic link
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    // 2. handle link that has been retrieved
    _handleDeepLink(data);

    // 3. Register a link callback to fire if the app is opened up from the background
    // using a dynamic link.
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      // 3a. handle link that has been retrieved
      _handleDeepLink(dynamicLink);
    }, onError: (OnLinkErrorException e) async {
      print('Link Failed: ${e.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData data) {
    final Uri deepLink = data?.link;
    String routeValue;
    int i = -1;
    String gameToAutoLaunch;
    if (deepLink != null) {
      print('_handleDeepLink | deeplink: $deepLink');
      deepLink.queryParameters.forEach((key, value) {
        print('_handleDeepLink | key: $key | value: $value');
        if (key == "route") {
          routeValue = value;
        } else if (key == "gameName") {
          gameToAutoLaunch = value;
        }
      });

      DynamicLinkService.isexecuted =
          true; // used flag to support link after killing the app.
      switch (routeValue) {
        case 'playerListScreen':
          {
            try {
              print("IN playerListScreen case");
              YipliUtils.goToPlayersPage();
            } catch (e) {
              print("Error $e");
            }
            break;
          }
        case 'matListScreen':
          {
            try {
              print("IN matListScreen case");
              YipliUtils.navigatorKey.currentState
                  .pushNamed(MatMenuPage.routeName);
            } catch (e) {
              print("Error $e");
            }
            break;
          }
        case 'gamesListScreen':
          {
            try {
              print("IN gamesListScreen case");
              YipliUtils.goToHomeScreen(gameToAutoLaunch);
            } catch (e) {
              print("Error $e");
            }
            break;
          }

        default:
          print("Invalid arguments recieved in Dynamic links.");
          break;
      }
    }
  }
}

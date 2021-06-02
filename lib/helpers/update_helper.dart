library new_version;

// import 'package:flutter_app/helpers/in_app_update.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:html/parser.dart' show parse;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter_app/widgets/buttons.dart';

import 'color_scheme.dart';
import 'package:flutter/src/widgets/implicit_animations.dart';

/// Information about the app's current version, and the most recent version
/// available in the Apple App Store or Google Play Store.
class VersionStatus {
  /// True if the there is a more recent version of the app in the store.
  bool canUpdate;

  /// The current version of the app.
  String localVersion;

  /// The most recent version of the app in the store.
  String storeVersion;

  /// A link to the app store page where the app can be updated.
  String appStoreLink;

  VersionStatus({this.canUpdate, this.localVersion, this.storeVersion});
}

class NewVersion {
  /// This is required to check the user's platform and display alert dialogs.
  BuildContext context;

  /// An optional value that can override the default packageName when
  /// attempting to reach the Google Play Store. This is useful if your app has
  /// a different package name in the Play Store for some reason.
  String androidId;

  /// An optional value that can override the default packageName when
  /// attempting to reach the Apple App Store. This is useful if your app has
  /// a different package name in the App Store for some reason.
  String iOSId;

  /// An optional value that can override the default callback to dismiss button
  VoidCallback dismissAction;

  /// An optional value that can override the default text to alert,
  /// you can ${versionStatus.localVersion} to ${versionStatus.storeVersion}
  /// to determinate in the text a versions.
  String dialogText;

  /// An optional value that can override the default title of alert dialog
  String dialogTitle;

  /// An optional value that can override the default text of dismiss button
  String dismissText;

  /// An optional value that can override the default text of update button
  String updateText;

  int localVersion;

  int androidCompulsoryUpdateVersion;

  int iosCompulsoryUpdateVersion;

  NewVersion({
    this.androidId,
    this.iOSId,
    @required this.context,
    this.dismissAction,
    this.dismissText: 'Maybe Later',
    this.updateText: 'Update',
    this.dialogText,
    this.dialogTitle: 'Update Required',
  }) : assert(context != null);

  /// This checks the version status, then displays a platform-specific alert
  /// with buttons to dismiss the update alert, or go to the app store.
  showAlertIfNecessary() async {
    VersionStatus versionStatus = await getVersionStatus();

    localVersion = int.parse(versionStatus.localVersion.replaceAll(".", ""));

    await FirebaseDatabase.instance
        .reference()
        .child('inventory')
        .child('yipli-app')
        .child('minimum-support-version')
        .child('android')
        .once()
        .then((snapshot) {
      androidCompulsoryUpdateVersion = snapshot.value;
    });

    // await FirebaseDatabase.instance
    //     .reference()
    //     .child('inventory')
    //     .child('yipli-app')
    //     .child('minimum-support-version')
    //     .child('ios')
    //     .once()
    //     .then((snapshot) {
    //   iosCompulsoryUpdateVersion = snapshot.value;
    // });

    localVersion < androidCompulsoryUpdateVersion ||
            localVersion < iosCompulsoryUpdateVersion
        ? showCompulsoryUpdate(versionStatus)
        : versionStatus != null && versionStatus.canUpdate
            ? showUpdateDialog(versionStatus)
            : print('No Update required');
  }

  /// This checks the version status and returns the information. This is useful
  /// if you want to display a custom alert, or use the information in a different
  /// way.
  Future<VersionStatus> getVersionStatus() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    VersionStatus versionStatus = VersionStatus(
      localVersion: packageInfo.version,
    );
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
        final id = androidId ?? packageInfo.packageName;
        versionStatus = await _getAndroidStoreVersion(id, versionStatus);
        break;
      case TargetPlatform.iOS:
        final id = iOSId ?? packageInfo.packageName;
        versionStatus = await _getiOSStoreVersion(id, versionStatus);
        break;
      default:
        print('This target platform is not yet supported by this package.');
    }
    if (versionStatus == null) {
      return null;
    }

    int localAndroidVersion =
        int.parse(versionStatus.localVersion.replaceAll(".", ""));

    int storeVersion =
        int.parse(versionStatus.storeVersion.replaceAll(".", ""));

    versionStatus.canUpdate = localAndroidVersion < storeVersion;
    return versionStatus;
  }

  /// iOS info is fetched by using the iTunes lookup API, which returns a
  /// JSON document.
  _getiOSStoreVersion(String id, VersionStatus versionStatus) async {
    final url = 'https://itunes.apple.com/lookup?bundleId=$id';
    final response = await http.get(url);
    if (response.statusCode != 200) {
      print('Can\'t find an app in the App Store with the id: $id');
      return null;
    }
    final jsonObj = json.decode(response.body);
    versionStatus.storeVersion = jsonObj['results'][0]['version'];
    versionStatus.appStoreLink = jsonObj['results'][0]['trackViewUrl'];
    return versionStatus;
  }

  /// Android info is fetched by parsing the html of the app store page.
  _getAndroidStoreVersion(String id, VersionStatus versionStatus) async {
    final url = 'https://play.google.com/store/apps/details?id=$id';
    final response = await http.get(url);
    if (response.statusCode != 200) {
      print('Can\'t find an app in the Play Store with the id: $id');
      return null;
    }
    final document = parse(response.body);
    final elements = document.getElementsByClassName('hAyfc');
    final versionElement = elements.firstWhere(
      (elm) => elm.querySelector('.BgcNfc').text == 'Current Version',
    );
    versionStatus.storeVersion = versionElement.querySelector('.htlgb').text;
    versionStatus.appStoreLink = url;
    return versionStatus;
  }

  Tween<double> _scaleTween = Tween<double>(begin: 1, end: 1.08);

  /// Shows the user a platform-specific alert about the app update. The user
  /// can dismiss the alert or proceed to the app store.
  void showUpdateDialog(VersionStatus versionStatus) async {
    final title = Text(dialogTitle,
        style: Theme.of(context)
            .textTheme
            .headline5
            .copyWith(color: yipliNewBlue));
    final content = Text(
        this.dialogText ??
            'Update to the latest version is recommended for better experience.',
        style: Theme.of(context).textTheme.subtitle1,
        textAlign: TextAlign.center);
    final dismissText = Text(this.dismissText);
    final dismissAction = this.dismissAction ??
        () => Navigator.of(context, rootNavigator: false).pop();
    final updateText = Text(this.updateText);
    final updateAction = () {
      _launchAppStore(versionStatus.appStoreLink);
    };
    final platform = Theme.of(context).platform;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        Size screenSize = MediaQuery.of(context).size;
        YipliButton updateButton;
        updateButton = new YipliButton(
          'Update',
          null,
          null,
          screenSize.width / 4,
        );
        updateButton.setClickHandler(updateAction);
        return platform == TargetPlatform.android
            ? Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: TweenAnimationBuilder(
                  tween: _scaleTween,
                  curve: Curves.easeIn,
                  duration: Duration(milliseconds: 600),
                  builder: (context, scale, child) {
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: Container(
                      height: (screenSize.height / 4),
                      width: (screenSize.width * 0.7),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorDark,
                          border: Border.all(
                            color: yipliNewBlue,
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.center,
                              child: title,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: content,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: updateButton,
                          ),
                        ],
                      )),
                ),
              )
            : CupertinoAlertDialog(
                title: title,
                content: content,
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: dismissText,
                    onPressed: dismissAction,
                  ),
                  CupertinoDialogAction(
                    child: updateText,
                    onPressed: updateAction,
                  ),
                ],
              );
      },
    );
  }

  void showCompulsoryUpdate(
    VersionStatus versionStatus,
  ) {
    final title = Text(dialogTitle,
        style: Theme.of(context)
            .textTheme
            .headline5
            .copyWith(color: yipliNewBlue));
    final content = Text(
        this.dialogText ??
            'Update to the latest version is recommended for better experience.',
        style: Theme.of(context).textTheme.subtitle1,
        textAlign: TextAlign.center);
    final dismissText = Text(this.dismissText);
    final dismissAction = this.dismissAction ??
        () => Navigator.of(context, rootNavigator: false).pop();
    final updateText = Text(this.updateText);
    final updateAction = () {
      _launchAppStore(versionStatus.appStoreLink);
    };
    final platform = Theme.of(context).platform;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        Size screenSize = MediaQuery.of(context).size;
        YipliButton updateButton;
        updateButton = new YipliButton(
          'Update',
          null,
          null,
          screenSize.width / 4,
        );
        updateButton.setClickHandler(updateAction);
        return platform == TargetPlatform.android
            ? Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: TweenAnimationBuilder(
                  tween: _scaleTween,
                  curve: Curves.easeIn,
                  duration: Duration(milliseconds: 600),
                  builder: (context, scale, child) {
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: Container(
                      height: (screenSize.height / 4),
                      width: (screenSize.width * 0.7),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorDark,
                          border: Border.all(
                            color: yipliNewBlue,
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.center,
                              child: title,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: content,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: updateButton,
                          ),
                        ],
                      )),
                ),
              )
            : CupertinoAlertDialog(
                title: title,
                content: content,
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: dismissText,
                    onPressed: dismissAction,
                  ),
                  CupertinoDialogAction(
                    child: updateText,
                    onPressed: updateAction,
                  ),
                ],
              );
      },
    );
  }

  /// Launches the Apple App Store or Google Play Store page for the app.
  void _launchAppStore(String appStoreLink) async {
    if (await canLaunch(appStoreLink)) {
      await launch(appStoreLink);
    } else {
      throw 'Could not launch App Store Link';
    }
  }
}

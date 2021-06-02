import 'package:flare_flutter/flare_actor.dart';

import 'a_pages_index.dart';

class RegisterMatPage extends StatefulWidget {
  static const String routeName = "/register_mat";

  @override
  State<StatefulWidget> createState() => new _RegisterMatPageState();
}

class _RegisterMatPageState extends State<RegisterMatPage> {
  String scannedValue;

  @override
  Widget build(BuildContext context) {
    bool isOnboardingFlow = ModalRoute.of(context).settings.arguments;

    return YipliPageFrame(
      selectedIndex: 0,
      title: Text(
        'Add Mat',
      ),
      child: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: Text(
                      'Let\'s get your mat registered!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: (MediaQuery.of(context).size.width * 0.2)),
              child: Column(
                children: <Widget>[
                  YipliUtils.buildBigButton(context,
                      icon: FontAwesomeIcons.keyboard,
                      text: "Enter Manually",
                      text2: "", onTappedFunction: () {
                    print("Clicked!");
                    scannedValue = null;
                    MatPageArguments matPageArgs = new MatPageArguments(
                        macAddress: scannedValue,
                        isOnboardingFlow: isOnboardingFlow);
                    YipliUtils.goToAddMatScreen(args: matPageArgs);
                  }),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Or",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                    child: YipliUtils.buildVeryBigButton(context,
                        icon: FontAwesomeIcons.camera,
                        text: "Scan QR Code",
                        text2: " ",
                        infoText: "Turn your Mat for QR code",
                        anim: Container(
                          decoration: BoxDecoration(
                            color: yipliBlack,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: FlareActor(
                            "assets/flare/scan_mat.flr",
                            fit: BoxFit.scaleDown,
                            animation: "scan",
                          ),
                        ), onTappedFunction: () async {
                      print('Register mat clicked');

                      ScanResult scannedValueFromPlugin =
                          await BarcodeScanner.scan();
                      print("NAVIN code");

                      setState(() {
                        print(scannedValueFromPlugin);
                        print('Setting value to the variable!');
                        scannedValue = scannedValueFromPlugin.rawContent;
                        print(scannedValue);
                        MatPageArguments matPageArgs = new MatPageArguments(
                            macAddress: scannedValue,
                            isOnboardingFlow: isOnboardingFlow);
                        YipliUtils.goToAddMatScreen(args: matPageArgs);
                      });
                    }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 4,
                  child: Container(
                    child: Text(
                      'Just 1 step away to ',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    child: RubberBand(
                      child: Image.asset(YipliAssets.yipliLogoPath,
                          fit: BoxFit.contain,
                          height: MediaQuery.of(context).size.height / 10),
                      preferences: AnimationPreferences(
                        offset: Duration(seconds: 1),
                        autoPlay: AnimationPlayStates.Forward,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    child: Text(
                      'gaming!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

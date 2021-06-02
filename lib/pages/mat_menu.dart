import 'package:feature_discovery/feature_discovery.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/classes/arguments/PageArgumentsClasses.dart';
import 'package:flutter_app/helpers/color_scheme.dart';
import 'package:flutter_app/helpers/constants.dart';
import 'package:flutter_app/helpers/utils.dart';
import 'package:flutter_app/page_models/mat_model.dart';
import 'package:flutter_app/pages/games_page.dart';
import 'package:flutter_app/pages/register_mat.dart';
import 'package:flutter_app/pages/yipli_page_frame.dart';
import 'package:flutter_app/widgets/mat_list_item.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class MatMenuPage extends StatefulWidget {
  static const String routeName = "/mat_menu";
  final bool bIsUserAddingNewPlayer;

  const MatMenuPage({Key key, this.bIsUserAddingNewPlayer = false})
      : super(key: key);

  @override
  _MatMenuPageState createState() => _MatMenuPageState();
}

class _MatMenuPageState extends State<MatMenuPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FeatureDiscovery.discoverFeatures(
        context,
        {YipliConstants.featureDiscoveryAddNewMatId},
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return YipliPageFrame(
        toShowBottomBar: true,
        title: Text(
          'My Mats',
          style: Theme.of(context).textTheme.headline6,
        ),
        widgetOnAppBar: addMatWidgetOnAppBar(),
        child: Stack(
          children: <Widget>[
            ChangeNotifierProvider<MatsModel>(
              create: (matsModelCtx) {
                MatsModel matsModel = MatsModel.initialize();
                return matsModel;
              },
              child: Consumer<MatsModel>(
                builder: (matsModelConsumerCtx, matsModel, child) {
                  if (YipliUtils.appConnectionStatus ==
                      AppConnectionStatus.DISCONNECTED) {
                    return YipliLoaderMini(
                      loadingMessage: "Loading Mats ... ",
                    );
                  }
                  if (YipliUtils.appConnectionStatus ==
                          AppConnectionStatus.DISCONNECTED &&
                      matsModel.allMats.length == 0) {
                    print('Mat length: ${matsModel.allMats.length}');
                    return YipliLoaderMini(
                      loadingMessage: "Loading Mats ... ",
                    );
                  }

                  if (YipliUtils.appConnectionStatus ==
                          AppConnectionStatus.CONNECTED &&
                      matsModel.allMats.length == 0) {
                    return Center(
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.0),
                          child: Text(
                              'No Mat added. \nAdd atleast 1 mat to start Yipli Gaming.',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                // decoration: BoxDecoration(
                                // border: Border.all(
                                //   width: 0.5,
                                //   color: yipliWhite,
                                // ),
                                // borderRadius:
                                //     BorderRadius.all(Radius.circular(5.0)),
                                // ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: FlareActor(
                                          "assets/flare/bluetooth.flr",
                                          fit: BoxFit.fill,
                                          animation: "pulse",
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Center(
                                        child: Text(
                                          'No pairing required. Just switch on the mat and launch the game to play.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(color: yipliGray),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: ListView.builder(
                                itemCount: matsModel.allMats.length + 1,
                                itemBuilder: (matsListCtx, currentIndex) {
                                  Widget widgetToAdd =
                                      (currentIndex < matsModel.allMats.length)
                                          ? MatListItem(
                                              matMacAddress: matsModel
                                                  .allMats[currentIndex]
                                                  .macAddress,
                                              matName: matsModel
                                                  .allMats[currentIndex]
                                                  .displayName,
                                              isSelected: false,
                                              matId: matsModel
                                                  .allMats[currentIndex].matId,
                                            )
                                          : SizedBox(
                                              height: ((MediaQuery.of(context)
                                                          .size
                                                          .height -
                                                      112) /
                                                  6));

                                  return AnimationConfiguration.staggeredList(
                                      delay: Duration(milliseconds: 120),
                                      position: currentIndex,
                                      duration:
                                          const Duration(milliseconds: 600),
                                      child: SlideAnimation(
                                        //delay: Duration(milliseconds: 120),
                                        verticalOffset: 50.0,
                                        child:
                                            FadeInAnimation(child: widgetToAdd),
                                      ));
                                }),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ));
  }

  Widget addMatWidgetOnAppBar() {
    return FlatButton(
        focusColor: androidTVFocusColor,
        onPressed: () async {
          if (YipliUtils.appConnectionStatus == AppConnectionStatus.CONNECTED) {
            YipliUtils.gotoRegisterMatPage();
          } else {
            YipliUtils.showNotification(
                context: context,
                msg: "Internet connection required to Add Mat",
                type: SnackbarMessageTypes.ERROR);
          }
        },
        //This is causing hang issue on click of '+'
        //   child: DescribedFeatureOverlay(
        //       featureId: YipliConstants.featureDiscoveryAddNewMatId,
        //       tapTarget: Icon(Icons.add, color: Theme.of(context).accentColor),
        //       title: Text('Add Mat'),
        //       description: Text('\nAdd a new mat to begin playing!'),
        //       backgroundColor: Theme.of(context).accentColor,
        //       contentLocation: ContentLocation.below,
        child: Icon(Icons.add, color: Theme.of(context).accentColor)
        //  ),
        );
  }
}

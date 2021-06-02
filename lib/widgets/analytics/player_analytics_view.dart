import 'package:async/async.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/classes/classes_index.dart';
import 'package:flutter_app/pages/a_pages_index.dart';
import 'package:intl/intl.dart';

import '../a_widgets_index.dart';

class PlayerAnalyticsView extends StatefulWidget {
  final int noOfBarsInView;
  final String playerIdFromArgument;
  final int lastPlayedTimestampForPlayer;

  const PlayerAnalyticsView(
      this.playerIdFromArgument, this.lastPlayedTimestampForPlayer,
      {this.noOfBarsInView = 7});

  @override
  _PlayerAnalyticsViewState createState() => _PlayerAnalyticsViewState();
}

enum PlayerAnalyticsDuration { DAILY, WEEKLY }

class _PlayerAnalyticsViewState extends State<PlayerAnalyticsView>
    with SingleTickerProviderStateMixin {
  var lDataToSetList;
  List<bool> isSelected;
  PlayerAnalyticsDuration currentSelection;
  List<BarChartGroupData> currentDataToShow;
  List<dynamic> currentGroupData;
  int touchedIndex;
  final Duration animDuration = const Duration(milliseconds: 250);
  bool isPlaying = false;
  CurrentPlayerModel currentPlayerModel;
  // PlayerDetails _playerProfileElements;
  DateTime playerLastPlayedDate;
  String userId;
  StreamGroup allStreamsGroup;
  int indexOfFirstBar = 0;

  @override
  void initState() {
    isSelected = [true, false];
    userId = AuthService.getCurrentUserId();
    currentSelection = PlayerAnalyticsDuration.DAILY;
    currentDataToShow = List();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (allStreamsGroup != null) {
      allStreamsGroup.close();
    }
  }

  ///get for X axis fot daily, weekly
  List<dynamic> getXAxisData() {
    switch (currentSelection) {

      ///for daily get x axis data
      case PlayerAnalyticsDuration.DAILY:
        // TODO: Handle this case.
        //create datetime list
        List<DateTime> xAxisDataToReturn = List();

        for (var i = indexOfFirstBar;
            i < widget.noOfBarsInView + indexOfFirstBar;
            i++) {
          DateTime dateToAdd = playerLastPlayedDate.subtract(i.days);
          xAxisDataToReturn.add(dateToAdd);
        }
        return xAxisDataToReturn;

      ///for weekly get x axis data
      case PlayerAnalyticsDuration.WEEKLY:
        // TODO: Handle this case.
        //get datetime list
        List<AnalyticsWeekData> xAxisDataToReturn = List();

        for (var i = indexOfFirstBar;
            i < widget.noOfBarsInView + indexOfFirstBar;
            i++) {
          DateTime previousWeekDateTime =
              Jiffy(playerLastPlayedDate).subtract(weeks: i);
          int previousPlayedWeek = Jiffy(previousWeekDateTime).week;
          AnalyticsWeekData analyticsWeekData = AnalyticsWeekData(
              week: previousPlayedWeek, year: previousWeekDateTime.year);
          // print('AnalyticsWeekData - ${(analyticsWeekData).toString()}');
          xAxisDataToReturn.add(analyticsWeekData);
        }
        return xAxisDataToReturn;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    currentPlayerModel = Provider.of<CurrentPlayerModel>(context);
    int currentPlayerLastPlayedTimestamp =
        currentPlayerModel.player.activityStats.iLastPlayedTimestamp;
    widget.lastPlayedTimestampForPlayer == null
        ? playerLastPlayedDate = new DateTime.fromMillisecondsSinceEpoch(
            currentPlayerLastPlayedTimestamp)
        : playerLastPlayedDate = new DateTime.fromMillisecondsSinceEpoch(
            widget.lastPlayedTimestampForPlayer);

    return Column(
      children: <Widget>[
        ///tabbar buttons
        SizedBox(
          height: 42,
          width: screenSize.width,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ToggleButtons(
                  selectedBorderColor: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(10.0),
                  selectedColor: Theme.of(context).accentColor,
                  disabledBorderColor: Theme.of(context).accentColor,
                  borderColor: Theme.of(context).accentColor,
                  fillColor: Theme.of(context).accentColor,
                  color: Theme.of(context).primaryColor,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: screenSize.width * 0.175),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(48.0)),
                      ),
                      child: Text(
                        "Day",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: screenSize.width * 0.175),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(48.0)),
                      ),
                      child: Text(
                        "Week",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ],
                  focusColor: androidTVFocusColor,
                  onPressed: (int index) {
                    setState(() {
                      for (int buttonIndex = 0;
                          buttonIndex < isSelected.length;
                          buttonIndex++) {
                        if (buttonIndex == index) {
                          isSelected[buttonIndex] = true;
                        } else {
                          isSelected[buttonIndex] = false;
                        }
                      }
                      setCurrentSelectedDuration();
                    });
                  },
                  isSelected: isSelected,
                ),
              ],
            ),
          ),
        ),

        ///bar data card
        SizedBox(
            height: screenSize.height * (400 / 683),
            width: screenSize.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  ClipRRect(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Theme.of(context)
                          .primaryColor, //const Color(0xff81e5cd),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20.0),

                        ///using stream builder to get data as snapshot
                        child: StreamBuilder(
                            stream: getStreamForSelectedPlayerDuration(),
                            builder: (context, snapshot) {
                              print(
                                  "---------------------- GOT NEW DATA! --------------------");
                              //  print("snapshot- $snapshot");
                              print(
                                  "DATA --${(snapshot.data as List)?.length ?? 'KAHI NAHI MILALA!!'}");
                              currentDataToShow =
                                  processAndSetEventsDataForChart(
                                      snapshot.data);

                              return BarChart(
                                isPlaying ? randomData() : mainBarData(),
                                swapAnimationDuration: animDuration,
                              );
                            }),
                      ),
                    ),
                  ),

                  ///left move icon
                  Positioned(
                    left: 2,
                    bottom: 180,
                    child:

                        /// TODO : change 30 to first played date logic
                        (indexOfFirstBar >= 30)
                            ? IconButton(
                                focusColor: androidTVFocusColor,
                                onPressed: () {},
                                icon: Icon(
                                  null,
                                ),
                              )
                            : IconButton(
                                focusColor: androidTVFocusColor,
                                icon: Icon(
                                  FontAwesomeIcons.chevronLeft,
                                  size: 18.0,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                                onPressed: () {
                                  setState(() {
                                    //on tap animation
                                    isPlaying = !isPlaying;
                                    if (isPlaying) {
                                      refreshState();
                                    }

                                    //shift index of the x axis
                                    indexOfFirstBar =
                                        indexOfFirstBar + widget.noOfBarsInView;
                                    print(
                                        'indexOfFirstBar left - $indexOfFirstBar');
                                  });
                                }),
                  ),

                  ///right move icon
                  Positioned(
                    right: 2,
                    bottom: 180,
                    child: indexOfFirstBar == 0
                        ? IconButton(
                            focusColor: androidTVFocusColor,
                            icon: Icon(null),
                            onPressed: () {},
                          )
                        : IconButton(
                            focusColor: androidTVFocusColor,
                            icon: Icon(
                              FontAwesomeIcons.chevronRight,
                              size: 18.0,
                              color: Theme.of(context).primaryColorLight,
                            ),
                            onPressed: () {
                              setState(() {
                                //on tap animation
                                isPlaying = !isPlaying;
                                if (isPlaying) {
                                  refreshState();
                                }

                                if (indexOfFirstBar >= 7)
                                  indexOfFirstBar =
                                      indexOfFirstBar - widget.noOfBarsInView;
                                print(
                                    'indexOfFirstBar right - $indexOfFirstBar');
                              });
                            }),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  ///main data on bar with tool tip
  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: yipliLogoOrange, //Colors.blueGrey,
            ///getting data based on the index user touches
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              print(
                  'group - group index - rod - rod index - $group $groupIndex, $rod $rodIndex');

              ///calculating player fp
              var fitnessPoints = NumberFormat.compact().format(rod.y);
              var fitnessPointsString = fitnessPoints.toString();

              ///calculating Calories
              var playerCalories = NumberFormat.compact()
                  .format(lDataToSetList[groupIndex].value.playerCaloriesData);
              var playerCaloriesString = playerCalories.toString();
              // print('fitness cal - $playerCaloriesString');

              ///get tooltip for player fp and calories
              return BarTooltipItem(
                  'Fp - $fitnessPointsString' + '\nCal - $playerCaloriesString',
                  TextStyle(color: Theme.of(context).primaryColor));
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
              print('current show - ${currentDataToShow[touchedIndex].x}');
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
          margin: 16,
          getTitles: (double value) {
            switch (currentSelection) {

              ///get daily bar x axis data
              case PlayerAnalyticsDuration.DAILY:
                // TODO: Handle this case.
                if ((value ?? 0.0) > 7.0) {
                  DateTime xDateTime =
                      DateTime.fromMillisecondsSinceEpoch(value.toInt());
                  return Jiffy(xDateTime).format("MMM dd");
                }
                break;

              ///weekly bar x axis data
              case PlayerAnalyticsDuration.WEEKLY:
                // TODO: Handle this case.
                //print('value in int - ${value.toInt()}');
                dynamic element = currentGroupData[value.toInt()];
                //  print('element - $element');
                int elementWeekNo = element["weekNo"];
                int elementYear = element["year"];
                //print('week no and year - $elementWeekNo $elementYear');
                if ((value ?? 0.0) < 7.0) {
                  DateTime startDate = getDateByWeekNumber(
                      elementWeekNo: elementWeekNo,
                      elementYear: elementYear,
                      start: true);
                  return Jiffy(startDate).format("dd MMM");
                }
                break;
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: currentDataToShow,
    );
  }

  /// calculating current index based on user input
  void setCurrentSelectedDuration() {
    isSelected.forEachIndexed((index, element) {
      if (element == true) {
        switch (index) {
          case 1:
            currentSelection = PlayerAnalyticsDuration.WEEKLY;
            break;
          default:
            currentSelection = PlayerAnalyticsDuration.DAILY;
            break;
        }
      }
    });
  }

  Stream getStreamForSelectedPlayerDuration() {
    switch (currentSelection) {

      /// stream for DB ref - daily
      case PlayerAnalyticsDuration.DAILY:
        List<Stream> allStreams = [];
        getXAxisData().forEachIndexed((index, currentDateTime) {
          DatabaseReference dbDailyRef = FirebaseDatabaseUtil()
              .rootRef
              .child("user-stats")
              .child(userId)
              .child(widget.playerIdFromArgument)
              .child("d")
              .child(currentDateTime.year.toString())
              .child((currentDateTime.month - 1).toString())
              .child(currentDateTime.day.toString());
          //print("DB REF daily: ${dbDailyRef.path}");
          Stream dayDataStreamForPlayer = dbDailyRef.onValue
              .map((event) => {"date": currentDateTime, "event": event});

          allStreams.add(dayDataStreamForPlayer);
        });

        return StreamZip(allStreams).asBroadcastStream();

      /// stream for DB ref - weekly
      case PlayerAnalyticsDuration.WEEKLY:
        List<Stream> allStreams = [];
        getXAxisData().forEachIndexed((index, currentAnalyticsWeekData) {
          DatabaseReference dbWeeklyRef = FirebaseDatabaseUtil()
              .rootRef
              .child("user-stats")
              .child(userId)
              .child(widget.playerIdFromArgument)
              .child("w")
              .child(currentAnalyticsWeekData.year.toString())
              .child(currentAnalyticsWeekData.week.toString());

          //   print("DB REF: ${dbWeeklyRef.path}");
          Stream dayDataStreamForPlayer = dbWeeklyRef.onValue.map((event) => {
                "weekNo": currentAnalyticsWeekData.week,
                "event": event,
                "year": currentAnalyticsWeekData.year
              });

          allStreams.add(dayDataStreamForPlayer);
        });

        return StreamZip(allStreams).asBroadcastStream();
        break;
    }
  }

  ///creating list for daily fp points
  List processAndSetEventsDataForChart(List<dynamic> data) {
    switch (currentSelection) {

      /// based on current selection get data - event driven
      case PlayerAnalyticsDuration.DAILY:
        // TODO: Handle this case.
        //return an empty list
        List<BarChartGroupData> listToReturn = [];
        //map new int(index) playerData(fp and c)
        Map<int, PlayerData> mDataToSet = new Map<int, PlayerData>();
        double maxY = 0.0;
        data?.reversed?.forEachIndexed((index, element) {
          PlayerData playerData = new PlayerData();

          //get y axis fP data
          playerData.yAxisData =
              (((element["event"] as Event)?.snapshot?.value ??
                          {"fp": 0.0})["fp"]
                      .toDouble() ??
                  0.0);

          // print('player data y - ${playerData.yAxisData}');
          //get player calories
          playerData.playerCaloriesData =
              ((element["event"] as Event)?.snapshot?.value ?? {"c": 0.0})["c"]
                      .toDouble() ??
                  0.0;
          //print('player data z - ${playerData.playerCaloriesData}');

          maxY = max(playerData.yAxisData, maxY);
          // get player data map
          mDataToSet[(element["date"] as DateTime)?.millisecondsSinceEpoch ??
              0] = playerData;
        });
        if (maxY == 0.0) {
          maxY = 10.0;
        }
        //mapping player data map into list
        lDataToSetList = mDataToSet.entries.toList();
        mDataToSet.forEach((x, y) {
          var dataPoint = BarChartGroupData(
            x: x,
            barRods: [
              BarChartRodData(
                y: y.yAxisData,
                width: 22,
                color: yipliLogoBlue,
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  y: maxY * 1.5,
                  color: appbackgroundcolor, //barBackgroundColor,
                ),
              ),
            ],
          );
          listToReturn.add(dataPoint);
        });
        return listToReturn;

      case PlayerAnalyticsDuration.WEEKLY:
        // TODO: Handle this case.
        //return an empty list
        List<BarChartGroupData> listToReturn = [];
        double maxY = 0.0;
        //map new int(index) playerData(fp and c)
        //Map<int, double> dataToSet = Map();
        Map<int, PlayerData> mDataToSet = new Map<int, PlayerData>();
        currentGroupData = [];
        data?.reversed?.forEachIndexed((index, element) {
          PlayerData playerData = new PlayerData();
          //get y axis fP data
          playerData.yAxisData =
              ((element["event"] as Event)?.snapshot?.value ??
                          {"fp": 0.0})["fp"]
                      .toDouble() ??
                  0.0;
          // print('player data y week - ${playerData.yAxisData}');
          //get player calories
          playerData.playerCaloriesData =
              ((element["event"] as Event)?.snapshot?.value ?? {"c": 0.0})["c"]
                      .toDouble() ??
                  0.0;
          //print('player data z week - ${playerData.playerCaloriesData}');

          maxY = max(playerData.yAxisData, maxY);
          // get player data map
          mDataToSet[index] = playerData;
          currentGroupData.add(element);
        });
        if (maxY == 0.0) {
          maxY = 10.0;
        }
        // print('printing data for week $mDataToSet');
        //mapping player data map into list
        lDataToSetList = mDataToSet.entries.toList();
        mDataToSet.forEach((x, y) {
          var dataPoint = BarChartGroupData(
            x: x,
            barRods: [
              BarChartRodData(
                y: y.yAxisData,
                width: 22,
                color: yipliLogoBlue,
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  y: maxY * 1.2,
                  color: appbackgroundcolor, //barBackgroundColor,
                ),
              ),
            ],
          );
          listToReturn.add(dataPoint);
        });
        return listToReturn;

        break;
    }
  }

  DateTime getDateByWeekNumber(
      {int elementWeekNo, int elementYear, bool start}) {
    //check if start == true retrun start date of week
    //else return end date
    var days = ((elementWeekNo - 1) * 7) + (start ? 0 : 6);
    return DateTime.utc(elementYear, 1, days - 1);
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 10));
    if (isPlaying) {
      refreshState();
      isPlaying = false;
    }
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          color: isTouched ? Colors.yellow : barColor,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 20,
            color: appbackgroundcolor,
          ),
        ),
      ],
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          margin: 16,
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, Random().nextInt(20).toDouble(),
                barColor: yipliLogoOrange);
          case 1:
            return makeGroupData(1, Random().nextInt(15).toDouble(),
                barColor: yipliLogoOrange);
          case 2:
            return makeGroupData(2, Random().nextInt(40).toDouble(),
                barColor: yipliLogoOrange);
          case 3:
            return makeGroupData(3, Random().nextInt(15).toDouble(),
                barColor: yipliLogoOrange);
          case 4:
            return makeGroupData(4, Random().nextInt(30).toDouble(),
                barColor: yipliLogoOrange);
          case 5:
            return makeGroupData(5, Random().nextInt(15).toDouble(),
                barColor: yipliLogoOrange);
          case 6:
            return makeGroupData(6, Random().nextInt(15).toDouble(),
                barColor: yipliLogoOrange);
          default:
            return null;
        }
      }),
    );
  }
}

class AnalyticsWeekData {
  int week;
  int year;

  AnalyticsWeekData({this.week, this.year});

  @override
  String toString() {
    return 'AnalyticsWeekData{week: $week, year: $year}';
  }
}

class PlayerData {
  double yAxisData;
  double playerCaloriesData;
}

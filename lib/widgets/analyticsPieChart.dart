/// Donut chart example. This is a simple pie chart with a hole in the middle.
import 'package:charts_flutter/flutter.dart' as charts;

import 'a_widgets_index.dart';

enum PlayerAnalyticsPropertyType {
  fitnessPoints,
  calories,
  duration,
  intensity
}

class AnalyticsPieChart extends StatelessWidget {
  final IconData icon;
  final PlayerAnalyticsPropertyType property;
  List<PieChartData> pieChartInputData = new List<PieChartData>();

  AnalyticsPieChart({this.icon, this.property});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerAnalyticsSelectionStateModel>(
      builder: (context, playerProfileState, child) {
        return Stack(children: <Widget>[
          charts.PieChart(
              createDataFromFitnessData(playerProfileState, property),
              layoutConfig: charts.LayoutConfig(
                  leftMarginSpec: charts.MarginSpec.fixedPixel(0),
                  topMarginSpec: charts.MarginSpec.fixedPixel(0),
                  rightMarginSpec: charts.MarginSpec.fixedPixel(0),
                  bottomMarginSpec: charts.MarginSpec.fixedPixel(0)),
              animate: true,

              // Configure the width of the pie slices to 60px. The remaining space in
              // the chart will be left as a hole in the center.
              defaultRenderer: new charts.ArcRendererConfig(
                arcWidth: 6,
              )),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Icon(
                    icon,
                    color: Theme.of(context).accentColor,
                    //  size: 22.0,
                  ),
                ),
                Text(
                  pieChartInputData[0].dataValue.toString(),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  property == PlayerAnalyticsPropertyType.intensity
                      ? "Intensity"
                      : (property == PlayerAnalyticsPropertyType.duration
                          ? "Duration"
                          : (property == PlayerAnalyticsPropertyType.calories
                              ? "Calories"
                              : "")),
                  style: Theme.of(context).textTheme.overline.copyWith(
                        letterSpacing: 0,
                      ),
                )
              ],
            ),
          ),
        ]);
      },
    );
  }

  List<charts.Series<PieChartData, int>> createDataFromFitnessData(
      PlayerAnalyticsSelectionStateModel playerProfileStateModel,
      PlayerAnalyticsPropertyType property) {
    //Parameters for checking Targets
    int iTargetCalories;
    int iTargetDuration;
    double dTargetIntensity = 4.0;

    var displayData;

    if (playerProfileStateModel.frequency == AnalyticsFrequency.daily) {
      displayData = playerProfileStateModel.selectedDaySessionData;
      iTargetCalories = 1000;
      iTargetDuration = 1800;
    } else if (playerProfileStateModel.frequency == AnalyticsFrequency.weekly) {
      displayData = playerProfileStateModel.selectedWeekSessionData;
      iTargetCalories = 6000;
      iTargetDuration = 10000;
    } else if (playerProfileStateModel.frequency ==
        AnalyticsFrequency.monthly) {
      iTargetCalories = 22000;
      iTargetDuration = 40000;
      displayData = playerProfileStateModel.selectedMonthSessionData;
    }

    if (property == PlayerAnalyticsPropertyType.calories) {
      if (iTargetCalories > displayData.calories) {
        // check if the Calories Target is met or not
        pieChartInputData = [
          new PieChartData(0, displayData.calories),
          new PieChartData(1, (iTargetCalories - displayData.calories)),
        ];
      } else {
        //Target met, so show only one item in donought pic chart, which fills the entire circle.
        pieChartInputData = [
          new PieChartData(0, displayData.calories),
        ];
      }
    } else if (property == PlayerAnalyticsPropertyType.duration) {
      // check if the duration Target is met or not
      if (iTargetDuration > int.parse(displayData.duration)) {
        pieChartInputData = [
          new PieChartData(0, int.parse(displayData.duration)),
          new PieChartData(
              1, iTargetDuration - int.parse(displayData.duration)),
        ];
      } else {
        //Target met, so show only one item in donought pic chart, which fills the entire circle.
        pieChartInputData = [
          new PieChartData(0, int.parse(displayData.duration)),
        ];
      }
    } else if (property == PlayerAnalyticsPropertyType.intensity) {
      double intensity = displayData.intensity;

      // print("Total avg intensity : $intensity");
      // check if the duration Target is met or not
      if (dTargetIntensity > intensity) {
        pieChartInputData = [
          new PieChartData(0, intensity),
          new PieChartData(1, dTargetIntensity - intensity),
        ];
      } else {
        pieChartInputData = [
          new PieChartData(0, intensity),
        ];
      }
    }

    return [
      new charts.Series<PieChartData, int>(
        id: 'Pie Data',
        //areaColorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        //seriesColor: charts.MaterialPalette.red.shadeDefault,
        /*   colorFn: (data, currentIndex) {
          return currentIndex == 0
              ? charts.MaterialPalette.red.shadeDefault
              : charts.MaterialPalette.red.makeShades(4)[3];
        },*/
        colorFn: (data, currentIndex) {
          return currentIndex == 0
              ? accentChartColor
              : charts.MaterialPalette.white;
        },

        //fillColorFn: (_, __) => charts.MaterialPalette.white,
        domainFn: (PieChartData data, _) => data.index,
        measureFn: (PieChartData data, _) => data.dataValue,
        data: pieChartInputData,
      )
    ];
  }
}

class PieChartData {
  int index;
  var dataValue;
  PieChartData(this.index, this.dataValue);
}

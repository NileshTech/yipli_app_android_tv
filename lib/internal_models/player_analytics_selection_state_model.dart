import 'package:flutter/cupertino.dart';
import 'package:flutter_app/classes/PlayerGameSessionDataClasses.dart';

enum AnalyticsFrequency { daily, weekly, monthly }

class PlayerAnalyticsSelectionStateModel extends ChangeNotifier {
  DailyDataEntry selectedDaySessionData;
  WeeklyDataEntry selectedWeekSessionData;
  MonthlyDataEntry selectedMonthSessionData;
  AnalyticsFrequency frequency;

  PlayerAnalyticsSelectionStateModel();

  PlayerAnalyticsSelectionStateModel.daily(this.selectedDaySessionData);

  PlayerAnalyticsSelectionStateModel.weekly(this.selectedWeekSessionData);

  PlayerAnalyticsSelectionStateModel.monthly(this.selectedMonthSessionData);

  setSelectedDaySessionData(
      DailyDataEntry changedSessionData, AnalyticsFrequency freq) {
    frequency = freq;
    selectedDaySessionData = changedSessionData;
    selectedWeekSessionData = null;
    selectedMonthSessionData = null;
    notifyListeners();
  }

  setSelectedWeekSessionData(
      WeeklyDataEntry changedSessionData, AnalyticsFrequency freq) {
    frequency = freq;
    selectedWeekSessionData = changedSessionData;
    selectedDaySessionData = null;
    selectedMonthSessionData = null;
    notifyListeners();
  }

  setSelectedMonthSessionData(
      MonthlyDataEntry changedSessionData, AnalyticsFrequency freq) {
    frequency = freq;
    selectedMonthSessionData = changedSessionData;
    selectedWeekSessionData = null;
    selectedDaySessionData = null;
    notifyListeners();
  }
}

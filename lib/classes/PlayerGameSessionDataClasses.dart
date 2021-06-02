class PlayerGameSessionData {
  String age;
  double fitnessPoints;
  int calories;
  String duration;
  String intensity;
  String gameId;

  PlayerGameSessionData(
      {this.age,
      this.fitnessPoints,
      this.calories,
      this.duration,
      this.intensity,
      this.gameId});
}

class DataEntry {
  double fitnessPoints;
  int calories;
  String duration;
  DateTime startDate;
  DateTime endDate;
  double intensity;

  DataEntry(this.fitnessPoints, this.duration, this.calories, this.intensity,
      [this.startDate, this.endDate]);
}

class DailyDataEntry {
  DateTime startDate;
  double fitnessPoints;
  int calories;
  String duration;
  double intensity;

  DailyDataEntry(this.startDate, this.fitnessPoints, this.duration,
      this.calories, this.intensity);
}

class WeeklyDataEntry {
  int weekOfYear;
  DateTime startDate;
  DateTime endDateOfWeek;
  double fitnessPoints;
  int calories;
  String duration;
  double intensity;

  WeeklyDataEntry(this.weekOfYear, this.fitnessPoints, this.duration,
      this.calories, this.intensity, this.startDate, this.endDateOfWeek);
}

class MonthlyDataEntry {
  int iMonthOfYear;
  DateTime startDate;
  DateTime endDateOfMonth;
  double fitnessPoints;
  int calories;
  String duration;
  double intensity;

  MonthlyDataEntry(this.iMonthOfYear, this.startDate, this.endDateOfMonth,
      this.fitnessPoints, this.duration, this.calories, this.intensity);
}

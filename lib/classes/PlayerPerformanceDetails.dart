class LastWeekPerformance {
  int iFitnessPoints = 0;
  int iDuration = 0;
  int iCaloriesBurnt = 0;

  LastWeekPerformance(
      [this.iFitnessPoints, this.iDuration, this.iCaloriesBurnt]);
}

class LastMonthPerformance {
  int iFitnessPoints = 0;
  int iDuration = 0;
  int iCaloriesBurnt = 0;
  LastMonthPerformance(
      [this.iFitnessPoints, this.iDuration, this.iCaloriesBurnt]);
}

class PlayerPerformanceDetails {
  LastWeekPerformance lastWeekPerformance = new LastWeekPerformance(0, 0, 0);
  LastMonthPerformance lastMonthPerformance = new LastMonthPerformance(0, 0, 0);
}

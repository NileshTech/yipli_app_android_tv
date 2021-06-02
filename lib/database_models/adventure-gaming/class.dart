import 'dart:convert';

import 'battle_zone.dart';
import 'challenge_zone.dart';
import 'route_1.dart';
import 'route_2.dart';
import 'victory_zone.dart';

class AdventureGamingClassDetails {
  final BattleZone battleZone;
  final ChallengeZone challengeZone;
  final int intensityLevel;
  final Route1 route1;
  final Route2 route2;
  final VictoryZone victoryZone;
  final int minimumFp;
  final int minimumXp;
  AdventureGamingClassDetails({
    this.battleZone,
    this.challengeZone,
    this.intensityLevel,
    this.route1,
    this.route2,
    this.victoryZone,
    this.minimumFp,
    this.minimumXp,
  });

  AdventureGamingClassDetails copyWith(
      {BattleZone battleZone,
      ChallengeZone challengeZone,
      List<int> fitnessCards,
      int intensityLevel,
      Route1 route1,
      Route2 route2,
      int targetCaloriesToBeBurnt,
      int totalTime,
      VictoryZone victoryZone,
      int minimumFp,
      int minimumXp}) {
    return AdventureGamingClassDetails(
      battleZone: battleZone ?? this.battleZone,
      challengeZone: challengeZone ?? this.challengeZone,
      intensityLevel: intensityLevel ?? this.intensityLevel,
      route1: route1 ?? this.route1,
      route2: route2 ?? this.route2,
      victoryZone: victoryZone ?? this.victoryZone,
      minimumFp: minimumFp ?? this.minimumFp,
      minimumXp: minimumXp ?? this.minimumXp,
    );
  }

  factory AdventureGamingClassDetails.fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;

    return AdventureGamingClassDetails(
        battleZone: BattleZone.fromMap(map),
        challengeZone: ChallengeZone.fromMap(map),
        intensityLevel: 1, // map['intensity-level'],
        route1: Route1.fromMap(map),
        route2: Route2.fromMap(map),
        victoryZone: VictoryZone.fromMap(map),
        minimumFp: map['MinimumFP'],
        minimumXp: map['MinimumXP']);
  }

  factory AdventureGamingClassDetails.fromJson(String source) =>
      AdventureGamingClassDetails.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Adventure gaming class details(battleZone: $battleZone, challengeZone: $challengeZone, intensityLevel: $intensityLevel, route1: $route1, route2: $route2, victoryZone: $victoryZone)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AdventureGamingClassDetails &&
        o.battleZone == battleZone &&
        o.challengeZone == challengeZone &&
        o.intensityLevel == intensityLevel &&
        o.route1 == route1 &&
        o.route2 == route2 &&
        o.victoryZone == victoryZone &&
        o.minimumFp == minimumFp &&
        o.minimumXp == minimumXp;
  }

  @override
  int get hashCode {
    return battleZone.hashCode ^
        challengeZone.hashCode ^
        intensityLevel.hashCode ^
        route1.hashCode ^
        route2.hashCode ^
        victoryZone.hashCode ^
        minimumFp.hashCode ^
        minimumXp.hashCode;
  }
}

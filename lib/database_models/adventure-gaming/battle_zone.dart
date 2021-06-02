import 'dart:convert';

class BattleZone {
  final String playerAction;
  final int time;
  final int totalEnemies;
  BattleZone({
    this.playerAction,
    this.time,
    this.totalEnemies,
  });

  BattleZone copyWith({
    String playerAction,
    int time,
    int totalEnemies,
  }) {
    return BattleZone(
      playerAction: playerAction ?? this.playerAction,
      time: time ?? this.time,
      totalEnemies: totalEnemies ?? this.totalEnemies,
    );
  }

  factory BattleZone.fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;

    return BattleZone(
      playerAction: map['BattleZonePlayerAction'] ?? "",
      time: map['BattleZoneTime'] ?? "",
      totalEnemies: map['BattleZoneTotalEnemies'] ?? 0,
    );
  }

  factory BattleZone.fromJson(String source) =>
      BattleZone.fromMap(json.decode(source));

  @override
  String toString() =>
      'BattleZone(playerAction: $playerAction, time: $time, totalEnemies: $totalEnemies)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is BattleZone &&
        o.playerAction == playerAction &&
        o.time == time &&
        o.totalEnemies == totalEnemies;
  }

  @override
  int get hashCode =>
      playerAction.hashCode ^ time.hashCode ^ totalEnemies.hashCode;
}

import 'dart:convert';

class ChallengeZone {
  final int minActionCount;
  final String playerAction;
  final int time;
  ChallengeZone({
    this.minActionCount,
    this.playerAction,
    this.time,
  });

  ChallengeZone copyWith({
    int minActionCount,
    String playerAction,
    int time,
  }) {
    return ChallengeZone(
      minActionCount: minActionCount ?? this.minActionCount,
      playerAction: playerAction ?? this.playerAction,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ChallengeZoneMinActionCount': minActionCount,
      'ChallengeZonePlayerAction': playerAction,
      'ChallengeZoneTime': time,
    };
  }

  factory ChallengeZone.fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;

    return ChallengeZone(
      minActionCount: map['ChallengeZoneMinActionCount'],
      playerAction: map['ChallengeZonePlayerAction'],
      time: map['ChallengeZoneTime'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ChallengeZone.fromJson(String source) =>
      ChallengeZone.fromMap(json.decode(source));

  @override
  String toString() =>
      'ChallengeZone(minActionCount: $minActionCount, playerAction: $playerAction, time: $time)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ChallengeZone &&
        o.minActionCount == minActionCount &&
        o.playerAction == playerAction &&
        o.time == time;
  }

  @override
  int get hashCode =>
      minActionCount.hashCode ^ playerAction.hashCode ^ time.hashCode;
}

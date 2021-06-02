import 'dart:convert';

class VictoryZone {
  final String playerAction;
  final int time;
  final int timeOut;
  VictoryZone({
    this.playerAction,
    this.time,
    this.timeOut,
  });

  VictoryZone copyWith({
    String playerAction,
    int time,
    int timeOut,
  }) {
    return VictoryZone(
      playerAction: playerAction ?? this.playerAction,
      time: time ?? this.time,
      timeOut: timeOut ?? this.timeOut,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'VictoryZonePlayerAction': playerAction,
      'VictoryZoneTime': time,
      'VictoryZoneTimeOut': timeOut,
    };
  }

  factory VictoryZone.fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;

    return VictoryZone(
      playerAction: map['VictoryZonePlayerAction'],
      time: map['VictoryZoneTime']?.toInt(),
      timeOut: map['VictoryZoneTimeOut']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory VictoryZone.fromJson(String source) =>
      VictoryZone.fromMap(json.decode(source));

  @override
  String toString() =>
      'VictoryZone(playerAction: $playerAction, time: $time, timeOut: $timeOut)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is VictoryZone &&
        o.playerAction == playerAction &&
        o.time == time &&
        o.timeOut == timeOut;
  }

  @override
  int get hashCode => playerAction.hashCode ^ time.hashCode ^ timeOut.hashCode;
}

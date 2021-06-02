import 'dart:convert';

class PlayerLocalData {
  String playerId;

  PlayerLocalData({
    this.playerId,
  });

  PlayerLocalData copyWith({
    String playerId,
    bool hasWatchedVideo,
  }) {
    return PlayerLocalData(
      playerId: playerId ?? this.playerId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'playerId': playerId,
    };
  }

  factory PlayerLocalData.fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;

    return PlayerLocalData(
      playerId: map['playerId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PlayerLocalData.fromJson(String source) =>
      PlayerLocalData.fromMap(json.decode(source));

  @override
  String toString() => 'PlayerLocalData(playerId: $playerId)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PlayerLocalData && o.playerId == playerId;
  }

  @override
  int get hashCode => playerId.hashCode;
}

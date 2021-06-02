import 'dart:convert';

class Route2 {
  final int elevatedTerrains;
  final int highKnee;
  final int maxTime;
  final int runDistance;
  final int skierJack;
  final int waterAreas;
  Route2({
    this.elevatedTerrains,
    this.highKnee,
    this.maxTime,
    this.runDistance,
    this.skierJack,
    this.waterAreas,
  });

  Route2 copyWith({
    int elevatedTerrains,
    int highKnee,
    int jumps,
    int maxTime,
    int runDistance,
    int skierJack,
    int waterAreas,
  }) {
    return Route2(
      elevatedTerrains: elevatedTerrains ?? this.elevatedTerrains,
      highKnee: highKnee ?? this.highKnee,
      maxTime: maxTime ?? this.maxTime,
      runDistance: runDistance ?? this.runDistance,
      skierJack: skierJack ?? this.skierJack,
      waterAreas: waterAreas ?? this.waterAreas,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Route2ElevatedTerrains': elevatedTerrains,
      'Route2HighKnee': highKnee,
      'Route1MaxTime': maxTime,
      'Route2RunDistance': runDistance,
      'Route2SkierJack': skierJack,
      'water-areas': waterAreas,
    };
  }

  factory Route2.fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;

    return Route2(
      elevatedTerrains: map['Route2ElevatedTerrains']?.toInt(),
      highKnee: map['Route2HighKnee']?.toInt(),
      maxTime: map['Route2MaxTime']?.toInt(),
      runDistance: map['Route2RunDistance']?.toInt(),
      skierJack: map['Route2SkierJack']?.toInt(),
      waterAreas: map['water-areas']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Route2.fromJson(String source) => Route2.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Route2(elevatedTerrains: $elevatedTerrains, highKnee: $highKnee,  maxTime: $maxTime, runDistance: $runDistance, skierJack: $skierJack, waterAreas: $waterAreas)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Route2 &&
        o.elevatedTerrains == elevatedTerrains &&
        o.highKnee == highKnee &&
        o.maxTime == maxTime &&
        o.runDistance == runDistance &&
        o.skierJack == skierJack &&
        o.waterAreas == waterAreas;
  }

  @override
  int get hashCode {
    return elevatedTerrains.hashCode ^
        highKnee.hashCode ^
        maxTime.hashCode ^
        runDistance.hashCode ^
        skierJack.hashCode ^
        waterAreas.hashCode;
  }
}

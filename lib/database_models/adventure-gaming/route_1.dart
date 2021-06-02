import 'dart:convert';

class Route1 {
  final int elevatedTerrains;
  final int highKnee;
  final int maxTime;
  final int runDistance;
  final int skierJack;
  final int waterAreas;
  Route1({
    this.elevatedTerrains,
    this.highKnee,
    this.maxTime,
    this.runDistance,
    this.skierJack,
    this.waterAreas,
  });

  Route1 copyWith({
    int elevatedTerrains,
    int highKnee,
    int jumps,
    int maxTime,
    int runDistance,
    int skierJack,
    int waterAreas,
  }) {
    return Route1(
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
      'Route1ElevatedTerrains': elevatedTerrains,
      'Route1HighKnee': highKnee,
      'Route1MaxTime': maxTime,
      'Route1RunDistance': runDistance,
      'Route1SkierJack': skierJack,
      'Route1WaterAreas': waterAreas,
    };
  }

  factory Route1.fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;

    return Route1(
      elevatedTerrains: map['Route1ElevatedTerrains']?.toInt(),
      highKnee: map['Route1HighKnee']?.toInt(),
      maxTime: map['Route1MaxTime']?.toInt(),
      runDistance: map['Route1RunDistance']?.toInt(),
      skierJack: map['Route1SkierJack']?.toInt(),
      waterAreas: map['Route1WaterAreas']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Route1.fromJson(String source) => Route1.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Route1(elevatedTerrains: $elevatedTerrains, highKnee: $highKnee, maxTime: $maxTime, runDistance: $runDistance, skierJack: $skierJack, waterAreas: $waterAreas)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Route1 &&
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

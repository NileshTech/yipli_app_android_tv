import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_app/database_models/adventure-gaming/player_progress.dart';
import 'package:flutter_app/database_models/adventure-gaming/worlds.dart';

class AdventureGamingData {
  World world;
  PlayerProgress playerProgress;
  //FitnessCard fitnessCard;

  AdventureGamingData({@required this.world, @required this.playerProgress});

  AdventureGamingData copyWith({World world, PlayerProgress playerProgress}) {
    return AdventureGamingData(
        world: world ?? this.world,
        playerProgress: playerProgress ?? this.playerProgress);
  }

  Map<String, dynamic> toMap() {
    return {'world': world?.toMap(), 'playerProgress': playerProgress?.toMap()};
  }

  factory AdventureGamingData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AdventureGamingData(
      world: World.fromMap(map['world']),
      playerProgress: PlayerProgress.fromMap(map['playerProgress']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AdventureGamingData.fromJson(String source) =>
      AdventureGamingData.fromMap(json.decode(source));

  @override
  String toString() =>
      'AdventureGamingData(world: $world, playerProgress: $playerProgress)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AdventureGamingData &&
        o.world == world &&
        o.playerProgress == playerProgress;
  }

  @override
  int get hashCode => world.hashCode ^ playerProgress.hashCode;
}

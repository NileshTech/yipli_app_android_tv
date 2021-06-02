import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'storyline.dart';

class Worlds {
  List<World> worlds;
  Worlds({
    this.worlds,
  });

  Worlds copyWith({
    List<World> worlds,
  }) {
    return Worlds(
      worlds: worlds ?? this.worlds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'worlds': worlds?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory Worlds.fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;

    return Worlds(
      worlds: List<World>.from(map['worlds']?.map((x) => World.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Worlds.fromJson(String source) => Worlds.fromMap(json.decode(source));

  @override
  String toString() => 'Worlds(worlds: $worlds)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Worlds && listEquals(o.worlds, worlds);
  }

  @override
  int get hashCode => worlds.hashCode;
}

class World {
  final String artworkImageUrl;
  final String name;
  final String androidUrl;
  final List<Storyline> storyline;
  World({this.artworkImageUrl, this.name, this.storyline, this.androidUrl});

  World copyWith(
      {String artworkImageUrl,
      String name,
      List<Storyline> storyline,
      String androidUrl}) {
    return World(
        artworkImageUrl: artworkImageUrl ?? this.artworkImageUrl,
        name: name ?? this.name,
        storyline: storyline ?? this.storyline,
        androidUrl: androidUrl ?? this.androidUrl);
  }

  Map<String, dynamic> toMap() {
    return {
      'ArtworkImageUrl': artworkImageUrl,
      'Title': name,
      'storyline': storyline?.map((x) => x?.toMap())?.toList(),
      'AndroidUrl': androidUrl
    };
  }

  factory World.fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;

    return World(
        artworkImageUrl: map['ArtworkImageUrl'],
        name: map['Title'],
        storyline: List<Storyline>.from(
            map['storyline']?.map((x) => Storyline.fromMap(x))),
        androidUrl: map['AndroidUrl']);
  }

  String toJson() => json.encode(toMap());

  factory World.fromJson(String source) => World.fromMap(json.decode(source));

  @override
  String toString() =>
      'World0(artworkImageUrl: $artworkImageUrl, name: $name, storyline: $storyline, androidUrl : $androidUrl)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is World &&
        o.artworkImageUrl == artworkImageUrl &&
        o.name == name &&
        listEquals(o.storyline, storyline) &&
        o.androidUrl == androidUrl;
  }

  @override
  int get hashCode =>
      artworkImageUrl.hashCode ^
      name.hashCode ^
      storyline.hashCode ^
      androidUrl.hashCode;
}

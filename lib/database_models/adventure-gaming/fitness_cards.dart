import 'dart:convert';

import 'package:flutter/foundation.dart';

class FitnessCards {
  List<FitnessCard> cards;
  FitnessCards({
    this.cards,
  });

  FitnessCards copyWith({
    List<FitnessCard> cards,
  }) {
    return FitnessCards(
      cards: cards ?? this.cards,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cards': cards?.map((x) => x?.toMap())?.toList(),
    };
  }

//  factory FitnessCards.fromMap(Map<dynamic, dynamic> map) {
//    if (map == null) return null;
//
//    return FitnessCards(
//      cards: List<FitnessCard>.from(
//          map['cards']?.map((x) => FitnessCard.fromMap(x))),
//    );
//  }

  String toJson() => json.encode(toMap());

//  factory FitnessCards.fromJson(String source) =>
//      FitnessCards.fromMap(json.decode(source));

  @override
  String toString() => 'FitnessCards(cards: $cards)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FitnessCards && listEquals(o.cards, cards);
  }

  @override
  int get hashCode => cards.hashCode;
}

class FitnessCard {
  final String imgUrl;
  final String muscleGroup;
  final String name;
  FitnessCard(
    this.imgUrl,
    this.muscleGroup,
    this.name,
  );

//  FitnessCard copyWith(
//    String imgUrl,
//    List<String> muscleGroup,
//    String name,
//  ) {
//    return FitnessCard(
//      imgUrl: imgUrl ?? this.imgUrl,
//      muscleGroup: muscleGroup ?? this.muscleGroup,
//      name: name ?? this.name,
//    );
//  }

  Map<String, dynamic> toMap() {
    return {
      'ImgUrl': imgUrl,
      'MuscleGroup': muscleGroup,
      'CardName': name,
    };
  }

//  factory FitnessCard.fromMap(Map<dynamic, dynamic> map) {
//    if (map == null) return null;
//
//    return FitnessCard(
//      imgUrl: map['ImgUrl'],
//      muscleGroup: map['MuscleGroup'],
//      name: map['CardName'],
//    );
//  }

  String toJson() => json.encode(toMap());

//  factory FitnessCard.fromJson(String source) =>
//      FitnessCard.fromMap(json.decode(source));

  @override
  String toString() =>
      'FitnessCards(imgUrl: $imgUrl, muscleGroup: $muscleGroup, name: $name)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FitnessCard &&
        o.imgUrl == imgUrl &&
        o.muscleGroup == muscleGroup &&
        o.name == name;
  }

  @override
  int get hashCode => imgUrl.hashCode ^ muscleGroup.hashCode ^ name.hashCode;
}

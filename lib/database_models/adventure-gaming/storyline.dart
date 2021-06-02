import 'dart:convert';

import 'fitness_cards.dart';

class Storyline {
  final String artworkImageUrl;
  final String chapterTitle;
  final List<int> fitnessCards;
  final List<FitnessCard> fitnessCardInfoList;
  Storyline(
      {this.artworkImageUrl,
      this.chapterTitle,
      this.fitnessCards,
      this.fitnessCardInfoList});

  Storyline copyWith(
      {String artworkImageUrl,
      String chapterTitle,
      List<int> fitnessCards,
      List<FitnessCard> fitnessCardInfoList}) {
    return Storyline(
      artworkImageUrl: artworkImageUrl ?? this.artworkImageUrl,
      chapterTitle: chapterTitle ?? this.chapterTitle,
      fitnessCards: fitnessCards ?? this.fitnessCards,
      fitnessCardInfoList: fitnessCardInfoList ?? this.fitnessCardInfoList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ArtworkImageUrl': artworkImageUrl,
      'ChapterTitle': chapterTitle,
      'Card': fitnessCards
    };
  }

  factory Storyline.fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;

    var fCards = map['Card'];
    List<String> fCL = fCards.split(',');
    print("converted list : $fCL");

    List<int> iListFC = new List<int>();
    for (var value in fCL) {
      if (value != null && value != "") iListFC.add(int.parse(value));
    }
    return Storyline(
        artworkImageUrl: map['ArtworkImageUrl'],
        chapterTitle: map['ChapterTitle'],
        fitnessCards: iListFC);
  }

  String toJson() => json.encode(toMap());

  factory Storyline.fromJson(String source) =>
      Storyline.fromMap(json.decode(source));

  @override
  String toString() =>
      'Storyline(artworkImageUrl: $artworkImageUrl, chapterTitle: $chapterTitle, fitnessCards: $fitnessCards)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Storyline &&
        o.artworkImageUrl == artworkImageUrl &&
        o.chapterTitle == chapterTitle &&
        o.fitnessCards == fitnessCards;
  }

  @override
  int get hashCode =>
      artworkImageUrl.hashCode ^ chapterTitle.hashCode ^ fitnessCards.hashCode;
}

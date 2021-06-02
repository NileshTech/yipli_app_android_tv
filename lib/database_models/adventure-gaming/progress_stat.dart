import 'dart:convert';

class ProgressStat {
  final String chapterRef;
  final String classRef;
  final double rating;
  final int fp;
  final int t;
  final int c;
  final int count;
  ProgressStat(
      {this.chapterRef,
      this.classRef,
      this.rating,
      this.fp,
      this.t,
      this.count,
      this.c});

  ProgressStat copyWith({
    String chapterRef,
    String classRef,
    double rating,
    int fp,
    int c,
    int t,
    int count,
  }) {
    return ProgressStat(
      chapterRef: chapterRef ?? this.chapterRef,
      classRef: classRef ?? this.classRef,
      rating: rating ?? this.rating,
      fp: fp ?? this.fp,
      t: t ?? this.t,
      count: count ?? this.count,
      c: c ?? this.c,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chapter-ref': chapterRef,
      'class-ref': classRef,
      'rating': rating,
      'fp': fp,
      't': t,
      'count': count,
      'c': c,
    };
  }

  factory ProgressStat.fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;

    return ProgressStat(
      chapterRef: map['chapter-ref'],
      classRef: map['class-ref'],
      rating: map['rating']?.toDouble(),
      fp: map['fp']?.toInt(),
      t: map['t']?.toInt(),
      count: map['count']?.toInt(),
      c: map['c'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProgressStat.fromJson(String source) =>
      ProgressStat.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProgressStat(chapterRef: $chapterRef, classRef: $classRef, rating: $rating, fp: $fp, t: $t, count: $count, c : $c)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ProgressStat &&
        o.chapterRef == chapterRef &&
        o.classRef == classRef &&
        o.rating == rating &&
        o.fp == fp &&
        o.t == t &&
        o.c == c &&
        o.count == count;
  }

  @override
  int get hashCode {
    return chapterRef.hashCode ^
        classRef.hashCode ^
        rating.hashCode ^
        fp.hashCode ^
        t.hashCode ^
        count.hashCode ^
        c.hashCode;
  }
}

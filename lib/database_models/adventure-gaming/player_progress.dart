import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'progress_stat.dart';

class PlayerProgress {
  final String nextChapterRef;
  final String nextClassRef;
  final int currentIndex;
  final int totalFp;
  final int averageRating;
  final List<ProgressStat> progressStats;
  PlayerProgress({
    this.nextChapterRef,
    this.nextClassRef,
    this.currentIndex,
    this.totalFp,
    this.averageRating,
    this.progressStats,
  });

  PlayerProgress copyWith({
    String nextChapterRef,
    String nextClassRef,
    int currentIndex,
    int totalFp,
    int averageRating,
    List<ProgressStat> progressStats,
  }) {
    return PlayerProgress(
      nextChapterRef: nextChapterRef ?? this.nextChapterRef,
      nextClassRef: nextClassRef ?? this.nextClassRef,
      currentIndex: currentIndex ?? this.currentIndex,
      totalFp: totalFp ?? this.totalFp,
      averageRating: averageRating ?? this.averageRating,
      progressStats: progressStats ?? this.progressStats,
    );
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'next-chapter-ref': nextChapterRef,
      'next-class-ref': nextClassRef,
      'current-index': currentIndex,
      'total-fp': totalFp,
      'average-rating': averageRating,
      'progress-stats': progressStats?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory PlayerProgress.fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;

    return PlayerProgress(
      nextChapterRef: map['next-chapter-ref'],
      nextClassRef: map['next-class-ref'],
      currentIndex: map['current-index']?.toInt(),
      totalFp: map['total-fp']?.toInt(),
      averageRating: map['average-rating']?.toInt(),
      progressStats: List<ProgressStat>.from(
          map['progress-stats']?.map((x) => ProgressStat.fromMap(x)) ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlayerProgress.fromJson(String source) =>
      PlayerProgress.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PlayerProgress(nextChapterRef: $nextChapterRef, nextClassRef: $nextClassRef, currentIndex: $currentIndex, totalFp: $totalFp, averageRating: $averageRating, progressStats: $progressStats)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PlayerProgress &&
        o.nextChapterRef == nextChapterRef &&
        o.nextClassRef == nextClassRef &&
        o.currentIndex == currentIndex &&
        o.totalFp == totalFp &&
        o.averageRating == averageRating &&
        listEquals(o.progressStats, progressStats);
  }

  @override
  int get hashCode {
    return nextChapterRef.hashCode ^
        nextClassRef.hashCode ^
        currentIndex.hashCode ^
        totalFp.hashCode ^
        averageRating.hashCode ^
        progressStats.hashCode;
  }
}

import 'dart:async';
import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_app/helpers/auth.dart';
import 'package:flutter_app/helpers/firebase_database.dart';

class RewardsModel extends ChangeNotifier {
  List<RewardModel> allRewards;
  String playerId;
  static const String routeName = "/rewards_model";

  RewardsModel.initialize(currentPlayerId) {
    allRewards = new List<RewardModel>();
    var rewardsModelTransformer =
        StreamTransformer<Event, RewardsModel>.fromHandlers(
            handleData: handleModelStreamTransform);
    FirebaseDatabaseUtil()
        .getModelStream(getModelRef(currentPlayerId), rewardsModelTransformer)
        .listen((changedData) async {
      RewardsModel changedRewardsData = changedData;
      print("Rewards data found to be changed!!");
      refreshModel(changedRewardsData);
      notifyListeners();
      print("Rewards Listeners notified!!");
    });
  }

  static String getModelRef(playerId) {
    String userId = AuthService.getCurrentUserId();
    return "/inbox/$userId/$playerId/special-rewards";
  }

  void refreshModel(RewardsModel newRewardsModelData) {
    allRewards = newRewardsModelData.allRewards;
  }

  RewardsModel.fromSnapshotValue(DataSnapshot dataSnapshot) {
    allRewards = new List<RewardModel>();
    LinkedHashMap fetchedRewardsMap = dataSnapshot.value;
    if (fetchedRewardsMap != null) {
      for (var reward in fetchedRewardsMap.entries) {
        print("Creating player model for ${reward.key}");
        RewardModel rewardToAdd =
            RewardModel.fromSnapshotValue(reward.value, reward.key);
        allRewards.add(rewardToAdd);
      }
    }
  }

  void handleModelStreamTransform(Event event, EventSink<RewardsModel> sink) {
    print("Adding handler for stream transformation");
    RewardsModel newRewardsModel =
        RewardsModel.fromSnapshotValue(event.snapshot);
    sink.add(newRewardsModel);
  }
}

class RewardModel extends ChangeNotifier {
  final String rewardId;
  String title;
  String desc;
  String rewards;
  String timestamp;

  RewardModel.initialize(this.rewardId, currentPlayerId) {
    if (rewardId != null) {
      var rewardModelTransformer =
          StreamTransformer<Event, RewardModel>.fromHandlers(
              handleData: handleModelStreamTransform);
      FirebaseDatabaseUtil()
          .getModelStream(
              getModelRef(rewardId, currentPlayerId), rewardModelTransformer)
          .listen((changedData) async {
        RewardModel changedRewardData = changedData;
        print("Reward data found to be changed!!");
        refreshModel(changedRewardData);
        notifyListeners();
        print("Reward Listeners notified!!");
      });
    }
  }

  static String getModelRef(rewardId, currentPlayerId) {
    String userId = AuthService.getCurrentUserId();
    print(
        "The Reward reference sent : /inbox/rewards/$userId/rewards/$rewardId");
    return "/inbox/$userId/$currentPlayerId/special-rewards/$rewardId";
  }

  void refreshModel(RewardModel newRewardModelData) {
    title = newRewardModelData.title;
    desc = newRewardModelData.desc;
    rewards = newRewardModelData.rewards;
    timestamp = newRewardModelData.timestamp;
  }

  RewardModel.fromSnapshotValue(dynamic value, this.rewardId) {
    print("Reward ID IS FOUND TO BE - $rewardId");
    title = value['title'];
    desc = value['desc'];
    rewards = value['fp'].toString();
    timestamp = value['timestamp'];
  }

  void handleModelStreamTransform(Event event, EventSink<RewardModel> sink) {
    print("Adding handler for stream transformation");
    RewardModel newRewardModel =
        RewardModel.fromSnapshotValue(event.snapshot.value, event.snapshot.key);
    sink.add(newRewardModel);
  }

  @override
  String toString() {
    return 'MatModel(rewardId: $rewardId, title: $title, desc: $desc, rewards: $rewards, timestamp: $timestamp)';
  }
}

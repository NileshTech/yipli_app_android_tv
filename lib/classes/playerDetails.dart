import 'package:flutter/cupertino.dart';
import 'package:flutter_app/classes/playerActivityStats.dart';
import 'package:flutter_app/database_models/players.dart';
import 'package:flutter_app/page_models/player_model.dart';

class PlayerDetails {
  String playerName;
  String dob;

  ActivityStats activityStats;
  String gender;
  String weight;
  String height;
  String userId;
  String playerId;
  FileImage profilePic;
  String profilePicUrl;
  bool bIsCurrentPlayer;

  PlayerDetails(
      {this.profilePic,
      this.profilePicUrl,
      this.playerId,
      this.userId,
      this.playerName,
      this.dob,
      this.gender,
      this.weight,
      this.height,
      this.activityStats,
      this.bIsCurrentPlayer});

  PlayerDetails.playerDetailsFromDBPlayer(Players player) {
    this.height = player?.height ?? '';
    this.weight = player?.weight ?? '';
    this.gender = player?.gender ?? '';
    this.playerId = player?.id ?? '';
    this.playerName = player?.name ?? '';
    this.dob = player?.dob ?? '';
    this.profilePic = player?.profilePic ?? null;
    this.profilePicUrl = player?.profilePicUrl ?? null;
    this.userId = player?.userId ?? '';
    this.bIsCurrentPlayer = player?.bIsCurrentPlayer ?? false;
  }

  PlayerDetails.playerDetailsFromPlayerModel(PlayerModel player) {
    this.height = player?.height ?? '';
    this.weight = player?.weight ?? '';
    this.gender = player?.gender ?? '';
    this.playerId = player?.id ?? '';
    this.playerName = player?.name ?? '';
    this.dob = player?.dob ?? '';
    this.activityStats = player?.activityStats ?? ActivityStats();
    this.profilePic = player?.profilePic ?? null;
    this.profilePicUrl = player?.profilePicUrl ?? null;
    this.userId = player?.userId ?? '';
    this.bIsCurrentPlayer = player?.bIsCurrentPlayer ?? false;
  }
}

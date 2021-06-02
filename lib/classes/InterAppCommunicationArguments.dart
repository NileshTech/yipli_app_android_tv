import 'dart:io';

import 'classes_index.dart';

class InterAppCommunicationArguments {
  String uId;
  String pId;
  String pName;
  String pDOB;
  String pWt;
  String pHt;
  String mId;
  String mName;
  String mMac;
  String pPicUrl;
  int agpIdx;
  int chapIdx;
  String isMatTutDone;
  String tv;
  InterAppCommunicationArguments(
      {@required this.uId,
      this.pId,
      this.pName,
      this.pDOB,
      this.pWt,
      this.pHt,
      this.pPicUrl,
      this.mId,
      this.mName,
      this.mMac,
      this.isMatTutDone,
      this.tv,
      this.agpIdx,
      this.chapIdx});
  InterAppCommunicationArguments.fromJson(Map<String, dynamic> json) {
    //The Following strings would be read from the Android-Game on launch.
    //Windows doesnt use this meachanism.
    //ToDo : Handle this for IOS device.

    uId = json['uId'];
    pId = json['pId'];
    pName = json['pName'];
    pDOB = json['pDOB'];
    pPicUrl = json['pPicUrl'];
    pWt = json['pWt'];
    pHt = json['pHt'];
    mId = json['mId'];
    mName = json['mName'];
    mMac = json['mMac'];
    isMatTutDone = json['pTutDone'];
    tv = json['tv'];
    agpIdx = json['agpIdx'];
    chapIdx = json['chapIdx'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    this.uId != null ? data['uId'] = this.uId : () {}();
    this.pId != null ? data['pId'] = this.pId : () {}();
    this.pName != null ? data['pName'] = this.pName : () {}();
    this.pDOB != null ? data['pDOB'] = this.pDOB : () {}();
    this.pWt != null ? data['pWt'] = this.pWt : () {}();
    this.pHt != null ? data['pHt'] = this.pHt : () {}();
    this.pPicUrl != null ? data['pPicUrl'] = this.pPicUrl : () {}();
    this.mId != null ? data['mId'] = this.mId : () {}();
    this.mName != null ? data['mName'] = this.mName : () {}();
    this.mMac != null ? data['mMac'] = this.mMac : () {}();
    this.isMatTutDone != null ? data['pTutDone'] = this.isMatTutDone : () {}();
    if (Platform.isAndroid) {
      this.tv != null ? data['tv'] = this.tv : () {}();
    }
    this.agpIdx != null ? data['agpIdx'] = this.agpIdx : () {}();
    this.chapIdx != null ? data['chapIdx'] = this.chapIdx : () {}();
    return data;
  }
}

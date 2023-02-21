import 'package:dtnd/=models=/core_response_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'user_token.g.dart';

// class UserEntity {
//   late final String? oID;
//   late final int rc;
//   late final String? rs;
//   UserToken? loginData;

//   UserEntity({this.oID, this.rc = 0, this.rs, this.loginData});

//   UserEntity.fromJson(Map<String, dynamic> json) {
//     oID = json['oID'];
//     rc = json['rc'] ?? 0;
//     rs = json['rs'];
//     loginData = json['data'] != null ? UserToken.fromJson(json['data']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['oID'] = oID;
//     data['rc'] = rc;
//     data['rs'] = rs;
//     if (loginData != null) {
//       data['data'] = loginData!.toJson();
//     }
//     return data;
//   }
// }

@HiveType(typeId: 0)
class UserToken implements CoreResponseModel {
  @HiveField(0)
  late final String user;
  @HiveField(1)
  late final String name;
  @HiveField(2)
  late final String sid;
  @HiveField(3)
  late final String address;
  @HiveField(4)
  late final String defaultAcc;
  @HiveField(5)
  late final num iFlag;
  @HiveField(6)
  late final num countLoginFail;
  @HiveField(7)
  late final String authenType;
  @HiveField(8)
  late final String? iP;
  // @HiveField(9)
  // late final String authenFlag;
  // @HiveField(10)
  // late final String customerCode;

  UserToken({
    required this.user,
    required this.name,
    required this.sid,
    required this.address,
    required this.defaultAcc,
    required this.iFlag,
    required this.countLoginFail,
    required this.authenType,
    required this.iP,
    // required this.authenFlag,
    // required this.customerCode,
  });

  UserToken.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    name = json['name'];
    sid = json['sid'];
    address = json['address'];
    defaultAcc = json['defaultAcc'];
    iFlag = json['iFlag'];
    countLoginFail = json['CountLoginFail'];
    authenType = json['AuthenType'];
    iP = json['IP'];
    // authenFlag = json['AuthenFlag'];
    // customerCode = json['CustomerCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['name'] = name;
    data['sid'] = sid;
    data['address'] = address;
    data['defaultAcc'] = defaultAcc;
    data['iFlag'] = iFlag;
    data['CountLoginFail'] = countLoginFail;
    data['AuthenType'] = authenType;
    data['IP'] = iP;
    // data['AuthenFlag'] = authenFlag;
    // data['CustomerCode'] = customerCode;
    return data;
  }
}

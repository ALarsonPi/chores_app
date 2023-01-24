import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'UserModel.freezed.dart';
part 'UserModel.g.dart';

@freezed
class UserModel with _$UserModel {
  UserModel._();

  @JsonSerializable(explicitToJson: true)
  factory UserModel({
    required String id,
    String? name,
    String? email,
    String? password,
    List<String>? correlatedUserIDs,
    List<String>? chartIDs,
    List<int>? associatedTabNums,
  }) = _UserModel;

  static UserModel emptyUser = UserModel(
    id: "ID",
  );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    UserModel newUser =
        UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    return newUser;
  }
}

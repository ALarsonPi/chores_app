import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'User.freezed.dart';
part 'User.g.dart';

@freezed
class User with _$User {
  User._();

  @JsonSerializable(explicitToJson: true)
  factory User({
    required String id,
    String? name,
    String? email,
    String? password,
    List<String>? correlatedUserIDs,
    List<String>? chartIDs,
    List<int>? associatedTabNums,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    User newUser = User.fromJson(snapshot.data() as Map<String, dynamic>);
    return newUser;
  }
}

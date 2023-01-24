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

  UserModel addTabToUser(int tabNum, String chartIDToAdd, UserModel currUser) {
    List<int> currTabs = List.empty(growable: true);
    if (currUser.associatedTabNums != null) {
      currTabs.addAll(currUser.associatedTabNums as List<int>);
    }
    currTabs.add(tabNum);

    List<String> currIds = List.empty(growable: true);
    if (chartIDs != null) {
      currIds.addAll(chartIDs as List<String>);
    }
    currIds.add(chartIDToAdd);

    return currUser.copyWith(associatedTabNums: currTabs, chartIDs: currIds);
  }

  UserModel removeTabFromUser(int tabNum, String chartID, UserModel currUser) {
    List<int> currTabs = List.empty(growable: true);
    if (currUser.associatedTabNums != null) {
      currTabs.addAll(currUser.associatedTabNums as List<int>);
    }
    currTabs.remove(tabNum);

    List<String> currIds = List.empty(growable: true);
    if (chartIDs != null) {
      currIds.addAll(chartIDs as List<String>);
    }
    currIds.remove(chartID);

    return currUser.copyWith(associatedTabNums: currTabs, chartIDs: currIds);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    UserModel newUser =
        UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    return newUser;
  }
}

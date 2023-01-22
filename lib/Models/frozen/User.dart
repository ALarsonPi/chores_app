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

  User addTabToUser(int tabNum, String chartIDToAdd, User currUser) {
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

  User removeTabFromUser(int tabNum, String chartID, User currUser) {
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

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    User newUser = User.fromJson(snapshot.data() as Map<String, dynamic>);
    return newUser;
  }
}

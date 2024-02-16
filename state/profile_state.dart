import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:racfmn/helper/api.dart';
import 'package:racfmn/helper/enum.dart';
import 'package:racfmn/helper/utility.dart';
import 'package:racfmn/model/user.dart';
/*import 'package:firebase_database/firebase_database.dart' as dabase; */

class ProfileState extends ChangeNotifier {
  

  /// This is the id of user who is logegd into the app.
  int? userId;

  /// Profile data of logged in user.
  List<UserModel> _userModel = <UserModel>[];
  List<UserModel> get userModel => _userModel;

void setProfile(value) {
  _userModel = value;
  notifyListeners();
}
  
  int? profileId;
  UserModel? _profileUserModel;
  UserModel get profileUserModel => _profileUserModel as UserModel;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool get isMyProfile => profileId == userId;

  /// Fetch profile of logged in  user

  /// Fetch profile data of user whoose profile is opened
  void getProfileUser(int userProfileId) async{
    assert(userProfileId != null);
    print(userProfileId);
    loading = true;
    try {

  final jsonData = await Api.getProfile(userProfileId.toString().trim());
  
        
        setProfile(jsonData);
        loading = false;
    } catch(error) {
      loading = false;
      print(error);
    }
  
  }

  /// Follow / Unfollow user
  ///
  /// If `removeFollower` is true then remove user from follower list
  ///
  /// If `removeFollower` is false then add user to follower list

  void addFollowNotification() {
    // Sends notification to user who created tweet
    // UserModel owner can see notification on notification page
    /* kDatabase.child('notification').child(profileId).child(userId).set({
      'type': NotificationType.Follow.toString(),
      'createdAt': DateTime.now().toUtc().toString(),
      'data': UserModel(
              displayName: userModel.displayName,
              profilePic: userModel.profilePic,
              isVerified: userModel.isVerified,
              userId: userModel.userId,
              bio: userModel.bio == "Edit profile to update bio"
                  ? ""
                  : userModel.bio,
              userName: userModel.userName)
          .toJson()
    });
    */
  }

  /// Trigger when logged-in user's profile change or updated
  /// Firebase event callback for profile update
  void _onProfileChanged(event) {
    if (event.snapshot != null) {
      final updatedUser = UserModel.fromJson(event.snapshot.value);
      if (updatedUser.userId == profileId) {
        _profileUserModel = updatedUser;
      }
      notifyListeners();
    }
  }

  @override
  void dispose() {
    /* _profileQuery.onValue.drain();
    profileSubscription.cancel(); */
    // _profileQuery.
    super.dispose();
  }
}

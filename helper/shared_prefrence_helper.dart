import 'dart:convert';
import 'package:racfmn/helper/constant.dart';
import 'package:racfmn/model/item.dart';
import 'package:racfmn/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:universal_io/io.dart';

class SharedPreferenceHelper {
  SharedPreferenceHelper._internal();
  static final SharedPreferenceHelper _singleton =
      SharedPreferenceHelper._internal();

  factory SharedPreferenceHelper() {
    return _singleton;
  }

  Future<bool> saveUser(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
  
    prefs.setInt("userId", user.userId as int);
    prefs.setString("userName", user.userName as String);
    prefs.setString("userEmail", user.email as String);
    prefs.setInt("isVerified", user.isVerified as int);
    prefs.setString("phone", user.contact ?? " ");
    prefs.setString("address", user.address ?? " ");
    prefs.setString("country", user.country ?? " ");
    prefs.setString("state", user.state ?? " ");
    prefs.setString("displayName", user.displayName ?? " ");
    prefs.setString("philosophy", user.philosophy ?? " ");
    prefs.setString("dob", user.dob ?? " ");
    prefs.setString("displayLast", user.displayLast ?? " ");
     prefs.setString("profilePic", user.profilePic ?? "${Constants.dummyProfilePic}");

    //prefs.setString("token", user.fcmToken as String);
    //prefs.setBool("isVerified", user.isVerified as bool);

    print("object prefere");
    //print(user.renewalToken);

    // ignore: deprecated_member_use
    return prefs.commit();
  }
  Future<UserModel> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt("userId") as int;
    String name = prefs.getString("userName") as String;
    String email = prefs.getString("userEmail") as String;
    int isVerified = prefs.getInt("isVerified") as int;
    String profilePic = prefs.getString("profilePic") ?? "${Constants.dummyProfilePic}";
    String phone = prefs.getString("phone") as String;
    String address = prefs.getString("address") as String;
    String country = prefs.getString("country") as String;
    String state = prefs.getString("state") as String;
    String displayName = prefs.getString("displayName") as String;
    String displayLast = prefs.getString("displayLast") as String;
    String philosophy = prefs.getString("philosophy") as String;
    String dob = prefs.getString("dob") as String;

    return UserModel(
        userId: userId,
        userName: name,
        email: email,
        isVerified: isVerified,
        profilePic: profilePic,
        contact: phone,
        address: address,
        country: country,
        state: state,
        displayName: displayName,
        displayLast: displayLast,
        philosophy: philosophy,
        dob: dob);
  }
   Future clearPreferenceValues() async {
    await (SharedPreferences.getInstance())
      ..clear();
  }

  Future<void> removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    //prefs.remove("name");
    prefs.remove("userId");
    prefs.remove("userName");
    prefs.remove("userEmail");
    prefs.remove("profilePic");
    prefs.remove("isVerified");
    //prefs.remove("token");
  }
 Future<bool> saveLinkMediaInfo(String key, String model) async {
    return (await SharedPreferences.getInstance())
        .setString(key, model);
  }
  Future<void> saveThemeModeSetting(bool isDarkModeEnabled) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(Constants.darkModeKey, isDarkModeEnabled);
  }
  Future<bool> getThemeModeSetting() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    bool? isDarkModeEnabled = sharedPreferences.getBool(Constants.darkModeKey);
    return isDarkModeEnabled != null ? isDarkModeEnabled : false;
  }
Future<void> removeReminder() async{
  (await SharedPreferences.getInstance()).remove(Constants.items);
}
  Future<String?> getLinkMediaInfo(String key) async {
    final jsonString = (await SharedPreferences.getInstance()).getString(key);
    if (jsonString == null) {
      return null;
    }
    return jsonString;
  }
  Future<void> saveItemList(List<Item> items) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final itemed = Item.encodes(items);
    sharedPreferences.setString(Constants.items, itemed);

  }
  Future<String> itemLists() async {
  final listString = (await SharedPreferences.getInstance()).getString(Constants.items);
  print('This is the value of lists of shared Prefernce => $listString');
  return (listString != null && listString.length > 0) ? listString : "";
  }

/*  Future<String?> getToken(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    return token;
  }
  */
}


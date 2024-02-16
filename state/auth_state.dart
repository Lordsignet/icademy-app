import 'dart:io';

//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_database/firebase_database.dart' as dabase;
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:racfmn/helper/api.dart';
import 'package:racfmn/helper/constant.dart';
import 'package:racfmn/helper/enum.dart';
import 'package:racfmn/helper/shared_prefrence_helper.dart';
import 'package:racfmn/helper/utility.dart';
import 'package:racfmn/helper/app_url.dart';
import 'package:racfmn/model/user.dart';
import 'package:racfmn/model/api_error.dart';
import 'package:racfmn/model/api_respose.dart';
import 'package:racfmn/ui/page/common/locator.dart';
import 'package:http/http.dart'; 
import 'package:path/path.dart' as Path;

import 'app_state.dart';
import 'dart:async';




class AuthState extends AppState {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool isSignInWithGoogle = false;
  http.Response? userData;
  String? userId;
  dynamic user;
  var modeluser;
bool _isbusy = false;
  
  // List<UserModel> _profileUserModelList;
  UserModel? _userModel = new UserModel();

//  UserModel get userDatas => _userModel as UserModel;
/*void setUser(UserModel usersd) {
    _userModel = usersd;
    notifyListeners();
  }
  */
bool get isbusy => _isbusy as bool;
  UserModel get userModel => _userModel as UserModel;
  UserModel get profileUserModel => _userModel as UserModel;
  String get UserId  => userId as String;
  

  /// Logout from device
  void logoutCallback() async {
    authStatus = AuthStatus.NOT_LOGGED_IN;
  
    userId = '';
    _userModel = null;
    user = null;

    notifyListeners();
    await getIt<SharedPreferenceHelper>().removeUser();
  }

  /// Alter select auth method, login and sign up page
  void openSignUpPage() {
    authStatus = AuthStatus.NOT_LOGGED_IN;
    userId = '';
    notifyListeners();
  }





 Future<Map<String, dynamic>> login(String email, String password,bool isUpdate,{GlobalKey<ScaffoldState>? scaffoldKey}) async {
    var result;
    
    final Map<String, dynamic> loginData = {
      
        'email': email,
        'password': password,
        'isUpdate': isUpdate
      };
      Map<String, dynamic>? responseData;
        
try {

  authStatus = AuthStatus.AUTHENTICATING;
    notifyListeners();
   /* return await http.post(Uri.parse(Constants.login),
        body: json.encode(loginData),
         headers: {'Content-Type': 'application/json'})
        .then(onValue)
        .catchError(onError);
    */
     
        final Response response = await http.post(Uri.parse(Constants.login),
        body: json.encode(loginData),
         headers: {'Content-Type': 'application/json'});
        responseData = await onValue(response, firstString: "Email", messageString: "Log in Successfull", failedMessage: "Something went wrong, try again", isEnabled: true);
         //return responseData;
        } catch(e) {
          
            authStatus = AuthStatus.NOT_LOGGED_IN;
            notifyListeners();
            responseData = {'status': false, 'message': 'Unsuccessful Request', 'data': e};
            return responseData;
         
        } 
        return responseData;
  }

  Future<Map<String, dynamic>> register(String email, String password,{GlobalKey<ScaffoldState>? scaffoldKey}) async {
    final tokens = (await _firebaseMessaging.getToken()) as String;
    
   // assert(tokens.isNotEmpty);
   print(tokens);
    final Map<String, String> registrationData = {
      
        
        'userEmail': email,
        'userPassword': password,
        'token': tokens
    
    };
     Map<String, dynamic>? responseData;
    try {
    authStatus = AuthStatus.AUTHENTICATING;
    notifyListeners();
    
    
       
        
        final Response response = await http.post(Uri.parse(Constants.register),
        body: json.encode(registrationData),
         headers: {'Content-Type': 'application/json'});
        responseData = await onValue(response, firstString: "Email", messageString: "Successfully Registered", failedMessage: "Something went wrong", isEnabled: false);
         //return responseData;
    } catch (e) {
      authStatus = AuthStatus.NOT_LOGGED_IN;
            notifyListeners();
            responseData = {'status': false, 'message': 'Unsuccessful Request', 'data': e};
            return responseData;
    }
        return responseData;
  }

Future<Map<String, dynamic>> updatePassword(String email, String password, {GlobalKey<ScaffoldState>? scaffoldkey}) async{
var data = "${Constants.updatepassword}?email=${email}&password=${password}";
Map<String, dynamic>responseData;
var result;
dynamic success;
dynamic error;
try {
final Response returnedData = await http.get(Uri.parse(data),
headers: {'ContentType' : 'application/json'});
responseData = json.decode(returnedData.body);
success = responseData["message"]["success"];
error = responseData["message"]["error"];
if(returnedData.statusCode == 200 && success == true) {

  result = {
    "status": true,
    "message": "Updated successfully"
  };
} else if(returnedData.statusCode == 200 && success == false && error.toString().contains("found")) {
  result = {
    "status": false,
    "message": "Mail does not exist"
  };
} else {
  result = {
    "status": false,
    "message": "Failed to update"
  };

}
} catch (ex) {
  result = {
    "status": false,
    "message": "Network error"
  };
}
return result;
}

Future<Map<String, dynamic>> onValue(Response response, {required String firstString, required String messageString, required String failedMessage, required bool isEnabled}) async {
    var result;
    dynamic errorData;
    dynamic message;
  
    final Map<String, dynamic> responseData = json.decode(response.body);

    print(response.statusCode);
    print(responseData);
    print(responseData["message"]);
    print(responseData["message"]["error"]);
    errorData = responseData["message"]["error"];
  message = responseData["message"];
    if (response.statusCode == 200 && errorData.toString().isEmpty ) {

      var userData = responseData["message"]["data"];
      print("was I called and printed");
      print(userData);
      errorData = responseData["message"]["error"];
       
      UserModel authUser = UserModel.fromJson(userData);
     getIt<SharedPreferenceHelper>().saveUser(authUser);
      print(errorData);
      result = {
        'status': true,
        'message': '${messageString}',
        'data': authUser,
        'errorData': errorData
      };
      
      authStatus = isEnabled ? AuthStatus.LOGGED_IN : AuthStatus.NOT_LOGGED_IN;
      notifyListeners();
    } else if(response.statusCode == 200 && errorData.toString().contains("${firstString}")) {
//      if (response.statusCode == 401) Get.toNamed("/login");
      result = {
        'status': false,
        'message': '${failedMessage}',
        'data': responseData,
        'errorData': errorData
      };
       authStatus = AuthStatus.NOT_LOGGED_IN;
       notifyListeners();
    } else {
      result = {
        'status': false,
        'message': '${failedMessage}',
        'data': responseData,
        'errorData': errorData
      };
       authStatus = AuthStatus.NOT_LOGGED_IN;
       notifyListeners();
    }
    
    print(authStatus);
    return result;
  }

  static onError(error) {
    print("the error is $error.detail");
    return {'status': false, 'message': 'Unsuccessful Request', 'errorData': error};
  }
   
   Future<Map<String, dynamic>> UpdateProfile({int? userId, String? firstName, String? lastName, String?  contact, 
   String? dob, String? country, String? state, String? address, String? philosophy }) async {
    var result;

    final Map<String, dynamic> updateData = {
      
        'firstName': firstName,
        'lastName': lastName,
        'contact': contact,
        'dob': dob,
         'country': country,
         'state': state,
         'address': address,
         'philosophy': philosophy,
         'userId': userId
      };

 /* authStatus = AuthStatus.LOGGED_IN;
    notifyListeners();
    return await http.post(Uri.parse(Constants.login),
        body: json.encode(loginData),
         headers: {'Content-Type': 'application/json'})
        .then(onValue)
        .catchError(onError);
    */
     Map<String, dynamic>? responseData;
        try {
        final Response response = await http.put(Uri.parse(Constants.update),
        body: json.encode(updateData),
         headers: {'Content-Type': 'application/json'});
        responseData = await onValue(response, firstString: "failed", messageString: "Profile updated Successfully", failedMessage: "Something went wrong, try again", isEnabled: false);
         //return responseData;
        } catch (ex) {
          print(ex);
         responseData = {'status': false, 'message': 'Unsuccessful Request', 'data': ex};
        } 
        return responseData;
  }

  /// Verify user's credentials for login
  /*Future<ApiResponse> signIn(String email, String password,
      {GlobalKey<ScaffoldState>? scaffoldKey}) async {
    ApiResponse _apiResponse = new ApiResponse();
    try {
      loading = true;

      Uri url = Uri.parse('http://10.0.2.2:3000/login');
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_id': email,
          'user_pass': password,
        }),
      );

      /* final result = json.decode(userData.body);
      if (result['error'] != null)
        /*throw (responseData['error']['message']); */
        //final responseError = responseData['error']['message'];
        cprint(result['error']['message'], errorIn: 'signIn');
      user = result.user;
      userId = user.uid;
      return user.uid;
    } catch (error) {
      loading = false;
      cprint(error, errorIn: 'signIn');
      //kAnalytics.logLogin(loginMethod: 'email_login');
      Utility.customSnackBar(
          scaffoldKey as GlobalKey<ScaffoldState>, error.toString());
      // logoutCallback();
      return null as Future<String>;
    }
    */
      switch (response.statusCode) {
        case 200:
          _apiResponse.Data = UserModel.fromJson(json.decode(response.body));
          Utility.customSnackBar(
              scaffoldKey as GlobalKey<ScaffoldState>, 'login Succesful');
          //msgToast('login Succesful');
          break;
        case 401:
          _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
        default:
          _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
      }
    } on SocketException {
      _apiResponse.ApiError = ApiError(error: 'Server error. Please retry');
    }
    return _apiResponse;
  } */

  /// Create user from `google login`
  /// If user is new then it create a new user
  /// If user is old then it just `authenticate`
  ///  user and return firebase user data
  /* Future<User> handleGoogleSignIn() async {
    try {
      /// Record log in firebase kAnalytics about Google login
      kAnalytics.logLogin(loginMethod: 'google_login');
      final GoogleSignInAccount googleUser =
          await _googleSignIn.signIn() as GoogleSignInAccount;
      if (googleUser == null) {
        throw Exception('Google login cancelled by user');
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      user = (await _firebaseAuth.signInWithCredential(credential)).user;
      authStatus = AuthStatus.LOGGED_IN;
      userId = user.uid;
      isSignInWithGoogle = true;
      createUserFromGoogleSignIn(user);
      notifyListeners();
      return user;
    } on PlatformException catch (error) {
      user = null;
      authStatus = AuthStatus.NOT_LOGGED_IN;
      cprint(error, errorIn: 'handleGoogleSignIn');
      return null;
    } on Exception catch (error) {
      user = null;
      authStatus = AuthStatus.NOT_LOGGED_IN;
      cprint(error, errorIn: 'handleGoogleSignIn');
      return null;
    } catch (error) {
      user = null;
      authStatus = AuthStatus.NOT_LOGGED_IN;
      cprint(error, errorIn: 'handleGoogleSignIn');
      return null;
    }
  }
*/
  /// Create user profile from google login
  /* void createUserFromGoogleSignIn(User user) {
    var diff = DateTime.now().difference(user.metadata.creationTime);
    // Check if user is new or old
    // If user is new then add new user to firebase realtime kDatabase
    if (diff < Duration(seconds: 15)) {
      UserModel model = UserModel(
        bio: 'Edit profile to update bio',
        dob: DateTime(1950, DateTime.now().month, DateTime.now().day + 3)
            .toString(),
        location: 'Somewhere in universe',
        profilePic: user.photoURL,
        displayName: user.displayName,
        email: user.email,
        key: user.uid,
        userId: user.uid,
        contact: user.phoneNumber,
        isVerified: user.emailVerified,
      );
      createUser(model, newUser: true);
    } else {
      cprint('Last login at: ${user.metadata.lastSignInTime}');
    }
  }
*/
  /// Create new user's profile in db
  /*Future<String> signUp(UserModel userModel,
      {GlobalKey<ScaffoldState>? scaffoldKey, String? password}) async {
    try {
      loading = true;
      /*final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: password,
        url: userModel.url,
        */
      final result = await http
          .post(Uri.tryParse('http://10.0.2.2/racfmn/signup.php')!,
              body: json.encode({
                'email': userModel.email,
                'password': password,
              }))
          .catchError((error) {
        throw error;
      });
      /*user = result.user; */
      final responseData = json.decode(result.body);
      if (responseData['error'] != null)
        /*throw (responseData['error']['message']); */
        //final responseError = responseData['error']['message'];
        cprint(responseData['error']['message'], errorIn: 'signUp');
      authStatus = AuthStatus.LOGGED_IN;

      /* kAnalytics.logSignUp(signUpMethod: 'register'); 
      result.user.updateProfile(
          displayName: userModel.displayName, photoURL: userModel.profilePic); */

      _userModel = userModel;
      _userModel!.key = responseData['uid'];
      _userModel!.userId = responseData['uid'];
      /* createUser(_userModel as UserModel, newUser: true);
      return user.uid;  */
      getIt<SharedPreferenceHelper>().saveUserProfile(_userModel as UserModel);
      return responseData['uid'];
    } catch (error) {
      loading = false;
      cprint(error, errorIn: 'signUp');
      Utility.customSnackBar(
          scaffoldKey as GlobalKey<ScaffoldState>, error.toString());
      return null as Future<String>;
    }
  }
*/
  /// `Create` and `Update` user
  /// IF `newUser` is true new user is created
  /// Else existing user will update with new values
  /*void createUser(UserModel user, {bool newUser = false}) {
    if (newUser) {
      // Create username by the combination of name and id
      user.userName =
          Utility.getUserName(id: user.userId, name: user.displayName);
      kAnalytics.logEvent(name: 'create_newUser');

      // Time at which user is created
      user.createdAt = DateTime.now().toUtc().toString();
    }

    kDatabase.child('profile').child(user.userId).set(user.toJson());
    _userModel = user;
    loading = false;
  }
  */
Future<void>getUserPrefs() async{
  _isbusy = true;
    user = await getIt<SharedPreferenceHelper>().getUser();
var userName = user.userName;
    if(user != null) {
       _userModel = UserModel(
            email: user!.email,
            profilePic: user!.profilePic,
            userName: user!.userName,
            isVerified: user!.isVerified,
            userId: user!.userId,
            contact: user!.contact,
        dob: user!.dob,
        address: user!.address,
        state: user!.state,
        country: user!.country,
        philosophy: user!.philosophy,
        displayName: user!.displayName,
        displayLast: user!.displayLast);
            //return true;
            _isbusy = false;
            notifyListeners();
            
    } else {
      _isbusy = false;
      notifyListeners();
    }

  }
  /// Fetch current user profile
 Future<Map<String, Object>?> getCurrentUser() async {
    try {
      loading = true;
      Utility.logEvent('get_currentUSer');
      /*final userData = '{"error":  "null","uid": []}';
      print(userData);
      user = jsonDecode(userData);
      */
      final userPreference = await getIt<SharedPreferenceHelper>().getUser();
      /*
      userData =
          await http.post(Uri.tryParse('http://10.0.2.2/racfmn/getuser.php')!);
      user = json.decode(userData!.body);
      */
      var verified = userPreference.isVerified;
      print(verified);
      if ( userPreference.userId != null && userPreference.userName != null && userPreference.isVerified == 1) {
        authStatus = AuthStatus.LOGGED_IN;
        notifyListeners();
        modeluser = UserModel(
            email: userPreference.email,
            profilePic: userPreference.profilePic,
            userName: userPreference.userName,
            isVerified: userPreference.isVerified,
            userId: userPreference.userId,
            contact: userPreference.contact,
        dob: userPreference.dob,
        address: userPreference.address,
        state: userPreference.state,
        country: userPreference.country,
        philosophy: userPreference.philosophy,
        displayName: userPreference.displayName,
        displayLast: userPreference.displayLast);
         //Provider.of<AuthState>(context, listen: false).setUser(modeluser);
       // userId = user.userId;
        print(authStatus);
        //getProfileUser();
      } else {
        authStatus = AuthStatus.NOT_LOGGED_IN;
        notifyListeners();
        modeluser = null;
        print(authStatus);
      }
      loading = false;
      //return user;
    } catch (error) {
      loading = false;
      cprint(error, errorIn: 'getCurrentUser');
      authStatus = AuthStatus.NOT_LOGGED_IN;
      modeluser = null;
      //return null as Future<String>;
      
    }
    return {'authStatus': authStatus, 'modeluser': modeluser};
  }

  /// Reload user to get refresh user data
  void reloadUser() async {
    // await user.reload();
    /* user = _firebaseAuth.currentUser;
    if (user.emailVerified) {
      userModel.isVerified = true;
      // If user verifed his email
      // Update user in firebase realtime kDatabase
      createUser(userModel);
      cprint('UserModel email verification complete');
      Utility.logEvent('email_verification_complete',
          parameter: {userModel.userName: user.email});
          */
  }

  Future<Map<String, dynamic>> resendCode(String email, {GlobalKey<ScaffoldState>? scaffoldkey}) async{
  var data = "${Constants.resendcode}?userEmail=${email}";
  Map<String, dynamic>? responseData;
  var result;
  dynamic errorData;
  dynamic success;
  dynamic didinsert;
  dynamic didupdate;
  try {
  final Response sendData = await http.get(Uri.parse(data), headers: {'ContentType' : 'application/json'});
  final Map<String, dynamic> returnedData = json.decode(sendData.body);
   success = returnedData["message"]["success"];
   didinsert = returnedData["message"]["didInsert"];
  didupdate = returnedData["message"]["didupdate"];
   if(sendData.statusCode == 200 && success == true && (didupdate == true || didinsert == true)) {
     result = {
       "status" : true,
       "message" : "Successful"
     };

   } else {
   result = {
     "status" : false,
     "message" : "failed"
   };
   }

   

  } catch(ex) {
  result = {
    "success" : false,
    "message" : "Unsuccessful request"
  } ;
  
  
  }
return result;
  }

  /// Send email verification link to email2
  Future<Map<String, dynamic>> sendEmailVerification(String userId, String email, String token,{
      GlobalKey<ScaffoldState>? scaffoldKey}) async {
    
  
var data = "${Constants.verifyEmail}?userId=${userId}&userEmail=${email}&userToken=${token}";
    Map<String, dynamic>?responseData;
    try {
      authStatus  = AuthStatus.AUTHENTICATING;
      notifyListeners();
    final Response sendData = await http.get(Uri.parse(data), 
    headers : {'ContentType' : 'application/json'});
    responseData = await onValue(sendData, firstString: 'wrong', messageString: 'Your email has been verified', failedMessage: 'Verification failed', isEnabled: true);
   
    } catch (e) {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      responseData = {'status' : false, 'message' : 'unsuccessful request', 'data' : e};
    }
    return responseData;

  }

  /// Check if user's email is verified
  Future<Map<String, dynamic>> emailVerified(String email, {GlobalKey<ScaffoldState>? scaffoldkey}) async {
    var data = "${Constants.checkEmail}?userEmail=${email}";
    var result;
   Map<String, dynamic> returnedData;
   try {
    final Response checkEmail = await http.get(Uri.parse(data),
    headers: {'ContentType' : 'application/json'});
    
   returnedData  = json.decode(checkEmail.body);
   final responseSuccess = returnedData["message"]["success"];
  
  
   if(checkEmail.statusCode == 200 && responseSuccess == true) {
     result = {
       "status" : true,
       "message" : "Email found"

     };
   } else if(checkEmail.statusCode == 200 && responseSuccess == false) {
     result = {
       "status" : false,
       "message" : "Nothing"
     };
   } else {
     result = {
       "status" : false,
       "message" : "unknown"
     }; 
   }
    
    } catch(ex) {
     result = {
       "status" : false,
       "message" : "Network connection"
     }; 
     
    }
    return result;
    
    

  }


  Future<Map<String, dynamic>> emailClicked(String email, {GlobalKey<ScaffoldState>? scaffoldkey}) async {
    var data = "${Constants.clickedEmail}?userEmail=${email}";
    var result;
   Map<String, dynamic> returnedData;
   try {
    final Response checkEmail = await http.get(Uri.parse(data),
    headers: {'ContentType' : 'application/json'});
    
   returnedData  = json.decode(checkEmail.body);
   final responseSuccess = returnedData["message"]["success"];
   //final responseData = returnedData["data"];
   //final userEmail = responseData["email"];
   if(responseSuccess == true && checkEmail.statusCode == 200) {
     result = {
       "status" : true,
       "message" : "Link clicked"

     };
   } else if(checkEmail.statusCode == 200 && responseSuccess == false) {
     result = {
       "status" : false,
       "message" : "Not yet"
     };
   } else {
     result = {
       "status" : false,
       "message" : "unknown"
     }; 
   }
    
    } catch(ex) {
     result = {
       "status" : false,
       "message" : "Network"
     }; 
    }
    return result;
    
    

  }

  /// Send password reset link to email
  Future<void> forgetPassword(String email,
      {GlobalKey<ScaffoldState>? scaffoldKey}) async {
    try {
      var forgetData = await http
          .post(Uri.tryParse('http://10.0.2.2/racfmn/verifymail.php')!,
              body: json.encode({email: email}))
          .catchError((error) {
        cprint(error.toString());
        return false;
      });
      final response = json.decode(forgetData.body);
      if (response['error'] != null) {
        throw (response['error']['message']);
      }
      Utility.customSnackBar(scaffoldKey as GlobalKey<ScaffoldState>,
          '''A reset password link is sent yo your mail.You can reset your password from there''');
      Utility.logEvent('forgot+password');
    } catch (error) {
      Utility.customSnackBar(
          scaffoldKey as GlobalKey<ScaffoldState>, error.toString());
      return Future.value(false);
    }

    //return null as Future<void>;
  }

  /// `Update user` profile
  Future<void> updateUserProfile(UserModel userModel,
      {File? image, File? bannerImage}) async {
    /*
    try {
      if (image == null && bannerImage == null) {
        createUser(userModel);
      } else {
        /// upload profile image if not null
        if (image != null) {
          /// get image storage path from server
          userModel.profilePic = await _uploadFileToStorage(image,
              'user/profile/${userModel.userName}/${Path.basename(image.path)}');
          // print(fileURL);
          var name = userModel?.displayName ?? user.displayName;
          _firebaseAuth.currentUser
              .updateProfile(displayName: name, photoURL: userModel.profilePic);
        }

        /// upload banner image if not null
        if (bannerImage != null) {
          /// get banner storage path from server
          userModel.bannerImage = await _uploadFileToStorage(bannerImage,
              'user/profile/${userModel.userName}/${Path.basename(bannerImage.path)}');
        }

        if (userModel != null) {
          createUser(userModel);
        } else {
          createUser(_userModel as UserModel);
        }
      }

      Utility.logEvent('update_user');
    } catch (error) {
      cprint(error, errorIn: 'updateUserProfile');
    }
    */
  }
  

  Future<String> _uploadFileToStorage(File file, path) async {
    /* var task = _firebaseStorage.ref().child(path);
    var status = await task.putFile(file);
    print(status.state);

    /// get file storage path from server
    return await task.getDownloadURL();
    */
    return null as String;
  }

  /// `Fetch` user `detail` whoose userId is passed
  Future<UserModel> getuserDetail(String userId) async {
    UserModel user;
    // var snapshot = await kDatabase.child('profile').child(userId).once();
    var userid = await http
        .post(Uri.tryParse('http://10.0.2.2/racfmn/userdetail.php')!,
            body: json.encode({'userid': userId}))
        .catchError((error) {
      throw error;
    });
    var snapshot = json.decode(userid.body);
    if (snapshot['error'] == null) {
      var map = snapshot.value;
      user = UserModel.fromJson(map);
      return user;
    } else {
      return null as Future<UserModel>;
    }
  }

  /// Fetch user profile
  /// If `userProfileId` is null then logged in user's profile will fetched
  /*Future<void> getProfileUser({String? userProfileId}) async {
    try {
      loading = true;

      userProfileId = userProfileId == null ? user.uid : userProfileId;
      /* kDatabase
          .child('profile')
          .child(userProfileId)
          .once()
          .then((DataSnapshot snapshot) {
            */
      var userData = await http
          .post(Uri.tryParse('http://10.0.2.2/racfmn/profile.php')!,
              body: json.encode({'userid': userProfileId}))
          .catchError((error) {
        throw error;
      });
      var snapshot = json.decode(userData.body);
      if (snapshot.value != null) {
        var map = snapshot.value;
        if (map != null) {
          if (userProfileId == user.uid) {
            _userModel = UserModel.fromJson(map);
            _userModel!.isVerified = user.emailVerified;
            if (!user.emailVerified) {
              // Check if logged in user verified his email address or not
              reloadUser();
            }
            if (_userModel!.fcmToken == null) {
              updateFCMToken();
            }

            getIt<SharedPreferenceHelper>()
                .saveUserProfile(_userModel as UserModel);
          }

          Utility.logEvent('get_profile');
        }
      }
      loading = false;
    } catch (error) {
      loading = false;
      cprint(error, errorIn: 'getProfileUser');
    }
  }
*/
  /// if firebase token not available in profile
  /// Then get token from firebase and save it to profile
  /// When someone sends you a message FCM token is used
  /*void updateFCMToken() {
    if (_userModel == null) {
      return;
    }
    getProfileUser();
    /* _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      _userModel.fcmToken = token;
      createUser(_userModel);
    });
    */
  }
*/
  /// Trigger when logged-in user's profile change or updated
  /// Firebase event callback for profile update
  /*void _onProfileChanged(event) {
    if (event.snapshot != null) {
      final updatedUser = UserModel.fromJson(event.snapshot.value);
      _userModel = updatedUser;
      cprint('UserModel Updated');
      notifyListeners();
    }
  }
  */
}

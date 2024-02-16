import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:racfmn/helper/api.dart';
import 'package:racfmn/helper/constant.dart';
import 'package:racfmn/helper/enum.dart';
import 'package:racfmn/helper/functions.dart';
import 'package:racfmn/model/category.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:racfmn/ui/page/hometabs/projecttab.dart';

class HomeProvider with ChangeNotifier {
  var isLoading = false;
  TestFeed top = TestFeed();
  HttpClient client = new HttpClient();
  
  List<TestFeed>? _myList;
  set myList(List<TestFeed> newValue) {
    _myList = newValue;

  }
  List<TestFeed> get myList => _myList as List<TestFeed>;
  Dio dio = Dio();
  TestFeed recent = TestFeed();
  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;
  Api api = Api();
 Future<List<TestFeed>> fetchGalleryData() async {
   isLoading = true;
     /* 
  client.badCertificateCallback = ((X509Certificate cert, String host, int port) {
    final isValidHost = host == "hephziland.org";
    return isValidHost;
  }); 
  */    
    var uri = Uri.parse(Constants.dataTest);
    final response = await http.get(uri, headers: {"Content-Type": "application/json"}).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      //return compute(parseGalleryData, response.body);
     isLoading = false;
    /* Map<String, dynamic> data = jsonDecode(response.body);
     print(data);
     print(data["arrayValues"]);
     var splitoff = data['arrayValues'];

     final splitted = jsonEncode(splitoff);
     */
    // return compute(parseGalleryData, response.body);
     List<TestFeed> dataREturned = jsonDecode(response.body).map((item) =>
     TestFeed.fromJson(item)).toList().cast<TestFeed>();
     return dataREturned;
     //eturn(json.decode(response.body) as List).map((data) => TestFeed.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load books');
    }
     
}

  getFeeds() async {
    //setApiRequestStatus(APIRequestStatus.loading);
    try {
      TestFeed popular = await getCategory(Constants.dataTest);
      setTop(popular);
     /* CategoryFeed newReleases = await getCategory(Constants.recent);
      setRecent(newReleases);
      */
      //setApiRequestStatus(APIRequestStatus.loaded);
    } catch (e) {
      checkError(e);
    }
  }

Future<TestFeed> getCategory(String url) async {
    var res = await dio.get(url).catchError((e) {
      throw(e);
    });
    TestFeed testfeed;
    if (res.statusCode == 200) {
     // Xml2Json xml2json = new Xml2Json();
      //xml2json.parse(res.data.toString());
      var json = jsonDecode(res.data.toString());
      testfeed = TestFeed.fromJson(json);
    } else {
      throw ('Error ${res.statusCode}');
    }
    return testfeed;
  }
  void checkError(e) {
    if (Functions.checkConnectionError(e)) {
      setApiRequestStatus(APIRequestStatus.connectionError);
    } else {
      setApiRequestStatus(APIRequestStatus.error);
    }
  }

  void setApiRequestStatus(APIRequestStatus value) {
    apiRequestStatus = value;
    notifyListeners();
  }

  void setTop(value) {
    top = value;
    //notifyListeners();
  }

  TestFeed getTop() {
    return top;
  }

  void setRecent(value) {
    recent = value;
    notifyListeners();
  }

  TestFeed getRecent() {
    return recent;
  }
}

List<TestFeed>parseGalleryData(String responseBody) {
  //final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  final parsed = Map<String, String>.from(json.decode(responseBody));
  //return parsed.map<TestFeed>((json) => TestFeed.fromJson(json)).toList();
  print(parsed);
  return null as List<TestFeed>;


}

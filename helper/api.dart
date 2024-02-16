// ignore_for_file: unnecessary_statements

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';
import 'package:racfmn/helper/constant.dart';
import 'package:racfmn/model/category.dart';
import 'package:racfmn/model/search_model.dart';
import 'package:racfmn/model/user.dart';


class Api {
  Dio dio = Dio();

  Future<CategoryFeed> getCategory(String bookId) async {
    var res = await dio.get(bookId).catchError((e) {
      throw(e);
    });
    CategoryFeed category;
    if (res.statusCode == 200) {
     // Xml2Json xml2json = new Xml2Json();
     // xml2json.parse(res.data.toString());
     
      var json = jsonDecode(res.data.toString());
      print(json);
      category = CategoryFeed.fromJson(json);
    } else {
      throw ('Error ${res.statusCode}');
    }
    return category;
  }


  static Future<List<Rating>> getRating(
    int ratingNumber,
    String bookId,
  String userId,
  ) async {

  
  final Map<String, dynamic> ratingData = {

    'ratingNumber': ratingNumber,
    'bookId': bookId,
    'userId': userId
  };
  try {
    final response = await http.post(
      characterList(Constants.rating),
      body: json.encode(ratingData),
      headers: {'Content-TYpe': 'application/json'});
   final Map<String, dynamic> responseData = json.decode(response.body);

var success = responseData["success"];
var didInsert = responseData["didinsert"];
var result;
var error = responseData["error"];
if(response.statusCode == 200) {
var count = responseData["count"];
var average = responseData["average"];
var dataS = responseData["message"]["data"];
var commentData = responseData["message"]["comment"];
print('data returned from rating is ${dataS}');
  List<Rating> datasReturned = dataS.map<Rating>((item) => Rating.fromJson(item)).toList();
  //List<Comment> commentReturned = commentData.map<Comment>((item) => Comment.fromJson(item)).toList();
  print('This is rating data ${datasReturned}');
  //List<Comment> commentReturned = [];
  
  return datasReturned;
}
List<Rating>datasReturned = [];
print(error);
return datasReturned;
  } on SocketException {
throw NoConnectionException();
  }
  
  }
  
static Future<List<UserModel>> getProfile(
  String userId
) async{

var profileData = "${Constants.profile}?id=${userId}";
try {
final profile = await http.get(characterList(profileData),
headers: {'Content-TYpe': 'application/json'}
);
final Map<String, dynamic> profileResponse = json.decode(profile.body);
var success = profileResponse["profileMessage"]["success"];
if(profile.statusCode == 200 && success == true) {

  var finalResponseData = profileResponse["profileMessage"]["data"];
  print(finalResponseData);
  List<UserModel> returnedData = finalResponseData.map((item) => UserModel.fromJson(item)).toList().cast<UserModel>();
  return returnedData;
}
List<UserModel> returnedData = [];
return returnedData;

} on SocketException {
  throw NoConnectionException();
}
}


static Future<List<Comment>> getAllComment(
  int offset,
  num pageSize,
  int bookId
  ) async {

  
  var uri = '${Constants.allcomment}?offset=${offset}&pageSize=${pageSize}&bookId=${bookId}';
 
 
  try {
    final response = await http.get(
      characterList(uri),
      //body: json.encode(commentData),
      headers: {'Content-TYpe': 'application/json'});
   final Map<String, dynamic> responseData = json.decode(response.body);
print(responseData);
var success = responseData["commentMessage"]["success"];
//var didInsert = responseData["message"]["didinsert"];

//var error = responseData["error"];
if(response.statusCode == 200 && success == true) {
//var count = responseData["count"];
//var average = responseData["average"];
var dataS = responseData["commentMessage"]["data"];
print('data returned from comment is ${dataS}');
  List<Comment> datasReturned = dataS.map<Comment>((item) => Comment.fromJson(item)).toList();
  print('This is comment data ${datasReturned}');
  return datasReturned;
}
List<Comment>datasReturned = [];
//print(error);
//datasReturned.add(error);
return datasReturned;

  } on SocketException {
throw NoConnectionException();
  }
  
  }


static Future<List<Comment>> getComment(
  dynamic bookId,
  ) async {

  
  var uri = '${Constants.comment}?bookId=${bookId}';
  try {
    final response = await http.get(
      characterList(uri),
      headers: {'Content-TYpe': 'application/json'});
   final Map<String, dynamic> responseData = json.decode(response.body);
print(responseData);
var success = responseData["commentMessage"]["success"];
//var didInsert = responseData["message"]["didinsert"];

//var error = responseData["error"];
if(response.statusCode == 200 && success == true) {
//var count = responseData["count"];
//var average = responseData["average"];
var dataS = responseData["commentMessage"]["data"];
print('data returned from comment is ${dataS}');
  List<Comment> datasReturned = dataS.map<Comment>((item) => Comment.fromJson(item)).toList();
  print('This is comment data ${datasReturned}');
  return datasReturned;
}
List<Comment>datasReturned = [];
//print(error);
//datasReturned.add(error);
return datasReturned;

  } on SocketException {
throw NoConnectionException();
  }
  
  }


static Future<Map<String, dynamic>> postComment(
    String comment,
    dynamic bookId,
  dynamic userId,
  ) async {

  
  final Map<String, dynamic> commentData = {

    'content': comment,
    'bookId': bookId,
    'userId': userId
  };
  try {
    final response = await http.post(
      characterList(Constants.comment),
      body: json.encode(commentData),
      headers: {'Content-TYpe': 'application/json'});
   final Map<String, dynamic> responseData = json.decode(response.body);
print(responseData);
var success = responseData["messaged"]["success"];
var didinsert = responseData["messaged"]["didinsert"];
var result;
if(response.statusCode == 200 && success == true &&  didinsert == true) {
var commentdataS = responseData["messaged"]["data"];
var commentInserted = responseData["messaged"]["didinsert"];
print('data returned from comment is ${commentdataS}');
  List<Comment> datasReturned = commentdataS.map<Comment>((item) => Comment.fromJson(item)).toList();
var didInsert = true;
  //List<Comment> commentReturned = commentData.map<Comment>((item) => Comment.fromJson(item)).toList();
  print('This is rating data ${datasReturned}');

  result = {
    'commentResult' : datasReturned,
    'commentInserted' : didInsert
  };
  return result;
} else if(success == true && didinsert == false) {
  var commentdatas = responseData["messaged"]["data"];
  var commentInserted = responseData["messaged"]["didinsert"];
 List<Comment> datasReturned = commentdatas.map<Comment>((item) => Comment.fromJson(item)).toList();
 var didInsert = commentInserted;
  result = {
    'commentResult' : datasReturned,
    'commentInserted' : didInsert
  };
  return result;

}
List<Comment> datasReturned = [];
var commentInserted = responseData["messaged"]["didinsert"];
 result = {
    'commentResult' : datasReturned,
    'commentInserted' : commentInserted
  };
  return result;
  } on SocketException {
throw NoConnectionException();
  }
  
  }
  
static String _buildSearchTermQuery(String? searchTerm) =>
      searchTerm != null && searchTerm.isNotEmpty
          ? '${searchTerm.replaceAll(' ', '+').toLowerCase()}'
          : '';  

static Future<List<Search>> getSerachResult(
  int offset,
  int pageSize,
  String? searchData
) async {
try {
var searchUri = "${Constants.search}?offset=${offset}&pageSize=${pageSize}&searchData=${_buildSearchTermQuery(searchData)}";
final searchResponse = await http.get(characterList(searchUri),
                  headers: {'Content-Type': 'application/json'}
);

final searchResponseData = json.decode(searchResponse.body);

var searchSuccess = searchResponseData["searchMessage"]["success"];
print(searchSuccess);
if(searchResponse.statusCode == 200 && searchSuccess == true) {
  var searchResult = searchResponseData["searchMessage"]["data"];
   print("I was called");
  List<Search> searchDataReturned = searchResult.map((item) => Search.fromJson(item)).toList().cast<Search>();
 
  return searchDataReturned;
}else {
            //print(GenericHttpException());
          throw GenericHttpException();
      }

} on SocketException {
  throw NoConnectionException();
}
}
   static Future<List<TestFeed>> getalldata(
    int offset,
    int limit,
    String poststype 
    
  ) async  {
    /*final Map<String, dynamic> searchData = {
      
        'offset': offset,
        'limit': limit

      };
      */
      var getbookdata = "${Constants.alldata}?offset=${offset}&limit=${limit}&postsType=${poststype}";
      try {
      final response = await http
          .get(
            characterList(getbookdata ),
           // body: json.encode(searchData),
        // headers: {'Content-Type': 'application/json'}
          );
          final Map<String, dynamic> responseData = json.decode(response.body);
        
     var success;
               var error;
               
               success = responseData["message"]["success"];
          if(response.statusCode == 200 && success == true) {
            //print(1 + response.statusCode);
            var originalData = responseData["message"];
            var dataS = responseData["message"]["data"];
            List<TestFeed> datasReturned = dataS.map((item) =>
     TestFeed.fromJson(item)).toList().cast<TestFeed>();
     print(originalData);
    return datasReturned;
          } else {
           List<TestFeed> datasReturned = [];  
          return datasReturned;
      }
    } on SocketException {
      throw NoConnectionException();
    }
     
     
        
  }

static Future<List<TestFeed>> getUserOrders(
    int offset,
    int limit,
    dynamic userId 
    
  ) async  {
    
      var getOrders = "${Constants.orders}?offset=${offset}&limit=${limit}&user=${userId}";
      try {
      final response = await http
          .get(
            characterList(getOrders),
           // body: json.encode(searchData),
        // headers: {'Content-Type': 'application/json'}
          );
          final Map<String, dynamic> responseOrderData = json.decode(response.body);
        
     var success;
               var error;
               
               success = responseOrderData["message"]["success"];
          if(response.statusCode == 200 && success == true) {
            //print(1 + response.statusCode);
            var originalData = responseOrderData["message"];
            var OrderdataS = responseOrderData["message"]["data"];
            List<TestFeed> datasReturned = OrderdataS.map((item) =>
     TestFeed.fromJson(item)).toList().cast<TestFeed>();
     print(originalData);
    return datasReturned;
          } else {
           List<TestFeed> datasReturned = [];  
          return datasReturned;
      }
    } on SocketException {
      throw NoConnectionException();
    }
     
     
        
  }
  


static List<T> _parseItemListFromJsonArray<T>(
    List<dynamic> jsonArray,
    T Function(dynamic object) mapper,
  ) =>
      jsonArray.map(mapper).toList();

      static Uri characterList(
    String searchTerm,
  ) =>
      Uri.parse(
        searchTerm
      );
       
       
       
    static Future<List<TestFeed>> getRelatedCategory(
    String bookId,
    String courseId,
  ) async  {
   /* final Map<String, dynamic> searchData = {
      
        'bookId': bookId,
        'courseId': courseId
      };
      */
      var relatedCat = "${Constants.relatedcategory}?bookId=${bookId}&courseId=${courseId}";
      try {
      final response = await http
          .get(
            characterList(relatedCat),
          //  body: json.encode(searchData),
         headers: {'Content-Type': 'application/json'}
          );
          final Map<String, dynamic> responseData = json.decode(response.body);
        //print(responseData);
        
        //print(dataS);
       // print(response.statusCode);
              //List<TestFeed> datasReturned = [];
               var success;
               var error;
               
               success = responseData["message"]["success"];
          if(response.statusCode == 200 && success == true) {
            //print(1 + response.statusCode);
           // var data = responseData["message"]["data"];
           
           // if(success == true) {
            var dataS = responseData["message"]["data"];
            print(dataS);
            List<TestFeed> datasReturned = dataS.map<TestFeed>((item) =>
     TestFeed.fromJson(item)).toList();
    // print('Data returned is ${json.encode(datasReturned)}');
            return datasReturned;

            
          }
            //print(GenericHttpException());
          //  print(GenericHttpException());
         // throw GenericHttpException();
         print('Error is: ${error}');
       error = responseData["message"]["error"];
      List<TestFeed> datasReturned = [];
      //datasReturned.add(error);
      return datasReturned;
    } on SocketException {
      print(NoConnectionException());
      throw NoConnectionException();
    }
  }
  static Future<List<TestFeed>> getOthersAUthor (
    String authorId,
    String courseId,
    String authorsName,
  ) async  {
   /* final Map<String, dynamic> searchData = {
      
        'authorId': authorId,
        'courseId': courseId,
        'authorsName': authorsName
      };
      */
      var getotherauthor = "${Constants.authorbooks}?authorId=${authorId}&courseId=${courseId}&authorsName=${authorsName}";
      try {
      final response = await http
          .get(
            characterList(getotherauthor),
         //   body: json.encode(searchData),
         headers: {'Content-Type': 'application/json'}
          );
          final Map<String, dynamic> responseData = json.decode(response.body);
        //print(responseData);
        
        //print(dataS);
       // print(response.statusCode);
             
               var success;
               var error;
               success = responseData["message"]["success"];
          if(response.statusCode == 200 && success == true) {
            //print(1 + response.statusCode);
           // var data = responseData["message"]["data"];
           
           
         /*   print('${success} is true');
            var dataS = responseData["message"]["data"];
            print('Second data ${dataS}');
             List<TestFeed> datasReturned = dataS.map<TestFeed>((item) =>
     TestFeed.fromJson(item)).toList();
     */
   /* error = responseData["message"]["error"];
      List<TestFeed> datasReturned = [];
      datasReturned.add(error);
      print('value of --->${error}');
     return datasReturned;
*/
       var dataS = responseData["message"]["data"];
            print('Second data ${dataS}');
             List<TestFeed> datasReturned = dataS.map<TestFeed>((item) =>
     TestFeed.fromJson(item)).toList();   
     return datasReturned; 
        
          } 
          error = responseData["message"]["error"];
      List<TestFeed> datasReturned = [];
     // datasReturned.add(error);
      print('value of --->${error}');
     return datasReturned;
    } on SocketException {
      throw NoConnectionException();
    }
  }
/*
        Future<CategoryFeed> getRelatedCategory(String bookId) async {
    var res = await http.get(Uri.parse(bookId)).catchError((e) {
      throw(e);
    });
    CategoryFeed category;
    if (res.statusCode == 200) {
     // Xml2Json xml2json = new Xml2Json();
     // xml2json.parse(res.data.toString());
     
      var json = jsonDecode(res.data.toString());
      print(json);
      category = CategoryFeed.fromJson(json);
    } else {
      throw ('Error ${res.statusCode}');
    }
    return category;
  }
*/
}

class GenericHttpException implements Exception {}

class NoConnectionException implements Exception {}

extension on Future<http.Response> {
  Future<R> mapFromResponse<R, T>(R Function(T) jsonParser) async {
    try {
      final response = await this;
     /* print(response.statusCode);
      print(response.body); */
      if (response.statusCode == 200) {
        //var userData = response.body["message"];
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData);
        var dataS = responseData["message"]["data"];
        print(dataS);
        return jsonParser(dataS);
      } else {
        throw GenericHttpException();
      }
    } on SocketException {
      throw NoConnectionException();
    }
  }


}

  
  
  



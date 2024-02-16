import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:racfmn/components/download_alert.dart';
import 'package:racfmn/helper/api.dart';
import 'package:racfmn/helper/constant.dart';
import 'package:racfmn/helper/download_helper.dart';
import 'package:racfmn/helper/favorite_helper.dart';
import 'package:racfmn/model/category.dart';


class DetailsProvider extends ChangeNotifier {
  CategoryFeed related = CategoryFeed();
  List<TestFeed> _authorsrelated = <TestFeed>[];
List<Rating>_ratingData = <Rating>[];
List<Comment> _commentData = <Comment>[];
List<Comment> get commentData => _commentData;
List<Rating> get ratingData => _ratingData;
  List<TestFeed> _testfeed = [];
  List<TestFeed> get authorsrelated => _authorsrelated;
  List<TestFeed> get testfeed => _testfeed;  
  void setRelated(values) {
  _testfeed = values;
    notifyListeners();
  }
  void setComment(data) {
_commentData = data;
notifyListeners();
  }
 void setAuthorOthers(data) {
    _authorsrelated = data;
    notifyListeners();
  }
  void setRatingValue(data) {
    _ratingData = data;
    notifyListeners();
  }
  bool loading = true;
  Entry? entry;
 final favDB = FavouriteMethod();
  var dlDB = DownloadsDB();

  bool faved = false;
  bool downloaded = false;
  Api api = Api();

  getAuthorsOthersBook(String bookorauthorId,courseId,authorsName) async {
    
    try {
     // print("I was printed");
     
    final otherAuthor = await Api.getOthersAUthor(bookorauthorId,courseId,authorsName);
     
    //print("did I print");
     
     
     
      setAuthorOthers(otherAuthor);
      
     // print('value is ${json.encode(relatedfeed)}');
      setLoading(false);
    } catch (e) {
      setLoading(false);
      print(e);
    }
  }




getCategory(String bookorauthorId,courseId,authorsName) async {
    setLoading(true);
    checkFav(int.parse(bookorauthorId));
    //checkDownload();
    try {
     // print("I was printed");
     print("favorite was checked");
    final relatedfeed = await Api.getRelatedCategory(bookorauthorId,courseId);
     print("I went again");
  
     
      setRelated(relatedfeed);
     
     print("I finally went");
      setLoading(false);
    } catch (e) {
      setLoading(false);
      print(e);
    }
  }
/*
  updateComments(comment,ratingId,bookId) async {
   setLoading(true);
   try {

     final commentStatus = await Api.updateComment(comment,ratingId,bookId);
     print(commentStatus);
     setComment(commentStatus);
     setLoading(false);
     //print(commentStatus);
   } catch(e) {
     print(e);
   setLoading(false);
   }

  }
  */
  
  getsubmitRating(String bookorauthorId,userId,ratingNumber) async {
    setLoading(true);
    try {
final ratingDataS = await Api.getRating(ratingNumber,bookorauthorId,userId);
print("rating went");
 setRatingValue(ratingDataS);

 print("rating finally went");
 setLoading(false);

    } catch(e) {
      setLoading(false);
      print(e);
    }

  }




  // check if book is favorited
  checkFav(int bookid) async {
   try { 
     List c = await favDB.checkBooks(bookid);
    print(c);
    if (c.isNotEmpty) {
      setFaved(true);
    } else {
      setFaved(false);
    }
   } catch(e) {
     print(e);
   }
  }

  addFav(int id, String bookName, dynamic imageName, String authorName, int postCourseId, String description, String fullContent) async {
    dynamic imageUsed = imageName.toString().replaceFirst("../../", Constants.baseHttp);
    await favDB.insertBooks({'posts_id': id,'posts_title' : bookName, 'posts_links_url' : imageUsed, 'posts_author' : authorName, 'posts_content_url' : description, 'posts_course_id' : postCourseId, 'posts_content':fullContent});
    checkFav(id);
  }

  removeFav(int id) async {
   final v = favDB.delete(id).then((value) {
      print(value);
      checkFav(id);
  
  });}

  // check if book has been downloaded before
  checkDownload() async {
    List downloads = await dlDB.check({'posts_id': entry!.id!.t.toString()});
    if (downloads.isNotEmpty) {
      // check if book has been deleted
      String path = downloads[0]['path'];
      print(path);
      if(await File(path).exists()){
        setDownloaded(true);
      }else{
        setDownloaded(false);
      }
    } else {
      setDownloaded(false);
    }
  }

  Future<List> getDownload() async {
    List c = await dlDB.check({'posts_id': entry!.id!.t.toString()});
    return c;
  }

  addDownload(Map body) async {
    await dlDB.removeAllWithId({'posts_id': entry!.id!.t.toString()});
    await dlDB.add(body);
    checkDownload();
  }

  removeDownload() async {
    dlDB.remove({'posts_id': entry!.id!.t.toString()}).then((v) {
      print(v);
      checkDownload();
    });
  }

  Future downloadFile(BuildContext context, String url, String filename) async {
    //PermissionStatus permission = (await Permission.storage.isGranted) as PermissionStatus;
    final serviceStatus = await Permission.storage.isGranted;
    bool isStorage = serviceStatus == ServiceStatus.enabled;
    final status = await Permission.storage.request();
    if (status != PermissionStatus.granted) {
     /* await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      startDownload(context, url, filename);
      */
      await openAppSettings();
    } else {
      startDownload(context, url, filename);
    }
  }

  startDownload(BuildContext context, String url, String filename) async {
    Directory appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory() as Directory
        : await getApplicationDocumentsDirectory();
    if (Platform.isAndroid) {
      Directory(appDocDir.path.split('Android')[0] + '${Constants.appName}')
          .createSync();
    }

    String path = Platform.isIOS
        ? appDocDir.path + '/$filename.epub'
        : appDocDir.path.split('Android')[0] +
            '${Constants.appName}/$filename.epub';
    print(path);
    File file = File(path);
    if (!await file.exists()) {
      await file.create();
    } else {
      await file.delete();
      await file.create();
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => DownloadAlert(
        url: url,
        path: path,
      ),
    ).then((v) {
      // When the download finishes, we then add the book
      // to our local database
      if (v != null) {
        addDownload(
          {
            'posts_id': entry!.id!.t.toString(),
            'path': path,
            'image': '${entry!.link![1].href}',
            'size': v,
            'name': entry!.title!.t,
          },
        );
      }
    });
  }

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  
  CategoryFeed getRelated() {
    return related;
  }

  void setEntry(value) {
    entry = value;
    notifyListeners();
  }

  void setFaved(value) {
    faved = value;
    notifyListeners();
  }

  void setDownloaded(value) {
    downloaded = value;
    notifyListeners();
  }
}

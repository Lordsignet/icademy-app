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


class CommentProvider extends ChangeNotifier {
 
 
List<Comment> _commentData = <Comment>[];
List<Comment> get commentData => _commentData;
bool? _postedData;
bool? get postedData => _postedData;
  
  
  void setComment(data) {
_commentData = data;
notifyListeners();
  }
  void setDidInsert(data) {
    _postedData = data;
    notifyListeners();
  }
 
  bool loading = true;
  Entry? entry;
  final favDB = FavouriteMethod();
  var dlDB = DownloadsDB();

  bool faved = false;
  bool downloaded = false;
  Api api = Api();

  





  getComments(bookId) async {
   setLoading(true);
   try {

     final commentResult = await Api.getComment(bookId);
     print(commentResult);
     setComment(commentResult);
     setLoading(false);
     //print(commentStatus);
   } catch(e) {
     print(e);
   setLoading(false);
   }

  }
  
  postComments(comment,bookId, userId) async {
   setLoading(true);
   try {

     var commentResult = await Api.postComment(comment, bookId, userId);
     List<Comment> commentData = commentResult["commentResult"];
     bool didinserted = commentResult["commentInserted"];
     print(commentData);
     setComment(commentData);
     setDidInsert(didinserted);
     setLoading(false);
     //print(commentStatus);
   } catch(e) {
     print(e);
   setLoading(false);
   }

  }




  // check if book is favorited
  checkFav() async {
    List c = await favDB.checkBooks(int.parse(entry!.id!.t.toString()));
    if (c.isNotEmpty) {
      setFaved(true);
    } else {
      setFaved(false);
    }
  }

  addFav(int id, String bookName, dynamic imageName, String authorName) async {
    dynamic imageUsed = imageName.toString().replaceFirst("../../", Constants.baseHttp);
    await favDB.insertBooks({'posts_id': id, 'posts_title' : bookName, 'posts_links_url' : imageUsed, 'posts_author': authorName});
    //checkFav(id);
  }

  removeFav() async {
    favDB.delete(int.parse(entry!.id!.t.toString())).then((v) {
      print(v);
      checkFav();
    });
  }

  // check if book has been downloaded before
  checkDownload() async {
    List downloads = await dlDB.check({'id': entry!.id!.t.toString()});
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
    List c = await dlDB.check({'id': entry!.id!.t.toString()});
    return c;
  }

  addDownload(Map body) async {
    await dlDB.removeAllWithId({'id': entry!.id!.t.toString()});
    await dlDB.add(body);
    checkDownload();
  }

  removeDownload() async {
    dlDB.remove({'id': entry!.id!.t.toString()}).then((v) {
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
            'id': entry!.id!.t.toString(),
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

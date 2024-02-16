import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:racfmn/components/body_builder.dart';
import 'package:racfmn/helper/constant.dart';
import 'package:racfmn/state/home_provider.dart';

class Booktab extends StatefulWidget {
   dynamic? myFuture;
  @override
  _BooktabState createState() => _BooktabState();
}

class _BooktabState extends State<Booktab> with AutomaticKeepAliveClientMixin {
 
  @override
  void initState() {
    super.initState();
    HomeProvider homeprovider = Provider.of<HomeProvider>(context, listen: false);
   // widget.myFuture = homeprovider.getFeeds();
   widget.myFuture = homeprovider.fetchGalleryData();
   /* SchedulerBinding.instance!.addPostFrameCallback(
      (_) => Provider.of<HomeProvider>(context, listen: false).getFeeds(),
    );
    */
  }
  //Booktab({Key? key}) : super(key: key);
    //final String? productId;
  @override
  Widget build(BuildContext context) {
    //super.build(context);
    /*return Consumer<HomeProvider>(
      builder: (BuildContext context, HomeProvider homeProvider, _) {
        return Center(
          child: _buildBody(),
        );

      });

      */
 return Center(
          child: _buildBody(),
        );
  }
  
  Widget _buildBody() {
    HomeProvider homeProvider = Provider.of<HomeProvider>(context, listen: false);
    //widget.myFuture = homeProvider.getFeeds();
    return BodyBuilder(
      apiRequestStatus: homeProvider.apiRequestStatus,
      child: _buildBodyList(),
      //reload: () => homePrzxzovider.getFeeds(),
      reload: () => homeProvider.fetchGalleryData(),
    );
  }
 

  Widget _buildBodyList() {
    HomeProvider homeProvider = Provider.of<HomeProvider>(context, listen: false);
    //widget.myFuture = homeProvider.getFeeds();
    return RefreshIndicator(
      onRefresh: () => homeProvider.fetchGalleryData(),
      child: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    return Center(
    // padding: EdgeInsets.all(5),
    child: Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: NetworkImage(Constants.backgroundImage),
          fit: BoxFit.cover,
        ),
      ),
      child: FutureBuilder<List<String>>(
        future: widget.myFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
                itemCount: snapshot.data?.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 3,
                  mainAxisSpacing: 5.0,
                  crossAxisSpacing: 5.0,
                ),
                itemBuilder: (context, index) {
                  return Stack(
                    //padding: EdgeInsets.all(5),
                    children: <Widget>[
                      Positioned(
                        top: 128,
                        left: 0,
                        right: 0,
                        child: Container(
                            // color: Colors.white,
                            child: Column(
                          children: <Widget>[
                            Image.network(
                              Constants.coverImage,
                              width: 100.0,
                              fit: BoxFit.cover,
                              // height: 120.0,
                            ),
                          ],
                        )),
                      ),
                      Positioned(
                          top: 10,
                          left: 0,
                          right: 0,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                  
                               onTap: () {
                                 Navigator.pop(context);
       Navigator.of(context).pushNamed('/DetailScreen', arguments: 
       {'bookId': snapshot.data![index], 'bookName': snapshot.data![index]});
                               },
                                child:
                                Image.network(
                                  snapshot.data![index],
                                  width: 180.0,
                                  height: 120.0,
                                ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  );
                });
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    ),
  );
  }
   @override
  bool get wantKeepAlive => true;
}
/*

Future<List<String>> fetchGalleryData() async {
  try {
    var uri = Uri.parse(Constants.dataTest);
    final response = await http.get(uri).timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      return compute(parseGalleryData, response.body);
    } else {
      throw Exception('Failed to load');
    }
  } on SocketException catch (e) {
    throw Exception('Failed to load');
  }
}

List<String> parseGalleryData(String responseBody) {
  final parsed = List<String>.from(json.decode(responseBody));
  return parsed;
}
*/
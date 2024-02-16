import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:racfmn/helper/constant.dart';
import 'package:racfmn/model/category.dart';
import 'package:racfmn/state/home_provider.dart';
import 'package:racfmn/ui/page/details/details.dart';

class BookTab extends StatelessWidget {
  BookTab({Key? key, this.refreshIndicatorKey}) : super(key: key);
 final GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;
  @override
  Widget build(BuildContext context) {
    return Center(
      // padding: EdgeInsets.all(5),
      //child: containerMethod(),
      child: RefreshIndicator(
            key: refreshIndicatorKey,
            onRefresh: () async {
              /// refresh home page feed
              var feedState = Provider.of<HomeProvider>(context, listen: false);
              feedState.fetchGalleryData();
              return Future.value(true);
            },
            child: _BookBody(
              refreshIndicatorKey: refreshIndicatorKey as GlobalKey<RefreshIndicatorState>,
            ),
          )
    );
  }
}
class _BookBody extends StatelessWidget {
  
  final GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;

  const _BookBody({Key? key, this.refreshIndicatorKey})
      : super(key: key);

@override
  Widget build(BuildContext context) {
    //var authstate = Provider.of<HomeProvider>(context, listen: false);
    final state = Provider.of<HomeProvider>(context);
    var dataFetched = state.fetchGalleryData();
    final list = state.myList;
    print(dataFetched);
       return Center(
      // padding: EdgeInsets.all(5),
      child: Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: NetworkImage(Constants.backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<TestFeed>>(
          future: dataFetched,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print("${snapshot.data!.join()}");
              state.myList = snapshot.data as List<TestFeed>;
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
                              child:   Image.network(
                                    (snapshot.data![index]).image as String,
                                    width: 180.0,
                                    height: 120.0,
                                  ),
                                  onTap: ()  {
                                    Navigator.push(context, 
                                  Details.getRoute(snapshot.data![index].Id, snapshot.data![index].name,
                                  snapshot.data![index].image,snapshot.data![index].description,snapshot.data![index].authorName));}
                                  )
                                ],
                              ),
                            )),
                      ],
                    );
                  });
            } else if(snapshot.hasError) {
              
            return Text("${snapshot.error}");
             //return Text("Something went wrong, try again");

            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
        
}
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

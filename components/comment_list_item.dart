import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:racfmn/components/loading_widget.dart';

class CommentLIstItem extends StatelessWidget {

  CommentLIstItem({this.img, this.userHandle, this.text, this.datePosted, this.loadmore});
final String? img;
  final String? userHandle;
  final String? text;
  final String? datePosted;
  final Widget? loadmore; 

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1.0),
      decoration: BoxDecoration(
          color: Colors.white70,
         /* border: Border(bottom: BorderSide()) */),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        /*  CircleAvatar(
            child: Text(user.substring(0, 1)),
          ),
          */
          GestureDetector(
                onTap: () async {
                  // Display the image in large form.
                  print("Comment Clicked");
                },
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius: new BorderRadius.all(Radius.circular(50))),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage('$img'),
              ),
                ),
          ),
          _tweetContent()
        ],
      ),
    );
  }
  _tweetContent(){
    return Flexible(
      child: Container(
        margin: EdgeInsets.only(left: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('#${userHandle}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                Container(
                  margin: EdgeInsets.only(left: 130.0),
                  child: Text('${datePosted}',
                      style: TextStyle(color: Colors.grey),),
                )
              ],
            ),
            Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Text('${text}', style: TextStyle(color: Colors.black87, fontSize: 16))),
          /*  Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      loadmore as Widget
                     // Icon(Icons.thumb_up_sharp, color: Colors.greenAccent, size: 25),
                  /*    Container(
                        margin: EdgeInsets.only(left: 3.0),
                        child: Text("${loadmore}",
                            style: TextStyle(color: Colors.black87)),
                      )
                  */  ],
                  ),
                  
                 /* Row(
                    children: <Widget>[
                      Icon(Icons.thumb_down_sharp, color: Colors.deepOrange),
                      Container(
                        margin: EdgeInsets.only(left: 3.0),
                        child: Text("15",
                            style: TextStyle(color: Colors.black87)),
                      )
                    ],
                  ),
                 */
                ],
              ),
            )
            */
          ],
        ),
      ),
    );
  }
}
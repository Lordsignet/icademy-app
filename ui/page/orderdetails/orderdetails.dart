import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:racfmn/components/book_card.dart';
import 'package:racfmn/components/book_list_item.dart';
import 'package:racfmn/helper/constant.dart';
import 'package:racfmn/helper/custom_route.dart';
import 'package:racfmn/components/loading_widget.dart';
import 'package:racfmn/ui/page/readbooks/readPdfFile.dart';
import 'package:racfmn/ui/theme/theme.dart';
import 'package:racfmn/widgets/custom_flat_button.dart';
import 'package:racfmn/widgets/custom_widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;


class DetailsOrdered extends StatefulWidget {
  final int? bookId;
  final String? imageName;
  final String? fullContent;
  //final String? imgTag;
  final String? bookName;
  final String? userId;
  //final String? authorTag;

  DetailsOrdered({
    Key? key, this.bookId, this.bookName, this.imageName,this.fullContent,this.userId
  }) : super(key: key);

  static Route<Null> getRoute(int? bookId, String? bookName, String? imageName, String? fullContent,String userId) {
    return SlideLeftRoute<Null>(
            builder: (BuildContext context) => DetailsOrdered(
        bookId: bookId,
        bookName: bookName,
        imageName: imageName,
        fullContent: fullContent,
        userId: userId,
       
      ),
    );
  }

  @override
  _DetailsOrderedState createState() => _DetailsOrderedState();
}

class _DetailsOrderedState extends State<DetailsOrdered> {
  static final uuid = Uuid();
  final String imgTag = uuid.v4();
  final String titleTag = uuid.v4();
  final String authorTag = uuid.v4();
 final formKey = new GlobalKey<FormState>();
 final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
     
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
          appBar: AppBar(
             centerTitle: true,
            title: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(widget.bookName as String),
            )),
            body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            controller: _controller,
            children: <Widget>[
              SizedBox(height: 10.0),
               _buildImageTitleSection(),
                SizedBox(height: 5.0),
                _buildDownloadReadButton(Theme.of(context).primaryColor, widget.fullContent as String),
                 SizedBox(height: 5.0),
                 Text( widget.fullContent as String),
            ],));
  }
   _buildImageTitleSection() {
    //DetailsProvider detailsProvider = Provider.of<DetailsProvider>(context, listen: false);
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Hero(
            tag: '${widget.bookId.toString()}',
            child: CachedNetworkImage(
              imageUrl: '${widget.imageName!.replaceFirst("../../", Constants.baseHttp)}',
              placeholder: (context, url) => Container(
                height: 200.0,
                width: 130.0,
                child: LoadingWidget(),
              ),
              errorWidget: (context, url, error) => Icon(AppIcon.bulbOn),
              fit: BoxFit.cover,
              height: 200.0,
              width: 130.0,
            ),
          ),],));
}
 _buildDownloadReadButton(Color color, String value) {
   // DetailsProvider provider = Provider.of<DetailsProvider>(context, listen: false);
    //if (provider.downloaded) {
     
      return CustomFlatButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (contex) => ReadFileSCreen(filename: value)));
        //print("I was pressed");
        },
       // isWraped: true,
       overlayColor: MaterialStateColor.resolveWith((states) => Colors.blueAccent),
       label:    'Read',
       width: 10.0,
       color:    color,
       padding: EdgeInsets.fromLTRB(15, 1.0, 15, 1.0),
       labelStyle: GoogleFonts.mulish(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimary
      
      )
      );
 }
}
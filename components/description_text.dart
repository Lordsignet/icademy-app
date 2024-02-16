import 'package:flutter/material.dart';
import 'package:html/parser.dart';

class DescriptionTextWidget extends StatefulWidget {
  final String? text;

  DescriptionTextWidget({this.text});

  @override
  _DescriptionTextWidgetState createState() => _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String? firstHalf;
  String? secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();
    final String htmlStripped = _parseHtml('${widget.text!}');    
    if (htmlStripped.length > 300) {
      firstHalf = htmlStripped.substring(0, 300);
      secondHalf = htmlStripped.substring(300, htmlStripped.length);
    } else {
      firstHalf = htmlStripped;
      secondHalf = '';
    }
  }

String _parseHtml(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body!.text).documentElement!.text;
  return parsedString;
}
  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf!.isEmpty
          ? Text(
              '${flag ? (firstHalf) : (firstHalf !+ secondHalf!)}'
                  .replaceAll(r'\n', '\n')
                  .replaceAll(r'\r', '')
                  .replaceAll(r"\'", "'"),
              style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).textTheme.caption!.color,
              ),
            )
          : Column(
              children: <Widget>[
                Text(
                  '${flag ? (firstHalf !+ '...') : (firstHalf !+ secondHalf!)}'
                      .replaceAll(r'\n', '\n\n')
                      .replaceAll(r'\r', '')
                      .replaceAll(r"\'", "'"),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).textTheme.caption!.color,
                  ),
                ),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        flag ? 'show more' : 'show less',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}

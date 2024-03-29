import 'package:flutter/material.dart';
import 'package:racfmn/ui/theme/theme.dart';
import 'package:racfmn/widgets/newWidget/title_text.dart';


class EmptyList extends StatelessWidget {
  EmptyList(this.title, {this.subTitle});

  final String? subTitle;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: context.height - 135,
        color: TwitterColor.mystic,
        child: NotifyText(
          title: title as String,
          subTitle: subTitle as String,
        ));
  }
}

class NotifyText extends StatelessWidget {
  final String? subTitle;
  final String? title;
  const NotifyText({Key? key, this.subTitle, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TitleText(title as String, fontSize: 20, textAlign: TextAlign.center),
        SizedBox(
          height: 20,
        ),
        TitleText(
          subTitle.toString(),
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColor.darkGrey,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

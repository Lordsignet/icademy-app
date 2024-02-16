import 'package:flutter/material.dart';
import 'package:racfmn/ui/theme/theme.dart';
import 'package:racfmn/widgets/newWidget/custom_check_box.dart';
import 'package:racfmn/widgets/url_text/custom_url_text.dart';


class SettingRowWidget extends StatelessWidget {
  SettingRowWidget(
    this.title, {
    Key? key,
    this.navigateTo,
    this.subtitle,
    this.textColor,
    this.onPressed,
    this.vPadding = 0,
    this.showDivider = true,
    this.visibleSwitch,
    this.showCheckBox,
    this.styles,

  }) : super(key: key);
  bool? visibleSwitch, showDivider, showCheckBox;
  final String? navigateTo;
  final String? subtitle, title;
  final Color? textColor;
  final Function? onPressed;
  final double? vPadding;
  final TextStyle? styles;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
            contentPadding:
                EdgeInsets.symmetric(vertical: vPadding as double, horizontal: 18),
            onTap: () {
             // print("I was tapped");
            /*  if (onPressed != null) {
                onPressed!();
                return;
              }
              */
              if (navigateTo == null) {
                return;
              } else {
              
              Navigator.pushNamed(context, '/$navigateTo');
              }
            },
            title: title == null
                ? null
                : UrlText(
                    text: title ?? '',
                    style:  TextStyle(fontSize: 16, color: textColor),
                  ),
            subtitle: subtitle == null
                ? null
                : UrlText(
                    text: subtitle,
                    style: TextStyle(
                        color: textColor ?? TwitterColor.black,
                        fontWeight: FontWeight.w400),
                        urlStyle: TextStyle(
                          fontSize: 16,
                        color: textColor ?? TwitterColor.paleSky50,
                        fontWeight: FontWeight.w400),
                  ),
            trailing: CustomCheckBox(
              isChecked: showCheckBox,
              visibleSwitch: visibleSwitch,
            )),
        showDivider! ? SizedBox() : Divider(height: 0)
      ],
    );
  }
}

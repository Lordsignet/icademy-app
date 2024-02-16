import 'package:flutter/material.dart';
import 'package:racfmn/state/auth_state.dart';
import 'package:racfmn/ui/page/profile/widgets/circular_image.dart';
import 'package:racfmn/ui/theme/theme.dart';
import 'package:provider/provider.dart';

import 'custom_widgets.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar(
      {Key? key,
      this.title,
      this.actions,
      this.scaffoldKey,
      this.icon,
      this.textController,
      this.isBackButton = false,
      this.isCrossButton = false,
      this.submitButtonText,
      this.suffixIcon,
      this.leading,
      this.centerTile = false,
      this.textHold,
      this.onFieldSubmitted,
      this.onActionPressed,
      this.isSubmitDisable = true,
      this.isbootomLine = true,
      this.onSearchChanged})
      : super(key: key);

  final List<Widget>? actions;
  final Size? appBarHeight = Size.fromHeight(56.0);
  final IconData? icon;
  final bool isBackButton;
  final bool isbootomLine;
  final bool isCrossButton;
  final bool centerTile;
  final bool isSubmitDisable;
  final Widget? leading;
  final String? textHold;
  final void Function(String)? onFieldSubmitted;
  final Widget? suffixIcon;
  final Function? onActionPressed;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final String? submitButtonText;
  final TextEditingController? textController;
  final Widget? title;
  final ValueChanged<String>? onSearchChanged;

  @override
  Size get preferredSize => appBarHeight as Size;

  Widget _searchField() {
    return Container(
        height: 50,
        margin: EdgeInsets.fromLTRB(0, 1, 1, 1),
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
        alignment: Alignment.topLeft,
        child: TextFormField(
          onChanged: onSearchChanged,
          onFieldSubmitted: onFieldSubmitted,
          textInputAction: TextInputAction.search,
          controller: textController,
          autofocus: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
              borderRadius: const BorderRadius.all(
                const Radius.circular(25.0),
              ),
            
            ),
            suffixIcon: suffixIcon,
            hintText: 'Search Library..',
            fillColor: AppColor.extraLightGrey,
            filled: true,
            focusColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          ),
        ));
  }

  List<Widget> _getActionButtons(BuildContext context) {
    return <Widget>[
      submitButtonText != null
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
              child: Container(
                //padding: EdgeInsets.only(right: 10),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
               // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                decoration: BoxDecoration(
                  color: isSubmitDisable == null
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColor.withAlpha(150),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  submitButtonText as String,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ).ripple(
                () {
                  if (onActionPressed != null) onActionPressed!();
                },
                borderRadius: BorderRadius.circular(40),
              ),
            )
          : icon == null
              ? Container()
              : IconButton(
                  onPressed: () {
                    if (onActionPressed != null) onActionPressed!();
                  },
                  icon: customIcon(context,
                      icon: icon,
                      istwitterIcon: false,
                      iconColor: AppColor.primary,
                      size: 25),
                )
    ];
  }

  Widget _getUserAvatar(BuildContext context) {
    var authState = Provider.of<AuthState>(context);
    return Padding(
      padding: EdgeInsets.all(10),
      child: CircularImage(
        path: authState.userModel.profilePic as String,
        height: 30,
      ).ripple(() {
        scaffoldKey!.currentState!.openDrawer();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
     // iconTheme: IconThemeData(color: Colors.blue),
     // backgroundColor: Colors.white,
      centerTitle: centerTile ? true: false,
     leading: isBackButton
          ? BackButton() : Container(
       alignment: Alignment.topLeft,
     ), 
     titleSpacing: 0.0,

      title: Transform(transform: Matrix4.translationValues(-30.0, 0.0,0.0),
      child: title != null ? title : _searchField()),
      //actions: _getActionButtons(context),
      bottom: PreferredSize(
        child: Container(
          color: isbootomLine
              ? Colors.grey.shade200
              : Theme.of(context).backgroundColor,
          height: 1.0,
        ),
        preferredSize: Size.fromHeight(0.0),
      ),
    );
  }
}

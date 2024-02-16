import 'dart:async';

import 'package:flutter/material.dart';
import 'package:racfmn/ui/theme/theme.dart';
import 'package:racfmn/widgets/custom_app_bar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xml/xml.dart';

class CharacterSearchInputSliver extends StatefulWidget implements PreferredSizeWidget  {
  CharacterSearchInputSliver({
    Key? key,
    this.onChanged,
    this.debounceTime,
    this.onFieldSubmit,
    this.textHold,
    this.suffixIcon,
    this.controllers,
  }) : super(key: key);
  final ValueChanged<String>? onChanged;
  final void Function(String)? onFieldSubmit;
  final Duration? debounceTime;
  final Size? appBarHeight = Size.fromHeight(56.0);
  final String? textHold;
  final Widget? suffixIcon;
  final TextEditingController? controllers;

  @override
  _CharacterSearchInputSliverState createState() =>
      _CharacterSearchInputSliverState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => appBarHeight as Size;
}



class _CharacterSearchInputSliverState
    extends State<CharacterSearchInputSliver>  {
  final StreamController<String> _textChangeStreamController =
      StreamController();
  late StreamSubscription _textChangesSubscription;
bool isSearching = false;
final TextEditingController? _textController = TextEditingController();

  @override
  void initState() {
     _textChangesSubscription = _textChangeStreamController.stream
        .debounceTime(
          widget.debounceTime ?? const Duration(seconds: 3),
        )
        .distinct()
        .listen((text) {
      final onChanged = widget.onChanged;
      if (onChanged != null) {
        onChanged(text);
      }
    });
    
  
    super.initState();
  }


  @override
  Widget build(BuildContext context) =>  _customAppBar();
  

  @override
  void dispose() {
    _textChangeStreamController.close();
    _textChangesSubscription.cancel();
    super.dispose();
  }

  void _toggle() {
    setState(() {
  _textController!.clear();   
    });
  }
  
 Widget _customAppBar() {
   print("${_textController!.text}".length);
    return CustomAppBar(
         //submitButtonText: "Go",
          onSearchChanged: _textChangeStreamController.add,
         // isBackButton: true,
         // isCrossButton: true,
         textHold: _textController!.text,
         textController: widget.controllers,
        onFieldSubmitted: widget.onFieldSubmit,
       suffixIcon: widget.suffixIcon
          //controller: textController,
         );
  }

}

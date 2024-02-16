import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFlatButton extends StatelessWidget {
  const CustomFlatButton(
      {Key? key,
      this.onPressed,
      this.label,
      this.labelStyle,
      this.isLoading,
      this.color,
      this.width,
      this.overlayColor,
      this.isWraped = false,
      this.borderRadius,
      this.padding})
      : super(key: key);
  final Function? onPressed;
  final String? label;
  final TextStyle? labelStyle;
  final ValueNotifier<bool>? isLoading;
  final bool isWraped;
  final Color? color;
  final double? width;
  final MaterialStateProperty<Color>? overlayColor;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: isWraped ? width : double.infinity,
      child: ValueListenableBuilder<bool>(
        valueListenable: isLoading ?? ValueNotifier(false),
        builder: (context, loading, child) {
          return TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
              backgroundColor: MaterialStateProperty.all(
                loading
                    ? Theme.of(context).disabledColor
                    : color ?? Theme.of(context).primaryColor,
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius ?? 6.0)),
              ),
              overlayColor: overlayColor ?? MaterialStateProperty.all(
                  color ?? Theme.of(context).primaryColorDark),
              foregroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            onPressed: loading ? null : onPressed as Function(),
            child: loading
                ? SizedBox(
                    height: 22,
                    width: 22,
                    child: FittedBox(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                            color ?? Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  )
                : child as Widget,
          );
        },
        child: Text(
          label as String,
          style: labelStyle ??
              GoogleFonts.mulish(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:the_calendar_app/config/styles.dart';

class SCFlatButton extends StatelessWidget {
  final Widget child;
  final GestureTapCallback? onTap;
  final Color? textColor;
  final Color? backgroundColor;

  const SCFlatButton(
      this.child,
      {Key? key, this.textColor, this.backgroundColor, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Styles.primaryHighlightColor,
          foregroundColor: textColor ?? Colors.white,
          elevation: 1,
          textStyle: TextStyle(
            fontFamily: Styles.primaryFontRegular,
            fontWeight: Styles.primaryFontWeightLight,
            fontSize: Styles.primaryButtonFontSize,),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)))),
        child: child,
        onPressed: onTap,

    );
  }
}

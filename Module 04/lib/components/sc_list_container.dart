import 'package:flutter/material.dart';
import 'package:the_calendar_app/config/styles.dart';

class SCListContainer extends StatelessWidget {
  final List<Widget> children;
  const SCListContainer(this.children, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Styles.formBgColor,
        border: Border(
          bottom: Divider.createBorderSide(context,
              width: 1.0, color: Styles.dividerColor),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

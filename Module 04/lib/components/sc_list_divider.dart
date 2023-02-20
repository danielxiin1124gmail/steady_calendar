import 'package:flutter/material.dart';

import 'package:the_calendar_app/config/styles.dart';

class SCListDivider extends StatelessWidget {
  const SCListDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Styles.dividerColor,
      height: 1.0,
    );
  }
}

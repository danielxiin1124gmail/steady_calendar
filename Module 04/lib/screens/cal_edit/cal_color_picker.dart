import 'package:flutter/material.dart';
import 'package:the_calendar_app/config/constants.dart';
import 'cal_color_tile.dart';
import 'package:the_calendar_app/components/sc_nav_bar.dart';

class CalColorPicker extends StatelessWidget {
  static const String routeName = '/cal_edit/color_picker';
  const CalColorPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SCNavBar(
      title: 'Choose Color',
      child: ListView(
        children: colors
            .map((e) => CalColorTile(
                  e,
                  key: Key(e.hex),
                  onTap: () {
                    Navigator.of(context).pop(e.hex);
                    print('<cal_color_picker> e.hex = ${e.hex}');
                  },
                ))
            .toList(),
      ),
    );
  }
}

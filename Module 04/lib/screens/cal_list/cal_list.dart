import 'package:flutter/material.dart';
import 'package:the_calendar_app/screens/menu/menu.dart';
import 'package:provider/provider.dart';
import 'package:the_calendar_app/components/sc_nav_bar.dart';
import 'package:the_calendar_app/components/sc_footer_button.dart';
import 'package:the_calendar_app/providers/session_provider.dart';
import 'package:the_calendar_app/screens/cal_edit/cal_edit.dart';
import 'cal_list_tile.dart';

class CalList extends StatelessWidget {
  static const String routeName = '/cal_list';
  const CalList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionProvider>(builder: (context, session, _) {
      return SCNavBar(
        title: 'My Calendars',
        isModal: true,
        //M4_03-是否为Modal，意义在于我们要显示关闭按钮。
        child: Container(
          padding: const EdgeInsets.all(0.0),
          child: Stack(
            children: <Widget>[
              ListView(
                children: session.cals
                    .map((cal) => CalListTile(cal,
                        key: Key("cal-${cal.id}"),
                        onTap: () => Navigator.pushNamed(
                            context, CalEdit.routeName,
                            arguments: CalEditArguments(cal))))
                    .toList(),
              ),
              Positioned(
                left: 20.0,
                bottom: 20.0,
                child: SCFooterButton('assets/icons/icon-more@3x.png',
                    onTap: () => Navigator.pushNamed(context, Menu.routeName)),
              ),
              Positioned(
                  right: 20.0,
                  bottom: 20.0,
                  child: SCFooterButton('assets/icons/icon-plus@3x.png',
                      onTap: () => Navigator.pushNamed(
                          context, CalEdit.routeName,
                          arguments: CalEditArguments(null)))),
            ],
          ),
        ),
      );
    });
  }
}

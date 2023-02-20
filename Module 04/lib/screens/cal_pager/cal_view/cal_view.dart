import 'package:flutter/material.dart';
import 'package:the_calendar_app/providers/session_provider.dart';
import 'package:the_calendar_app/util/alert.dart';
import 'package:provider/provider.dart';
import 'package:the_calendar_app/models/calendar.dart';
import 'package:the_calendar_app/config/styles.dart';
import 'background.dart';
import 'month_grid.dart';

class CalView extends StatelessWidget {
  final Calendar cal;
  const CalView(this.cal, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // background
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [Background(cal.backgroundSlug)],
        ),

        // overlay
        Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(255, 255, 255, 0.65)),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 40.0),
                child: Text(
                  cal.name,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Styles.hexToColor(cal.colorHex),
                    fontFamily: Styles.primaryFontRegular,
                    fontSize: Styles.primaryHeaderFontSize,
                  ),
                ),
              ),
              MonthGrid(cal, _dateSelected, _dateDeselected),
            ],
          ),
        ),
      ],
    );
  }

  _dateSelected(BuildContext context, Calendar cal, DateTime date) {
    final session = Provider.of<SessionProvider>(context, listen: false);
    session.saveDate(cal, date).catchError(
        (e) => showAlert(context, '_dateSelected 出问题', e.toString()));
  }

  _dateDeselected(BuildContext context, Calendar cal, DateTime date) {
    final session = Provider.of<SessionProvider>(context, listen: false);
    session.deleteDate(cal, date).catchError(
        (e) => showAlert(context, '_dateDeselected 出问题', e.toString()));
  }
}

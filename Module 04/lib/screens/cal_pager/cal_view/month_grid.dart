import 'package:flutter/material.dart';
import 'package:the_calendar_app/util/alert.dart';
import 'package:the_calendar_app/models/calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:the_calendar_app/util/colors.dart';
import 'package:the_calendar_app/config/styles.dart';
import 'package:intl/intl.dart';

final now = DateTime.now();
final firstDay = DateTime(now.year - 3, now.month, now.day);
final lastDay = DateTime(now.year + 3, now.month, now.day);
//: 减三又加三，终于可以选前后三年时间了；或是说，至少能滑出前后三年日历，能不能点选再说。

class MonthGrid extends StatefulWidget {
  final Calendar cal;
  final Function(BuildContext, Calendar, DateTime) dateSelected;
  final Function(BuildContext, Calendar, DateTime) dateDeselected;
  const MonthGrid(this.cal, this.dateSelected, this.dateDeselected, {Key? key})
      : super(key: key);

  @override
  _MonthGridState createState() => _MonthGridState();
  //: 他本来是State<MonthGrid> createState() => _MonthGridState();试了都可以，没Error。
}

class _MonthGridState extends State<MonthGrid> {
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: firstDay,
      lastDay: lastDay,
      calendarStyle: CalendarStyle(
        todayTextStyle:
            _defaultTextStyle(color: hexToColor(widget.cal.colorHex)),
        todayDecoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7), shape: BoxShape.circle),
        selectedDecoration: BoxDecoration(
            color: hexToColor(widget.cal.colorHex), shape: BoxShape.circle),
        selectedTextStyle: _defaultTextStyle(color: Colors.white),
        weekendTextStyle: _defaultTextStyle(),
        defaultTextStyle: _defaultTextStyle(color: Styles.primaryTextColor),
        outsideTextStyle: _defaultTextStyle(color: Styles.tertiaryTextColor),
        disabledTextStyle: _defaultTextStyle(color: Styles.tertiaryTextColor),
      ),
      focusedDay: DateTime.now(),
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerStyle: HeaderStyle(
        leftChevronVisible: false,
        rightChevronVisible: false,
        // NOTE left padding takes cell size into account, in order to be left
        // flush aligned with calendar title above
        headerPadding: const EdgeInsets.fromLTRB(3.0, 20.0, 0.0, 20.0),
        titleTextFormatter: (date, locale) =>
            DateFormat.yMMMM(locale).format(date).toUpperCase(),
        titleTextStyle: _defaultTextStyle(color: Styles.tertiaryTextColor),
        formatButtonVisible: false, //这是啥?
        titleCentered: false,
      ),
      daysOfWeekHeight: 40.0,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: _defaultTextStyle(color: Styles.primaryTextColor),
        weekendStyle: _defaultTextStyle(color: Styles.primaryTextColor),
        dowTextFormatter: (date, locale) =>
            DateFormat.E(locale).format(date)[0],
      ),
      selectedDayPredicate: (day) => (widget.cal.dates != null &&
          widget.cal.dates!.containsKey(day.hashCode)),
      //M3_07- hashCode converts the DayTime value into an integer.
      //M3_07- 在calendar_date.dart里面，CalendarDates = HashMap<int, CalendarDate>，
      //M3_07- 所以the key is the integer of the hashcode of the DayTime,
      //M3_07- and the value is the CalendarDate。
      onDaySelected: (selectedDay, focusedDay) =>
          _onDaySelected(selectedDay, focusedDay), //M4_07
    );
  }

  _onDaySelected(selectedDay, focusedDay) {
    // alert and bail if a future date is selected
    // NOTE remember, TableCalendar always works with UTC values, so compare
    // them against only other UTC values
    if (selectedDay.isAfter(DateTime.now().toUtc())) {
      showAlert(context, '嘿!', 'Cannot select dates in the future.');
      return;
    }
    //: 把上面备注掉，就可以点选未来日期了。
    // either remove or add date
    setState(() {
      if (widget.cal.dates!.containsKey(selectedDay.hashCode)) {
        print('你刚刚点了一个刚刚已被选上的 $selectedDay ，'
            '他的 selectedDay.hashCode = ${selectedDay.hashCode}');
        print('点之前有没有containsKey? --> '
            '${widget.cal.dates!.containsKey(selectedDay.hashCode)}');
        widget.cal.dates!.remove(selectedDay.hashCode);
        print('现在，已把你刚刚点的 $selectedDay ，remove(selectedDay.hashCode) ，'
            '现在还有没有containsKey? ${widget.cal.dates!.containsKey(selectedDay.hashCode)}');
        widget.dateDeselected(context, widget.cal, selectedDay);
      } else {
        widget.cal.dates![selectedDay.hashCode] = selectedDay;
        widget.dateSelected(context, widget.cal, selectedDay);
      }
    });
  }

  TextStyle _defaultTextStyle({Color? color}) {
    return TextStyle(
      fontFamily: Styles.secondaryFontRegular,
      fontSize: Styles.smallTextFontSize,
      color: color,
    );
  }
}

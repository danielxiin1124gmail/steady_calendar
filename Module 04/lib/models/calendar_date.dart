import 'package:intl/intl.dart';
import 'dart:collection';

typedef CalendarDate = DateTime;
typedef CalendarDates = HashMap<int, CalendarDate>;
const String CalendarDateFormat = 'yyyy-MM-dd';
//M03_3-要使用typedef，至少sdk>=2.13.0。我此时是sdk: '>=2.18.2 <3.0.0'。

String calendarDateToString(CalendarDate value) {
  return DateFormat(CalendarDateFormat).format(value);
}

CalendarDate stringToCalendarDate(String value) {
  return DateTime.parse("$value 00:00:00Z");
  // NOTE unfortunately, parse() uses local time which would result in converting
  // a date only value to a DateTime with a non-zero hour value, therefore we
  // parse with explicit time and 'Z' to ensure we get a zero time in UTC
  // https://github.com/dart-lang/sdk/issues/37420
}

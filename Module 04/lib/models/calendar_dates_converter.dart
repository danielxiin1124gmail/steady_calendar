import 'dart:collection';
import 'package:json_annotation/json_annotation.dart';
import 'calendar_date.dart';

class CalendarDatesConverter
    implements JsonConverter<CalendarDates?, List<dynamic>?> {
  const CalendarDatesConverter();

  @override
  HashMap<int, DateTime> fromJson(List<dynamic>? json) {
    final CalendarDates datesHash = CalendarDates();

    if (json == null) {
      return datesHash;
    }
    // we'll receive a list of Map<String, dynamic> that contains only one map
    // entry

    json.forEach((value) {
      final dtMap = value as Map<String, dynamic>;
      if (dtMap.values.isNotEmpty) {
        final dateString = dtMap.values.first;
        final date = stringToCalendarDate(dateString);
        datesHash[date.hashCode] = date;
        //M3_07-电脑会从Supabase获取Json，意即List<dynamic>?> of DayTime Values as a String。
        //M3_07-然后，我们用stringToCalendarDate(dateString)来convert to DayTime Value (见calendar_date.dart)。
        //M3_07-最后，it adds to our HashMap --> datesHash[date.hashCode] = date。
        //M3_07-因此，在month_grid.dart 才能有 selectedDayPredicate 这一行。
      }
    });
    return datesHash;
  }

  @override
  List<dynamic>? toJson(CalendarDates? dates) {
    return null;
    // NOTE not needed because we do not submit calendar dates when saving a
    // calendar
  }
}

import 'package:the_calendar_app/config/constants.dart';
import 'package:the_calendar_app/repositories/cal_repo_interface.dart';
import 'package:the_calendar_app/models/calendar.dart';

class MockCalendarRepository extends CalRepoInterface {
  List<Calendar> cals = [
    Calendar(
        id: 1,
        name: 'mock_untitled1',
        colorHex: colors.first.hex,
        backgroundSlug: backgrounds.first),
    Calendar(
        id: 2,
        name: 'mock_untitled2',
        colorHex: colors.last.hex,
        backgroundSlug: backgrounds.last),
  ];
  @override
  Future<List<Calendar>> refreshCalendars() async {
    return cals;
  }

  @override
  Future<void> saveCalendar(Calendar cal) async {
    return;
  }

  @override
  Future<void> deleteCalendar(Calendar cal) async {
    return;
  }

  @override
  Future<void> saveDate(Calendar cal, DateTime date) async {
    return;
  }

  @override
  Future<void> deleteDate(Calendar cal, DateTime date) async {
    return;
  }
}

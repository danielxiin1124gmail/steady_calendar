import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:the_calendar_app/repositories/cal_repo_interface.dart';
import 'package:the_calendar_app/models/calendar.dart';
//: 貌似要用ChangeNotifier，就得加上foundation或widgets其中一个；两个都不加会error。择一不error。

class SessionProvider extends ChangeNotifier {
  List<Calendar> _cals = [];
  List<Calendar> get cals => _cals;
  CalRepoInterface calRepo;
  SessionProvider(this.calRepo);
  //: (M3_09)这里说自定义的SessionProvider，包含格式为List<Calendar>的_cals(空值)，感觉空值都放个下底线较严谨。
  //: 然后，因为其他页面要引用"session.cals.map(....)"，但有下底线的仅限于此页，因此要搞个 cals 等于 _cals。
  //: 然后，不能仅说 List<Calendar> cals = _cals；要说 get cals => _cals。其他页面仅能来get值，不能编辑值。
  //: 定义CalRepoInterface calRepo，这样一来在app_test.dart里面，可以方便的改成calRepo = MockCalendarRepository()。
  //: CalRepoInterface只是一个端口(Interface)，他其实指两件事：calendarRepository 与 MockCalendarRepository。
  //: 上面两件事可以在app.dart 与 app_test.dart里面看到。

  refreshCalendars() async {
    _cals = await calRepo.refreshCalendars();
    notifyListeners();
    print('<session_provider> 此时，cals = $cals');
    //: refreshCalendars 能做CalRepoInterface(蓝图)的五件事：ref/save/save/del/del。
    //: 然后，cal_repo.dart里面，CalendarRepository implements CalRepoInterface(蓝图)。
    //: 所以，那五件事真正的代码逻辑，是写在cal_repo.dart里面。
    //: refresh了，有变动了，估计就是得notifyListeners 说，有东西变了、refresh了。
    //M4_02-这里四个不需要加上notifyListeners，老师意思貌似是这会自动触发，
  }

  saveCalendar(Calendar cal) async {
    return calRepo.saveCalendar(cal);
  }

  deleteCalendar(Calendar cal) async {
    return calRepo.deleteCalendar(cal);
  }

  saveDate(Calendar cal, DateTime date) async {
    return calRepo.saveDate(cal, date);
  }

  deleteDate(Calendar cal, DateTime date) async {
    return calRepo.deleteDate(cal, date);
  }
}

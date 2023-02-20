import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:the_calendar_app/models/calendar.dart';
import 'package:the_calendar_app/models/calendar_date.dart';
import 'cal_repo_interface.dart';

class CalendarRepository implements CalRepoInterface {
  const CalendarRepository();

  @override
  Future<List<Calendar>> refreshCalendars() async {
    print(
        '<cal_repo> 准备获取 resp = Supabase.instance.client --> from/select/execute ');
    //M3_06-有override是因为我们使用refreshCalendars这个method。
    final resp = await Supabase.instance.client
        .from('calendars')
        .select('id, name, color, background_slug, calendar_dates (date)')
        .execute();
    print(
        '<cal_repo> 刚刚完成 resp = Supabase.instance.client --> from/select/execute ');
    //M3_06- client是用来make queries from database。
    //M3_06- from('calendars')，因为我们在Supabase已创建一个 table 名为此。
    //M3_06- select(...)，是此 table 里面的栏位名称
    //M3_06- 最后也选择 calendar_dates 这个 table 里面的 date。
    if (resp.error != null) {
      throw (resp.error.toString());
    }
    print(
        '<cal_repo> 准备把获取的 resp => resp.data.map<Calendar>((e) => Calendar.fromJson');
    print('resp.data是啥呢? ${resp.data}');
    return resp.data.map<Calendar>((e) => Calendar.fromJson(e)).toList();

    //M3_06- 取得 Supabase 的 resp 的 data 之后，要转化为map of Calendar 格式，
    //M3_06- for each item in the data, deserialize it into Calendar instances。
  }

  @override
  saveCalendar(Calendar cal) async {
    _assignUserID(cal); //: 这_assignUserID 貌似其实没用到。
    PostgrestResponse resp;
    if (cal.id == null) {
      resp = await Supabase.instance.client
          .from('calendars')
          .insert(cal)
          .execute();
      //M4_01-若我们创建一个新的Calendar，此时cal.id == null，因为刚创建；
      //M4_01-然后我们insert此新的日历；

    } else {
      resp = await Supabase.instance.client
          .from('calendars')
          .update({
            'name': cal.name,
            'color': cal.colorHex,
            'background_slug': cal.backgroundSlug,
          })
          .eq('id', cal.id)
          .execute();
      //M4_01-若我们cal.id != null，即else，这表示我们是要更新现有日历；
      //M4_01-.eq('id', cal.id)是指核实更新的与现有的id是否相符；若无这行，他会把新建日程加到所有现存日历，严重错误。

    }
    if (resp.error != null) {
      throw (resp.error.toString());
    }
  }

  @override
  deleteCalendar(Calendar cal) async {
    _assignUserID(cal); //: 这_assignUserID 貌似其实没用到。
    final resp = await Supabase.instance.client
        .from('calendars')
        .delete()
        .eq('id', cal.id)
        .execute();
    if (resp.error != null) {
      throw (resp.error.toString());
    }
  }

  @override
  saveDate(Calendar cal, DateTime date) async {
    _assignUserID(cal); //: 这_assignUserID 貌似其实没用到。
    // NOTE we could instead submit a CalendarDate vs a Map here but at this
    // time would be overkill
    print('你刚刚点了一个没被选上的日期，所以现在准备save到Supabase了');
    final resp = await Supabase.instance.client.from('calendar_dates').insert({
      'user_id': cal.userID,
      'calendar_id': cal.id,
      'date': calendarDateToString(date),
    }).execute();
    print('现在，已经成功把你刚刚新点的日期，save到Supabase了');
    //:这里，当我们要写入Supabase日期时，得把DateTime转回为String。
    if (resp.error != null) {
      throw (resp.error.toString());
    }
  }

  @override
  deleteDate(Calendar cal, DateTime date) async {
    _assignUserID(cal); //: 这_assignUserID 貌似其实没用到。
    // NOTE another approach is to use a CalendarDate and delete via 'id' (pk) but
    // that would be overkill at this time
    final resp = await Supabase.instance.client
        .from('calendar_dates')
        .delete()
        .eq('calendar_id', cal.id)
        .eq('date', date)
        .execute();
    if (resp.error != null) {
      throw (resp.error.toString());
    }
  }

  _assignUserID(Calendar cal) {
    cal.userID = Supabase.instance.client.auth.user()?.id;
  }
}

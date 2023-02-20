import 'package:flutter/material.dart';
import 'package:the_calendar_app/screens/cal_edit/cal_edit.dart';
import 'package:provider/provider.dart';
import 'package:the_calendar_app/providers/session_provider.dart';
import 'package:the_calendar_app/screens/cal_list/cal_list.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'cal_view/cal_view.dart';

class CalPager extends StatelessWidget {
  static const String routeName = '/cal_pager';
  static const String calListIconKey = 'cal-list-icon';

  const CalPager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('<cal_pager.dart> 执行 制作Calendar画面');
    return Consumer<SessionProvider>(builder: (context, session, _) {
      //M3_09- Consumer是Provider这个Package提供的，且要说明Consumer的type是SessionProvider。
      //: 为啥有builder: (context, session, _)? 因为，鼠标悬停在Consumer，他说
      //: required Widget Function(BuildContext, SessionProvider, Widget?)，下底线那个就是"Widget?"。
      //: 现在，我们有"session"了，就能拿这个"session"去建立有state的日历了。
      print('<cal_pager.dart> session.cals是啥? --> ${session.cals}');
      return Scaffold(
          body: Stack(
        children: [
          PageView(children: session.cals.map((cal) => CalView(cal)).toList()),
          //: 要PageView，是因为日历可以左右滑去各个月份。
          //: session之所以可以.cals并有日历资料，是因为SessionProvider里面有refreshCalendars，
          //: 因为已经refresh过了，所以能读取Supabase的数据。print(session.cals)得到的是x个instance of calendar。
          //: x是多少，取决于你创建几个calendar。此时我就Reading和test2两个日历，所以print(session.cals)得到的是2个instance of calendar。
          //: 你会发现日历其实只有4页。或是说，要定义能滑几个月，要到month_grid.dart里面修改。
          //: final firstDay = DateTime(now.year, now.month - 3, now.day); 减3，就能滑4个月。
          Positioned(
              left: 20.0,
              bottom: 20.0,
              child: IconButton(
                  key: const Key(calListIconKey),
                  icon: Image.asset('assets/icons/icon-menu@3x.png'),
                  iconSize: 35,
                  onPressed: () =>
                      Navigator.pushNamed(context, CalList.routeName))),
          (session.cals.isEmpty
              ? Center(
                  child: IconButton(
                      icon: Image.asset('assets/icons/icon-plus@3x.png'),
                      iconSize: 35,
                      onPressed: () => Navigator.pushNamed(
                          context, CalEdit.routeName,
                          arguments: CalEditArguments(null))))
              : Container())
        ],
      ));
    });
  }
}

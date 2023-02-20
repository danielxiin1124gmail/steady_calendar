import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'repositories/cal_repo.dart';
import 'package:the_calendar_app/repositories/cal_repo_interface.dart';
import 'screens/splash/splash.dart';
import 'screens/cal_edit/cal_bg_picker.dart';
import 'screens/cal_edit/cal_color_picker.dart';
import 'screens/cal_edit/cal_edit.dart';
import 'screens/cal_pager/cal_pager.dart';
import 'screens/cal_list/cal_list.dart';
import 'screens/intro/intro.dart';
import 'screens/login_options/login_options.dart';
import 'screens/menu/menu.dart';
import 'providers/session_provider.dart';
//测试，会Error

class App extends StatelessWidget {
  final State<Splash> splashState; //M3_11-详读。
  const App(this.splashState, {Key? key}) : super(key: key);
  //: App带著splashState，app_test带著MockSplashState，来区分正常执行或测试目的。意义在此。

  @override
  Widget build(BuildContext context) {
    print('<app.dart> 执行 return MaterialApp，去initialRoute: Splash.routeName');
    return MaterialApp(
      title: 'Steady Calendar',
      initialRoute: Splash.routeName,
      routes: {
        Splash.routeName: (context) => Splash(splashState),
        CalPager.routeName: (context) => const CalPager(),
        Intro.routeName: (context) => const Intro(),
        LoginOptions.routeName: (context) => const LoginOptions(),
        CalList.routeName: (context) => const CalList(),
        CalEdit.routeName: (context) => const CalEdit(),
        CalBGPicker.routeName: (context) => const CalBGPicker(),
        CalColorPicker.routeName: (context) => const CalColorPicker(),
        Menu.routeName: (context) => const Menu()
        //: 上面只有Splash与CalEdit是StatefulWidget，其他都是StatelessWidget。
        //: 此外，不在上面的 month_grid.dart、CalEdit.dart 也都是StatefulWidget。
        //: 为何只有Splash要带上splashState? 为何CalEdit不需要?
      },
    );
  }
}

Future<void> runAppWithOptions(
    {String envFileName = '.env',
    CalRepoInterface calendarRepository = const CalendarRepository(),
    required State<Splash> splashState}) async {
  flutter.WidgetsFlutterBinding.ensureInitialized();
  await load(fileName: envFileName);
  await Supabase.initialize(
    url: 'https://${env['SUPABASE_PROJECT_ID']!}.supabase.co',
    anonKey: env['SUPABASE_ANON_KEY']!,
    debug: false,
  );
  flutter.runApp(ChangeNotifierProvider(
    create: (context) => SessionProvider(calendarRepository),
    child: App(splashState),
  ));
}

//: runAppWithOptions包含三个properties: envFileName,calendarRepository, splashState。
//: 其中，calendarRep..，目的是可以区分正常执行app，或是執行app_test.dart。两者有mock data的区别。
//: 为何要String envFileName? 因为，我们要Supabase.initialize，与Supa连线。
//: 为何要calendarRepository? 因为，ChangeNotifierProvider底下要有create，而create的东西必须是
//:   格式为ChangeNotifier的SessionProvider ("SessionProvider extends ChangeNotifier")。
//:   然后，SessionProvider有一个必须项，叫做"this.calRepo"，即上面的SessionProvider(calendarRepository)。
//:   所以，我们要讲清楚calendarRepository为何格式；是CalRepoInterface。它等于真实的、有意义的、有代码逻辑的CalendarRepository。
//: 为何要splashState? 因为，我们说App要带着一个自定义、名为splashState的状态(State)来runApp，确保登入状态。

//: 不确定"flutter."、或是import里面"as flutter"意义和在。其实改成as ddd、ddd.Widg...rBinding照样可以运行。app_test也能运行。
//: 其实app_test.dart也有类似WidgetsFlutterBinding的字眼，意义应该是确保与Supabase连线。
//: 要await load(fileName: envFileName)之后，电脑才能真的读取.env的内容；而且点开load看，好像还非得取名为.env不可。
//: anonKey如果错误，会在点击Google登入之后，callBack之后，说error authenticating: Invalid API key。
//: debug true 会出现很多很细的Auth步骤，显示currentSession、access_token之类的，画面还会有一层东西导致变暗。
//: ChangeNotifierProvider里面的create是必须项；要create一个自定义的SessionProvider，带上calendarRepository。

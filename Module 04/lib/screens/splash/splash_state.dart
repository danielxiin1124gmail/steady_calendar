import 'package:flutter/material.dart';
import 'package:the_calendar_app/screens/splash/splash.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gotrue/gotrue.dart' as gotrue;
import 'package:provider/provider.dart' as provider;
import '../../providers/session_provider.dart';
import 'package:the_calendar_app/screens/cal_pager/cal_pager.dart';
import 'package:the_calendar_app/screens/intro/intro.dart';

class SplashState extends SupabaseAuthState<Splash> {
  @override
  void initState() {
    print('<splash_state> 准备触发 super.initState() 与 recoverSupabaseSession');
    super.initState();
    recoverSupabaseSession();
    print('<splash_state> 完成执行 super.initState() 与 recoverSupabaseSession');
    //M02_8-首先，确保extends后面改成SupabaseAuthState。这样recoverSupabaseSession()即可使用。
    //: 有了initState、recoverSupabaseSession，电脑才能知道现在到底登入没。
  }

  @override
  Widget build(BuildContext context) {
    print('<splash_state> 准备触发 CircularProgressIndicator');
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void onUnauthenticated() {
    print('<splash_state> 选择了onUnauth，准备触发 logout ');
    logout(context);
    //: logout为何要带上context? 第一，因为logout(BuildContext context)，他就有context得填上。
    //: 那为啥logout(BuildContext context)要有context，login()就没有？看底下他们的注解区。
  }

  @override
  void onAuthenticated(gotrue.Session session) async {
    print('<splash_state> 选择了onAuth，准备触发 login');
    login();
    //: 这里若只写"Session session"，而非"gotrue.Session session"，也是能不Error，
    //: 但是会发现他会执行两次"return MaterialApp、CircularProgressIndicator、制作Calendar画面"。
  }

  @override
  void onPasswordRecovery(gotrue.Session session) {
    print('<splash_state> 选择了onPasswordRecovery，然后啥都不做 ');
  }

  @override
  void onErrorAuthenticating(String message) {
    print('<splash_state> 选择了onErrorAuthenticating，然后给错误代码 ');
    print('error authenticating: ' + message);
  }

  @override
  void onReceivedAuthDeeplink(Uri uri) {
    print('<splash_state> 选择了 onReceivedAuthDeeplink，然后{}里面是空的，应该没做啥事');
    //M02_8-这现在用不到，意指一但跳到WebView验证后，告诉WebView回到App中。
  }

  login() async {
    print('<splash_state> 准备触发 login()，判定是否去 CalPager之前，先refreshCalendars');
    await provider.Provider.of<SessionProvider>(context, listen: false)
        .refreshCalendars();
    print('<splash_state> 准备触发 login()，判定是否去 CalPager');
    Navigator.of(context).pushNamedAndRemoveUntil(
        CalPager.routeName, ModalRoute.withName(Splash.routeName));
    //M3_09-provider.Provider.of在这集加上的。
    //: login之后，第一件事是要刷新日历。第二件事，去CalPager。
    //: 后面的Modal...，不打不行，乱打却没事，改成"Intro.routeName、'xxx'"都没事。
    //: await provider.Providers 的await是我加的，老师没有，我觉得比较合理。
  }

  logout(BuildContext context) async {
    print('<splash_state> 准备触发 logout，判定是否去 Intro');
    Navigator.of(context).pushNamedAndRemoveUntil(
        Intro.routeName, ModalRoute.withName(Splash.routeName));
  }
}

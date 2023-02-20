import 'app.dart';
import 'screens/splash/splash_state.dart';

void main() async {
  runAppWithOptions(envFileName: '.env', splashState: SplashState());
  //M3_9- async只是之前遗留下来的，之前Supabase.initialize在main.dart，现在移到app.dart。
  //M3_9- runAppWithOptions是自定义在app.dart里的；
  //Git test
}

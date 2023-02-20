import 'package:the_calendar_app/screens/splash/splash_state.dart';

class MockSplashState extends SplashState {
  MockSplashState();

// we override this to avoid calling Supabase or any external dependency
  @override
  void initState() {
    super.initState();
    // we call logout explicity as 'onUnauthenticated' won't ever be invoked
    Future.delayed(Duration.zero, () async {
      logout(context);
      //M3_10 之后详读。
    });
  }
}

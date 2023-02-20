import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:the_calendar_app/app.dart';
import 'package:the_calendar_app/screens/cal_edit/cal_edit.dart';
import 'mock_calendar_repository.dart';
import 'mock_splash_state.dart';
import 'package:the_calendar_app/screens/cal_pager/cal_pager.dart';

const testEnvFile = '.env.test';

void main() {
  //M3_11-要 run test, 要使用main()。
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('happy path tests', () {
    testWidgets('login and edit calendars', (WidgetTester tester) async {
      final calRepo = MockCalendarRepository();
      final splashState = MockSplashState();

      await runAppWithOptions(
        envFileName: testEnvFile, calendarRepository: calRepo,
        splashState: splashState,
        //M3_11-这里得await。
      );
      await tester.pumpAndSettle();
      //M3_11- pulling all UI and making sure all transition and animation are finished
      //M3_11- before we continue.

      final getStarted = find.widgetWithText(ElevatedButton, 'Get Started');
      await tester.tap(getStarted);
      await tester.pumpAndSettle();
      expect(find.byType(GestureDetector), findsWidgets);
      await splashState.login();
      await tester.pumpAndSettle();
      print('TEST--> 通过find.widgetWithText(ElevatedButton, Get Started');
      //M3_11-测试指令:
      //M3_11-flutter test integration_test

      //M4_09-以下确保存在日历标题
      expect(find.text(calRepo.cals.first.name), findsWidgets);
      await tester.pumpAndSettle();
      print('TEST--> 通过以下确保存在日历标题');

      //M4_09-以下Navigate to cal list screen
      await tester.tap(find.byKey(const ValueKey(CalPager.calListIconKey)));
      await tester.pumpAndSettle();
      print('TEST--> 通过Navigate to cal list screen');

      //M4_09-以下Navigate to cal edit screen
      await tester.tap(find.byKey(ValueKey("cal-${calRepo.cals.first.id}")));
      await tester.pumpAndSettle();
      print('TEST--> 通过Navigate to cal edit screen');

      //M4_09-以下 fill out form fields
      const newName = 'updated';
      //await tester.pumpAndSettle();
      print('TEST--> 通过fill out form fields');

      //M4_09-以下 update the name field
      await tester.tap(find.byKey(const ValueKey(CalEdit.nameKey)));
      await tester.pumpAndSettle();
      print('TEST--> 通过update the name field');

      //M4_09- enterText assumes that the form field os already focused
      await tester.enterText(
          find.byKey(const ValueKey(CalEdit.nameKey)), newName);
      await tester.pumpAndSettle();
      print(
          'TEST--> 通过enterText assumes that the form field os already focused');

      //M4_09-以下测试点选不同背景图片
      await tester.tap(find.byKey(const ValueKey(CalEdit.bgTileKey)));
      await tester.pumpAndSettle();
      const newBg = 'adventures-begin-mug@3x.png';
      await tester.tap(find.byKey(const ValueKey(newBg), skipOffstage: false));
      await tester.pumpAndSettle();
      print('TEST--> 通过测试点选不同背景图片');
      //M4_09-skipOffstage是必须项，否则会Fail。就是说找到的那个widget若是off screen，依然要能被找到。

      //M4_09-以下测试选择不同颜色
      await tester.tap(find.byKey(const ValueKey(CalEdit.colorTileKey)));
      await tester.pumpAndSettle();
      const newColor = '469781';
      await tester
          .tap(find.byKey(const ValueKey(newColor), skipOffstage: false));
      await tester.pumpAndSettle();
      print('TEST--> 通过以下测试选择不同颜色');

      //M4_09-测试save功能
      await tester.tap(
          find.byKey(const ValueKey(CalEdit.saveKey), skipOffstage: false),
          warnIfMissed: false);
      await tester.pumpAndSettle();
      print('TEST--> 通过测试save功能');
      //M4_09-warnIfMissed
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:the_calendar_app/components/sc_flat_button.dart';
import 'package:the_calendar_app/components/sc_image_button.dart';
import 'package:the_calendar_app/config/styles.dart';

class LoginOptions extends StatelessWidget {
  static const String routeName = '/intro/login_options';

  const LoginOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('<login_options.dart> 执行 制作Login画面');
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/pink-plants@3x.png'),
              fit: BoxFit.cover,
            )),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.5),
            ),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: SCFlatButton(
                    const SCImageButton('assets/images/google-logo-9808.png',
                        'Continue with Google'),
                    textColor: Styles.primaryTextColor,
                    backgroundColor: Colors.white,
                    onTap: () {
                      print('<login_options.dart> 你点击了Continue with Google 按钮');
                      _singUpTapped(context);
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20.0),
                    child: SelectableText(
                      'https://cosqgxxdwndkfopzzytu.supabase.co/auth/v1/authorize?provider=google&redirect_to=com.idontknow.steadycalendar://login-callback',
                      style: TextStyle(
                        color: Styles.primaryTextColor,
                        backgroundColor: Colors.white,
                        fontFamily: Styles.primaryFontRegular,
                        fontWeight: Styles.primaryFontWeightLight,
                        fontSize: Styles.primaryButtonFontSize,
                      ),
                    )),
              ]),
        ],
      ),
    );
  }

  Future _singUpTapped(BuildContext context) async {
    //Uri uri = Uri.parse('com.manninglabs.steadycalendar://login-callback/');
    print('<login_options.dart> 执行 await Supabase.....signInWithProvider');
    await Supabase.instance.client.auth.signInWithProvider(
      Provider.google,
      options: AuthOptions(redirectTo: env['SUPABASE_AUTH_CALLBACK']!),
    );
    print('<login_options.dart> 完成 await signInWithProvider ');
  }
}

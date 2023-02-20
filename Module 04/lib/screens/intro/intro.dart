import 'package:flutter/material.dart';
import 'package:the_calendar_app/components/sc_flat_button.dart';
import 'package:the_calendar_app/screens/login_options/login_options.dart';

class Intro extends StatelessWidget {
  static const String routeName = '/intro';
  const Intro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('<Intro.dart> 执行 制作Intro画面');
    return Stack(
      children: [
        PageView(
          scrollDirection: Axis.horizontal,
          children: List.generate(
            5,
            (i) => Image.asset(
              "assets/images/iphone-valprop-$i@3x.png",
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
        ),
        Positioned(
          width: MediaQuery.of(context).size.width,
          //09-这是获取屏幕关渡的方法，但老师说有更好方法，未来会优化。
          height: 60.0,
          bottom: 50.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SCFlatButton(
              const Text('Get Started'),
              onTap: () => Navigator.pushNamed(context, LoginOptions.routeName),
            ),
          ),
        ),
      ],
    );
  }
}

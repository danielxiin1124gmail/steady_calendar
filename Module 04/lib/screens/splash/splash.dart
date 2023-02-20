import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  //M01_18-因为之后要用Supabase Auth，所以需要Stateful。
  static const routeName = '/';
  final State<Splash> state;
  const Splash(this.state, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<Splash> createState() {
    print('<splash.dart> 准备在splash.dart里面 createState() => state ');
    return state;
  }
//: 本来上面是"State<Splash> createState() => state;"。
//: 触发createState()之后，会return 一个叫state的值给到State<Splash>里面。
//: 然后，不知为何，电脑知道下一步要去splash_state.dart里面找到SupabaseAuthState<Splash>，执行之。
}

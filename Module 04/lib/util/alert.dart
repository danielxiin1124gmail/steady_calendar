import 'package:flutter/material.dart';

Future<void> showAlert(
    BuildContext context, String title, String message) async {
  return showAlertWithActions(
    context,
    title,
    message,
    [_alertActionOK(context)],
  );
  //: 这里[_alertActionOK(context)]得用中刮号包起来，原因不明。
  //: 可能是因为他是我们自定义的Widget，一个TextButton，可能widget就是得包起来。
}

Future<void> showAlertWithActions(BuildContext context, String title,
    String message, List<Widget> actions) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: actions,
          //: 这行actions 会产生出右下角确认按键。actions是系统组件。
        );
      });
}

Widget _alertActionOK(BuildContext context) {
  return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
        //: 这行.pop()用亦是点了ok之后，alert视窗会关闭。
      },
      child: const Text('OK'));
}

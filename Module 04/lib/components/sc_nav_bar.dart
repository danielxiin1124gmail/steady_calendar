import 'package:flutter/material.dart';
import 'package:the_calendar_app/components/sc_nav_bar_image_button.dart';

class SCNavBar extends StatelessWidget {
  final String title;
  final Widget? child;
  final bool showBack;
  final Function? backTap; //: 用意不明；整篇代码根本没用到。
  final bool isModal;
  final List<Widget> rightActions;

  const SCNavBar(
      {Key? key,
      required this.title,
      this.child,
      this.showBack = true,
      this.backTap,
      this.isModal = false,
      this.rightActions = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ios = Theme.of(context).platform == TargetPlatform.iOS;
    //: 上面这行白话文是， ios 等于 "A == B" 的结果，即ios 等于 "确认A等于B"的结果，True or false。
    //: 如果Theme.of(context).platform 的值等于 TargetPlatform.iOS 的话。
    print('解惑 --> ios => $ios');
    print('解惑 --> Theme.of(context) => ${Theme.of(context)}');
    print('解惑 --> Theme.of(context).platform => ${Theme.of(context).platform}');

    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.light,
        title: Text(
          title,
          //style: TextStyle(color: Colors.red),
        ),
        centerTitle: true,
        leading: (showBack
            ? Container(
                padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                child: SCNavBarImageButton(
                  iconFilename: (isModal
                      ? 'assets/icons/icons8-delete-100.png'
                      : 'assets/icons/icons8-back-96.png'),
                  onTap: () => (backTap != null
                      ? backTap!()
                      : Navigator.of(context).pop()),
                ))
            : Container()),
        //: showBack，意指左上角要不要按钮，如果要，再决定是叉叉还是返回箭头；不要就空的Container()。
        //: isModal只是在辨别该页左上角要叉叉还是箭头的方法而已。
        //: backTap，不知道干麻，它永远都等于null，即永远执行Navigator.of(context).pop()。
        //: Navigator.of(context).pop()，就是跳出本页之意、dismiss。
        backgroundColor: Colors.white,
        elevation: (ios ? 0.0 : 4.0),
        actions: rightActions,
      ),
      body: child,
      //: SCNavBar有appBar，也有body，代表其实除了上面一条appBar之外，SCNavBar还有一个
      //: 还有一个child，这各child在cal_list里面是ListView，在cal_edit里面是Form。
    );
  }
}

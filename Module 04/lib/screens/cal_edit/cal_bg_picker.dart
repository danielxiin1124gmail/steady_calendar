import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:the_calendar_app/config/constants.dart';
import 'package:the_calendar_app/components/sc_nav_bar.dart';

class CalBGPicker extends StatelessWidget {
  static const String routeName = '/cal_edit/bg_picker';
  const CalBGPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SCNavBar(
      title: 'Choose a Background',
      child: GridView.count(
        childAspectRatio: 0.55, //: 缩图高度，大概0.5刚好，越小越长。
        crossAxisCount: 4,
        padding: const EdgeInsets.all(2.0),
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        children: backgrounds
            .map(
              (backgroundSlug) => GridTile(
                key: Key(backgroundSlug),
                child: InkResponse(
                  enableFeedback: true,
                  onTap: () {
                    Navigator.of(context).pop(backgroundSlug);
                    print('<cal_bg_picker> backgroundSlug = $backgroundSlug');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              "${baseBackgroundImageURL(env['SUPABASE_PROJECT_ID']!)}/$backgroundSlug"),
                        )),
                  ),
                ),
              ),
            )
            .toList(),
        //: Flutter官网说，最常用的GridView，就是GridView.count。
        //: InkResponse就是手指点了图片后，会出现点击阴影效果，逐渐扩散，像Ink在纸上扩散一样。
        //: 点了之后，假设新点的图片是Orange，pop(backgroundSlug)就会带着backgroundSlug = Orange.png
        //: 的信息回到上一页，也就是calBGTileTap()，它还await着呢!
      ),
    );
  }
}

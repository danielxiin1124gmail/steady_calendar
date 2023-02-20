import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:the_calendar_app/config/constants.dart';
import 'package:the_calendar_app/components/sc_list_tile.dart';

class CalBGTile extends StatelessWidget {
  final String backgroundSlug;
  final GestureTapCallback? onTap;
  //M4_05-这是一个non-functional widget。it does not do anything at all。
  //M4_05-it just render stuff。
  //: 其实就是被点了要做 "onTap" 这件事。这件事写在哪? 写在cal_edit里面的onTap: calBGTileTap。
  //: 因为这里有紫色的onTap，所以cal_edit里面的onTap: calBGTileTap能有"onTap:"出现。
  //: 只要是带有问号的，要写在constructor里面的{key key}后面。cal_list_tile.dart也类似。
  const CalBGTile(this.backgroundSlug, {Key? key, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SCListTile(
      'Background',
      trailing: SizedBox(
        //M4_05-有trailing，因为SCListTile使用ListTile，而ListTile有个parameter叫做trailing。
        //M4_05-有trailing决定哪个图片显示在右侧，当做个小图示。
        width: 75.0,
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              //: 这里真正决定了小缩图的长与宽。
              //: 老师这里漏了，他自己也在代码里注记Fixme，这里只是方形图片上多了一层有圆角的图层。
              //: 并非缩图有圆角。不难，参考cal_bg_picker.dart，我自己改了。
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl:
                    '${baseBackgroundImageURL(env['SUPABASE_PROJECT_ID']!)}/$backgroundSlug',
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}

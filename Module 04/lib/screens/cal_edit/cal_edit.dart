import 'package:flutter/material.dart';
import 'cal_color_picker.dart';
import 'package:provider/provider.dart';
import 'package:the_calendar_app/util/alert.dart';
import 'package:the_calendar_app/models/calendar.dart';
import 'package:the_calendar_app/providers/session_provider.dart';
import 'package:the_calendar_app/config/styles.dart';
import 'package:the_calendar_app/components/sc_list_container.dart';
import 'package:the_calendar_app/components/sc_nav_bar.dart';
import 'package:the_calendar_app/components/sc_footer_button.dart';
import 'package:the_calendar_app/components/sc_nav_text_button.dart';
import 'package:the_calendar_app/components/sc_list_divider.dart';
import 'cal_bg_picker.dart';
import 'cal_bg_tile.dart';
import 'cal_color_tile.dart';

class CalEditArguments {
  final Calendar? cal;
  CalEditArguments(this.cal);
}

class CalEdit extends StatefulWidget {
  static const String routeName = '/cal_edit';
  static const String nameKey = 'name';
  static const String bgTileKey = 'bg-tile';
  static const String colorTileKey = 'color-tile';
  static const String saveKey = 'save';

  const CalEdit({Key? key}) : super(key: key);

  @override
  _CalEditState createState() => _CalEditState();
  //M4_04-上面这句本来是预设State<CalEdit> createState() => _CalEditState();。
}

class _CalEditState extends State<CalEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Calendar cal;
  //M4_04-late是让cal之后再定义。

  @override
  Widget build(BuildContext context) {
    /*print('<cal_edit> 来到cal_edit了。');*/
    final args = ModalRoute.of(context)!.settings.arguments as CalEditArguments;
    /*print('<cal_edit>解惑 --> _formKey => $_formKey');
    print('<cal_edit>解惑 --> _formKey.currentState => ${_formKey.currentState}');
    print('<cal_edit>解惑 --> args => $args');
    print('<cal_edit>解惑 --> args.toString() => ${args.toString()}');
    print('<cal_edit>解惑 --> ModalRoute => $ModalRoute');
    print(
        '<cal_edit>解惑 --> ModalRoute.of(context)! => ${ModalRoute.of(context)!}');
    print(
        '<cal_edit>解惑 --> ModalRoute.of(context)!.settings => ${ModalRoute.of(context)!.settings}');
    print(
        '<cal_edit>解惑 --> ModalRoute.of(context)!.settings.arguments => ${ModalRoute.of(context)!.settings.arguments}');
    print(
        '<cal_edit>解惑 --> ModalRoute.of(context)!.settings.arguments as CalEditArguments => ${ModalRoute.of(context)!.settings.arguments as CalEditArguments}');*/
    cal = args.cal ?? Calendar.blank();
    print('<cal_edit>解惑 --> args.cal => ${args.cal}');
    print('<cal_edit>解惑 --> args.cal.toString() => ${args.cal.toString()}');
    /*print(
        '<cal_edit>小心!这行会导致不能新增页面! 解惑 --> args.cal!.toJson() => ${args.cal!.toJson()}');*/
    //M4_04-上面说，如果 cal is null, then use Calendar.blank() 来创建一个空的、新的日历。
    //M4_04-Calendar.blank()是一个custom function，可以创建一个空的、新的日历。
    return SCNavBar(
      title: (cal.id == null ? 'Create' : 'Edit'),
      rightActions: [
        SCNavBarTextButton(
            key: const Key(CalEdit.saveKey),
            title: 'Save',
            onTap: () => submit(context)),
      ],
      child: Form(
        key: _formKey, //M4_04-老师说需要key，it is a 必须项；但其实非required。
        child: Stack(
          children: [
            SCListContainer([
              TextFormField(
                  key: const Key(CalEdit.nameKey),
                  initialValue: cal.name,
                  style:
                      const TextStyle(fontSize: Styles.primaryHeaderFontSize),
                  decoration: Styles.textFormFieldDecoration('Name'),
                  validator: (value) => (value == null || value.isEmpty
                      ? 'Name is required'
                      : null),
                  onSaved: (String? val) => cal.name = val.toString()),
              const SCListDivider(),
              CalBGTile(cal.backgroundSlug,
                  key: const Key(CalEdit.bgTileKey), onTap: calBGTileTap),
              const SCListDivider(),
              CalColorTile(cal.color,
                  key: const Key(CalEdit.colorTileKey), onTap: calColorTileTap),
              const SCListDivider(),
            ]),
            Positioned(
                //M4_06-这是制作左下角的垃圾桶图标。
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                bottom: 0.0,
                child: Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(200, 255, 255, 0.8),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SCFooterButton(
                              'assets/icons/icons8-trash-can-100.png',
                              onTap: () => deleteTapped(context))
                        ]))),
          ],
        ),
      ),
    );
  }

  calBGTileTap() async {
    print('<cal_edit>解惑 --> 你刚刚点了calBGTileTap，现在要去CalBGPicker');
    final result =
        await Navigator.of(context).pushNamed(CalBGPicker.routeName) as String?;
    print('<cal_edit>解惑 --> result => $result');
    // NOTE result can be null if back button tapped
    if (result != null) {
      setState(() {
        cal.backgroundSlug = result;
        //M4_05-一旦使用者选择了背景图片，会返回result，我们就setState，说新背景=result。
      });
    }
  }

  calColorTileTap() async {
    final result = await Navigator.of(context)
        .pushNamed(CalColorPicker.routeName) as String?;
    // NOTE result can be null if back button tapped
    if (result != null) {
      setState(() {
        cal.colorHex = result;
      });
    }
  }

  deleteTapped(BuildContext context) async {
    await showDialog<void>(
      //: showDialog是因为下面要用AlertDialog。
      context: context,
      barrierDismissible: true, //: 其实预设就是true，这行不是showDialog 的 required。
      builder: (BuildContext builderContext) {
        return AlertDialog(
          title: const Text('Delete Permanently?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This action cannot be undone.'),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(builderContext).pop();
                },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  delete(context);
                  Navigator.of(builderContext).pop();
                  //M4_06-上面是pop出 alert画面。
                  Navigator.of(context).pop();
                  //M4_06-然后我们dismiss the screen。
                },
                child: const Text('Yes, Delete Permanently')),
          ],
        );
      },
    );
  }

  delete(BuildContext context) async {
    final session = Provider.of<SessionProvider>(context, listen: false);
    await session
        .deleteCalendar(cal)
        .catchError((e) => showAlert(context, 'Error', e.toString()));
    await session.refreshCalendars();
    //M4_06-refreshCalendars时，不用担心是否需要pass data到新画面，此ref自动会引用既有信息。
    //M4_06-这是好的example说明为何我们用 Provider 此 package。
  }

  submit(BuildContext context) async {
    print('<cal_edit>你点了按钮，触发submit');
    final form = _formKey.currentState!;
    print('<cal_edit>解惑 --> form => $form');
    print('<cal_edit>解惑 --> form.validate() => ${form.validate()}');
    if (form.validate()) {
      form.save();
      print('<cal_edit>解惑 --> form.save.toString() => ${form.save.toString()}');
      final session = Provider.of<SessionProvider>(context, listen: false);
      await session
          .saveCalendar(cal)
          .catchError((e) => showAlert(context, 'Error', e.toString()));
      await session.refreshCalendars();
      // TODO show reload spinner when doing any supabase updates
      Navigator.of(context).pop();
      //: M4_06-form.validate解释：https://docs.flutter.dev/cookbook/forms/validation。
      //: 意即，form.validate()会检查所有text field in the form。没问题就return True。
      //: 所有带有validator的都会被检查，例如TextFormField里面就有validator。
      //: form.save()，会把所有带着onSaved的东西都保存。例如，TextFormField有onSaved，
      //: 表示触发onSaved后，cal.name = val.toString()，就是输入字符.toString会增添到cal.name的值里。
    }
  }
}

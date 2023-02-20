import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';
import '../config/constants.dart';
import 'calendar_color.dart';
import 'calendar_date.dart';
import 'calendar_dates_converter.dart';
import 'date_time_converter.dart';
part 'calendar.g.dart';

@JsonSerializable()
@CalendarDatesConverter()
@DateTimeConverter()
class Calendar {
  @JsonKey(includeIfNull: false)
  int? id;

  @JsonKey(name: 'user_id')
  String? userID;

  String name;

  @JsonKey(name: 'color', required: true)
  String colorHex;

  @JsonKey(name: 'background_slug', required: true)
  String backgroundSlug;

  @JsonKey(name: 'calendar_dates', required: false, includeIfNull: false)
  CalendarDates? dates;
  CalendarColor get color => colors.firstWhere((e) => colorHex == e.hex);
  //M03_4-老师有解释为何要@JsonKey(name: 'user_id')。主要是Json方格式为userID这种格式，
  //M03_4-但是Dart需要使用小写与底线格式，如user_id。

  Calendar(
      {this.id,
      this.userID,
      required this.name,
      required this.colorHex,
      required this.backgroundSlug,
      this.dates});

  factory Calendar.blank() {
    return Calendar(
      name: 'Untitled',
      colorHex: colors.first.hex,
      backgroundSlug: 'darts@3x.png',
    );
    //: 这是当新增日历时，预设图片定为darts.png，颜色为第一个颜色(即 Harmony)。
  }

  factory Calendar.fromJson(Map<String, dynamic> json) =>
      _$CalendarFromJson(json);
  Map<String, dynamic> toJson() => _$CalendarToJson(this);
  //M03_4-制作g.dart，执行 --> flutter pub run build_runner build --delete-conflicting-outputs。
}

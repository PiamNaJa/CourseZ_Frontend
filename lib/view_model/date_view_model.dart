import 'package:jiffy/jiffy.dart';

class DateViewModel {
  String formatDate(int createdAt) {
    var date = DateTime.fromMillisecondsSinceEpoch(createdAt * 1000);
    String timeago = Jiffy(date).fromNow();
    if (timeago.contains('a few seconds')) {
      timeago = timeago.replaceAll('a few seconds', 'ไม่กี่วินาที');
    } else if (timeago.contains('a second')) {
      timeago = timeago.replaceAll('a second', '1 วินาที');
    } else if (timeago.contains('a minute')) {
      timeago = timeago.replaceAll('a minute', '1 นาที');
    } else if (timeago.contains('an hour')) {
      timeago = timeago.replaceAll('an hour', '1 ชั่วโมง');
    } else if (timeago.contains('a day')) {
      timeago = timeago.replaceAll('a day', '1 วัน');
    } else if (timeago.contains('a month')) {
      timeago = timeago.replaceAll('a month', '1 เดือน');
    } else if (timeago.contains('a year')) {
      timeago = timeago.replaceAll('a year', '1 ปี');
    } else if (timeago.contains('minutes')) {
      timeago = timeago.replaceAll('minutes', 'นาที');
    } else if (timeago.contains('hours')) {
      timeago = timeago.replaceAll('hours', 'ชั่วโมง');
    } else if (timeago.contains('days')) {
      timeago = timeago.replaceAll('days', 'วัน');
    } else if (timeago.contains('months')) {
      timeago = timeago.replaceAll('months', 'เดือน');
    } else if (timeago.contains('years')) {
      timeago = timeago.replaceAll('years', 'ปี');
    } else if (timeago.contains('minute')) {
      timeago = timeago.replaceAll('minute', 'นาที');
    } else if (timeago.contains('hour')) {
      timeago = timeago.replaceAll('hour', 'ชั่วโมง');
    } else if (timeago.contains('day')) {
      timeago = timeago.replaceAll('day', 'วัน');
    } else if (timeago.contains('month')) {
      timeago = timeago.replaceAll('month', 'เดือน');
    } else if (timeago.contains('year')) {
      timeago = timeago.replaceAll('year', 'ปี');
    }
    return timeago;
  }
}

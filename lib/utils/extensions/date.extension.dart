import 'package:get/get.dart';
import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String? get local => 'en_US'.tr;
  DateTime copyWith({
    int? tahun,
    int? bulan,
    int? hari,
    int? jam,
    int? menit,
    int? detik,
  }) {
    tahun ??= year;
    bulan ??= month;
    hari ??= day;
    jam ??= hour;
    menit ??= minute;
    detik ??= second;

    return DateTime(tahun, bulan, hari, jam, menit, detik);
  }

  /// Ke dalam format tanggal
  String toDateString() => DateFormat('y-M-d', local).format(this);

  /// Ke dalam format tanggal
  String toDMYTipe() => DateFormat('d-M-y', local).format(this);

  String toDateStringLong() => DateFormat('yyyy-MM-dd', local).format(this);

  String toDateStringLongNoDay() => DateFormat('yyyy-MM', local).format(this);

  /// Ke dalam format tanggal waktu
  String toDateTimeString() => DateFormat('y-M-d HH:mm:ss', local).format(this);

  /// Ke dalam format waktu
  String toTimeString() => DateFormat('HH:mm', local).format(this);

  /// Ke dalam format waktu
  String toTimeAString() => DateFormat('HH:mm a', local).format(this);

  String toTimetring() => DateFormat('HH:mm', local).format(this);

  /// Ke dalam format tanggal baca
  String toHumanDate() => DateFormat('EEEE, d MMMM y', local).format(this);

  /// Ke dalam format tanggal baca
  String toHumanDateNoDay() => DateFormat('d MMM y', local).format(this);

  /// Ke dalam format tanggal baca`
  String toHumanDateLongNoDay() => DateFormat('d MMMM y', local).format(this);

  /// Ke dalam format tanggal baca pendek
  String toHumanDateShort() => DateFormat('E, d MMM y', local).format(this);

  // to EEEE, HH:mm
  String toHumanDateShortWithHour() =>
      DateFormat('EEEE, HH:mm', local).format(this);

  // to HH:mm
  String toHumanHour() => DateFormat('HH:mm', local).format(this);

  String toDayMonth() => DateFormat('d MMM', local).format(this);

  bool isSameDay(DateTime? other) {
    if (other == null) return false;
    return year == other.year && month == other.month && day == other.day;
  }

  /// Ke dalam format tanggal baca waktu
  String toHumanDateTime() {
    try {
      return DateFormat('EEEE, d MMMM y HH:mm', local).format(this);
    } catch (e) {
      return '';
    }
  }

  /// Ke dalam format tanggal baca waktu
  String toHumanDateTimeSort() {
    try {
      return DateFormat('E, d MMM y HH:mm', local).format(this);
    } catch (e) {
      return '';
    }
  }

  String toHumanDateTimeWithoutHour() {
    try {
      return DateFormat('EEEE, d MMMM y', local).format(this);
    } catch (e) {
      return '';
    }
  }

  /// Ke dalam format tanggal baca waktu pendek
  String toHumanDateTimeShort() =>
      DateFormat('E, d MMM y HH:mm', local).format(this);

  /// Ke dalam format tanggal baca waktu pendek
  String toHumanMonthDate() {
    try {
      return DateFormat('dd MMM yyy', local).format(this);
    } catch (e) {
      return '';
    }
  }

  String toHumanShortMonthDate() => DateFormat('d MMM yyy', local).format(this);

  String toHumanShortMonthWithDay() =>
      DateFormat('EE, d MMM yyy', local).format(this);

  String toHumanShortDay() => DateFormat('EE', local).format(this);

  String toHumanMonthShortNoYearDate() =>
      DateFormat('d MMM', local).format(this);

  /// Ke dalam format tahun bulan baca waktu pendek
  String toHumanBulanDate() => DateFormat('MMMM yyy', local).format(this);

  String toHumanBulanShortDate() => DateFormat('MMM yyy', local).format(this);

  /// Ke dalam format tahun bulan baca waktu pendek
  String toHumanDay() => DateFormat('d', local).format(this);

  /// Ke dalam format tahun bulan baca waktu pendek
  String toHumanBulan() => DateFormat('MMMM', local).format(this);

  /// Ke dalam format time baca waktu pendek
  String toHumanTime() => DateFormat('HH:mm', local).format(this);

  /// Ke dalam format tanggal baca waktu pendek
  String toHumanDateTimeShortWithoutYear() =>
      DateFormat('E, d MMM HH:mm', local).format(this);

  String toTimeInCheckClock() {
    try {
      return DateFormat('HH:mm:ss', local).format(this);
    } catch (e) {
      return '--:--:--';
    }
  }

  String extToFormattedString({String outputDateFormat = 'yyyy-MM-dd'}) {
    return DateFormat(outputDateFormat, local).format(this);
  }

  // 2024-06-11 12:00:00
  String toDateTimeStringWithTime() {
    return DateFormat('yyyy-MM-dd HH:mm:ss', local).format(this);
  }
}

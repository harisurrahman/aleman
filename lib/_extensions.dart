/* import 'date.dart';

@deprecated

/// Please to not use this function. Its deprecated in favor of [PersianStringExtensions.withPersianNumbers].
String toPersian(String text) {
  if (text == null || text.isEmpty) {
    return text;
  }

  final output = StringBuffer();
  final persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

  for (int i = 0; i < text.length; i++) {
    final char = text.codeUnitAt(i);
    if (char >= 48 && char <= 57) {
      output.write(persian[char - 48]);
    } else {
      output.write(String.fromCharCode(char));
    }
  }

  return output.toString();
}

/// Persian DateTime extension methods.
extension PersianDateTimeExtensions on DateTime {
  PersianDate toPersian() {
    return PersianDate(this);
  }
}

/// Persian string extension methods.
extension PersianStringExtensions on String {
  /// Replaces any number with English numbers.
  String withEnglishNumbers() {
    if (this == null || this.isEmpty) {
      return this;
    }

    var x = this;
    x = x.replaceAll('\u06F0', '0');
    x = x.replaceAll('\u06F1', '1');
    x = x.replaceAll('\u06F2', '2');
    x = x.replaceAll('\u06F3', '3');
    x = x.replaceAll('\u06F4', '4');
    x = x.replaceAll('\u06F5', '5');
    x = x.replaceAll('\u06F6', '6');
    x = x.replaceAll('\u06F7', '7');
    x = x.replaceAll('\u06F8', '8');
    x = x.replaceAll('\u06F9', '9');

    x = x.replaceAll('\u0660', '0');
    x = x.replaceAll('\u0661', '1');
    x = x.replaceAll('\u0662', '2');
    x = x.replaceAll('\u0663', '3');
    x = x.replaceAll('\u0664', '4');
    x = x.replaceAll('\u0665', '5');
    x = x.replaceAll('\u0666', '6');
    x = x.replaceAll('\u0667', '7');
    x = x.replaceAll('\u0668', '8');
    x = x.replaceAll('\u0669', '9');

    return x;
  }

  /// Replaces English numbers (and some other number system) with Persian numbers.
  String withPersianNumbers() {
    if (this == null || this.isEmpty) {
      return this;
    }

    var x = this;
    x = x.replaceAll('0', '\u06F0');
    x = x.replaceAll('1', '\u06F1');
    x = x.replaceAll('2', '\u06F2');
    x = x.replaceAll('3', '\u06F3');
    x = x.replaceAll('4', '\u06F4');
    x = x.replaceAll('5', '\u06F5');
    x = x.replaceAll('6', '\u06F6');
    x = x.replaceAll('7', '\u06F7');
    x = x.replaceAll('8', '\u06F8');
    x = x.replaceAll('9', '\u06F9');

    x = x.replaceAll('\u0660', '\u06F0');
    x = x.replaceAll('\u0661', '\u06F1');
    x = x.replaceAll('\u0662', '\u06F2');
    x = x.replaceAll('\u0663', '\u06F3');
    x = x.replaceAll('\u0664', '\u06F4');
    x = x.replaceAll('\u0665', '\u06F5');
    x = x.replaceAll('\u0666', '\u06F6');
    x = x.replaceAll('\u0667', '\u06F7');
    x = x.replaceAll('\u0668', '\u06F8');
    x = x.replaceAll('\u0669', '\u06F9');

    return x;
  }


  String withBanglaNumbers() {
    if (this == null || this.isEmpty) {
      return this;
    }

    var x = this;
    x = x.replaceAll('0', '\u09E6');
    x = x.replaceAll('1', '\u09E7');
    x = x.replaceAll('2', '\u09E8');
    x = x.replaceAll('3', '\u09E9');
    x = x.replaceAll('4', '\u09EA');
    x = x.replaceAll('5', '\u09EB');
    x = x.replaceAll('6', '\u09EC');
    x = x.replaceAll('7', '\u09ED');
    x = x.replaceAll('8', '\u09EE');
    x = x.replaceAll('9', '\u09EF');
    return x;
  }



  /// Replaces ك with ک, and ي with ی.
  String withPersianLetters() {
    if (this == null || this.isEmpty) {
      return this;
    }

    var x = this;
    x = x.replaceAll('\u064A', '\u06CC');
    x = x.replaceAll('\u0643', '\u06A9');

    return x;
  }
}
 */
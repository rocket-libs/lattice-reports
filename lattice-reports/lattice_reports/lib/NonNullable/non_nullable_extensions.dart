import 'package:flutter_guid/flutter_guid.dart';

DateTime unixEpoch = DateTime.fromMillisecondsSinceEpoch(0);

extension Lists on List? {
  List<T> toNonNullList<T>() {
    List<T> result = [];
    if (this != null) {
      final list = this!;
      for (int i = 0; i < list.length; i++) {
        final currentItem = list[i];
        if (currentItem != null) {
          result.add(currentItem);
        }
      }
    }
    return result;
  }
}

extension Sets on Set? {
  Set<T> toNonNull<T>() {
    final result = <T>{};
    if (this != null) {
      final theSet = this!;
      for (int i = 0; i < theSet.length; i++) {
        final currentItem = theSet.elementAt(i);
        if (currentItem != null) {
          result.add(currentItem);
        }
      }
    }
    return result;
  }
}

extension Strings on String? {
  String valueOrDefault() {
    if (this == null) {
      return "";
    } else {
      return this!;
    }
  }

  bool get isNullOrEmpty {
    return this == null || this!.isEmpty;
  }

  bool get hasValue {
    return isNullOrEmpty == false;
  }
}

extension Guids on Guid? {
  Guid valueOrDefault() {
    if (this == null) {
      return Guid.defaultValue;
    } else {
      return this!;
    }
  }
}

extension Doubles on double? {
  double valueOrDefault() {
    if (this == null) {
      return 0.0;
    } else {
      return this!;
    }
  }

  String formatAsCurrency({int fractionDigits = 0}) {
    return valueOrDefault().toStringAsFixed(fractionDigits).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}

// extension PhoneNumbers on PhoneNumber? {
//   PhoneNumber valueOrDefault() {
//     if (this == null) {
//       return PhoneNumber("");
//     } else {
//       return this!;
//     }
//   }
// }

extension Ints on int? {
  int valueOrDefault() {
    if (this == null) {
      return 0;
    } else {
      return this!;
    }
  }

  double toDouble() {
    return double.parse(valueOrDefault().toString());
  }
}

extension NullableDateTimes on DateTime? {
  DateTime valueOrDefault() {
    if (this == null) {
      return unixEpoch;
    } else {
      return this!;
    }
  }

  String formatAsDate() {
    final date = valueOrDefault().toIso8601String().substring(0, 10);
    return date;
  }

  String toYYYYDashMMDashDD() {
    final date = valueOrDefault();
    return "${date.year}-${date.month}-${date.day}";
  }

  String toDDDashMMMDashYYYY() {
    final date = valueOrDefault();
    return "${date.day}-${_getMonthAbbreviation(date.month)}-${date.year}";
  }

  String _getMonthAbbreviation(int month) {
    switch (month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      default:
        return "Dec";
    }
  }
}

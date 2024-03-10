class CustomDateFormat {
  String desiredFormat;

  CustomDateFormat(this.desiredFormat);

  String format(DateTime date) {
    String formattedDate = desiredFormat.replaceAllMapped(
        RegExp(r"(\w{1,4})", caseSensitive: false), (Match match) {
      switch (match.group(1)!.toLowerCase()) {
        case 'dd':
          return _twoDigits(date.day);
        case 'mmm':
          return _getMonthAbbreviation(date.month).toLowerCase();
        case 'yy':
          return _twoDigits(date.year % 100);
        case 'hh':
          return _twoDigits(date.hour);
        case 'mm':
          return _twoDigits(date.minute);
        case 'ss':
          return _twoDigits(date.second);
        default:
          return match.group(1)!;
      }
    });

    return formattedDate;
  }

  String _twoDigits(int n) {
    if (n >= 10) {
      return "$n";
    }
    return "0$n";
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
      case 12:
        return "Dec";
      default:
        return "";
    }
  }
}

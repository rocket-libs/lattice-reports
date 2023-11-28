import 'package:lattice_reports/NonNullable/non_nullable_extensions.dart';
import 'package:lattice_reports/VendorLocations/Data/vendor_location_model.dart';

class ReportArgumentModel {
  DateTime dateOne;
  DateTime dateTwo;
  List<VendorLocationModel> vendorLocations;
  ReportArgumentModel(
      {required this.dateOne,
      required this.dateTwo,
      required this.vendorLocations});

  String get vendorLocationsDescription {
    if (vendorLocations.isEmpty) {
      return "None Selected";
    }
    final vendorLocationDescriptions = vendorLocations
        .map((e) => e.displayLabel.valueOrDefault())
        .toList()
        .join(", ");
    return vendorLocationDescriptions;
  }

  String get dateDescription {
    if (dateOne.isAfter(dateTwo)) {
      final temp = dateOne;
      dateOne = dateTwo;
      dateTwo = temp;
    }

    bool isSameDay(DateTime a, DateTime b) {
      return a.year == b.year && a.month == b.month && a.day == b.day;
    }

    final argDatesAreSameDay = isSameDay(dateOne, dateTwo);
    final argDatesAreToday = isSameDay(dateOne, DateTime.now());
    final argDatesAreYesterday =
        isSameDay(dateOne, DateTime.now().subtract(const Duration(days: 1)));

    final Map<bool Function(), String> dateDescriptionMap = {
      () => argDatesAreSameDay && argDatesAreYesterday: "Yesterday",
      () => argDatesAreSameDay && argDatesAreToday: "Today",
      () => argDatesAreSameDay && !argDatesAreToday:
          dateOne.toDDDashMMMDashYYYY(),
      () => !argDatesAreSameDay:
          "${dateOne.toDDDashMMMDashYYYY()} - ${dateTwo.toDDDashMMMDashYYYY()}"
    };

    final dateDescription =
        dateDescriptionMap.entries.firstWhere((element) => element.key()).value;
    return dateDescription;
  }
}

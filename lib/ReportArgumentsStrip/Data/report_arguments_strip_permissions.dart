class ReportArgumentsStripPermissions {
  Future<bool> Function()? _canChangeDateRange;
  Future<bool> Function()? _canChangeVendorLocations;

  ReportArgumentsStripPermissions(
      {Future<bool> Function()? canChangeDateRange,
      Future<bool> Function()? canChangeVendorLocations}) {
    _canChangeDateRange = canChangeDateRange;
    _canChangeVendorLocations = canChangeVendorLocations;
  }

  Future<bool> canChangeDateRange() async {
    if (_canChangeDateRange == null) {
      return true;
    }
    return _canChangeDateRange!();
  }

  Future<bool> canChangeVendorLocations() async {
    if (_canChangeVendorLocations == null) {
      return true;
    }
    return _canChangeVendorLocations!();
  }
}

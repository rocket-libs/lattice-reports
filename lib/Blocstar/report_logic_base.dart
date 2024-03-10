import 'package:flutter/material.dart';
import 'package:lattice_reports/Blocstar/logic_base.dart';
import 'package:lattice_reports/Blocstar/report_context_base.dart';
import 'package:lattice_reports/NonNullable/non_nullable_extensions.dart';
import 'package:lattice_reports/VendorProfiles/Data/vendor_profile_model.dart';
import 'package:lattice_reports/VendorProfiles/Messaging/vendor_profile_messenger.dart';

abstract class ReportLogicBase<
        TBlocstarLogicBaseContext extends ReportContextBase>
    extends LogicBase<TBlocstarLogicBaseContext> {
  Function onReportRun = () {};

  @mustCallSuper
  @override
  Future initializeAsync() async {
    context.merge(
        newVendorProfileModel: VendorProfileMessenger()
            .getSingleOrDefault(defaultValue: VendorProfileModel()));

    return super.initializeAsync();
  }

  @override
  dispose() {
    VendorProfileMessenger().removeListener(_vendorProfileModelChanged);
    onReportRun = () {};
    super.dispose();
  }

  _vendorProfileModelChanged(List<VendorProfileModel> vendorProfileModels) {
    if (vendorProfileModels.isEmpty) {
      return;
    }
    context.merge(newVendorProfileModel: vendorProfileModels.first);
    runReportAsync();
  }

  bool get canCallApi {
    return context.reportArgumentModel.vendorLocations.isNotEmpty &&
        context.vendorProfileModel.displayLabel.valueOrDefault().isNotEmpty;
  }

  bool get showingMultipleDates {
    return context.reportArgumentModel.dateOne.toDDDashMMMDashYYYY() !=
        context.reportArgumentModel.dateTwo.toDDDashMMMDashYYYY();
  }

  Future runReportAsync();
}

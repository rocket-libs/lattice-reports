import 'package:bargain_di/ObjectFactory.dart';
import 'package:lattice_reports/ApplicationInformation/Data/application_information.dart';
import 'package:lattice_reports/ApplicationInformation/Data/application_information_messenger.dart';
import 'package:lattice_reports/Authentication/Data/authentication_information.dart';
import 'package:lattice_reports/Authentication/Messaging/authentication_messenger.dart';
import 'package:lattice_reports/Data/order_data_point_model.dart';
import 'package:lattice_reports/Dataflow/environment_information.dart';
import 'package:lattice_reports/Locations/Data/location_model.dart';
import 'package:lattice_reports/Logging/logger_wrapper.dart';
import 'package:lattice_reports/SalesList/Blocstar/sales_list_logic.dart';
import 'package:lattice_reports/Strings/strings.dart';
import 'package:lattice_reports/VendorLocations/Data/vendor_location_model.dart';
import 'package:preflection/preflection.dart';

class LatticeReportsConfiguration {
  static EnvironmentInformation? environmentInformation;
  static LatticeReportStrings? _strings;

  static LatticeReportStrings get strings => _strings ?? LatticeReportStrings();

  Future configureAsync(
      {required EnvironmentInformation environmentInfo,
      required AuthenticationInformation authenticationInfo,
      required ApplicationInformation applicationInfo,
      required void Function(String message) e,
      required void Function(String message) i,
      required void Function(String message) v,
      required PreflectorFactory preflectorFactory,
      required ObjectFactory logicRegistry,
      LatticeReportStrings? customStrings}) async {
    LoggerWrapper().configure(i: i, v: v, e: e);
    LatticeReportsConfiguration.environmentInformation = environmentInfo;
    LatticeReportsConfiguration._strings =
        customStrings ?? LatticeReportStrings();
    ApplicationInformationMessenger()
        .configure(applicationInformation: applicationInfo);

    preflectorFactory
      ..addCreator(() => VendorLocationModel())
      ..addCreator(() => OrderDataPointModel())
      ..addCreator(() => LocationModel());

    logicRegistry.registerImplicit(() => SalesListLogic());

    await AuthenticationMessenger()
        .configureAsync(authenticationInformation: authenticationInfo);
  }
}

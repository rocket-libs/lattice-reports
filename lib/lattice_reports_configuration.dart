import 'dart:io';

import 'package:bargain_di/ObjectFactory.dart';
import 'package:lattice_reports/ApplicationInformation/Data/application_information.dart';
import 'package:lattice_reports/ApplicationInformation/Data/application_information_messenger.dart';
import 'package:lattice_reports/Authentication/Data/authentication_information.dart';
import 'package:lattice_reports/Authentication/Messaging/authentication_messenger.dart';
import 'package:lattice_reports/Data/order_data_point_model.dart';
import 'package:lattice_reports/Dataflow/environment_information.dart';
import 'package:lattice_reports/Icons/lattice_report_icons.dart';
import 'package:lattice_reports/Locations/Data/location_model.dart';
import 'package:lattice_reports/Logging/logger_wrapper.dart';
import 'package:lattice_reports/QuickOverview/Blocstar/quick_overview_logic.dart';
import 'package:lattice_reports/RevenueList/Blocstar/revenue_list_logic.dart';
import 'package:lattice_reports/SalesList/Blocstar/sales_list_logic.dart';
import 'package:lattice_reports/Strings/strings.dart';
import 'package:lattice_reports/Theming/theming.dart';
import 'package:lattice_reports/VendorLocations/Data/vendor_location_model.dart';
import 'package:lattice_reports/VendorProfiles/Data/vendor_profile_model.dart';
import 'package:lattice_reports/lattice_http_overrides.dart';
import 'package:preflection/preflection.dart';

class LatticeReportsConfiguration {
  static EnvironmentInformation? environmentInformation;
  static LatticeReportStrings? _strings;
  static LatticeReportIcons? _icons;
  static Theming? _theming;

  static LatticeReportStrings get strings => _strings ?? LatticeReportStrings();

  static LatticeReportIcons get icons => _icons ?? LatticeReportIcons();

  static Theming get theming => _theming ?? Theming();

  Future configureAsync(
      {required EnvironmentInformation environmentInfo,
      required AuthenticationInformation authenticationInfo,
      required ApplicationInformation applicationInfo,
      required void Function(String message) e,
      required void Function(String message) i,
      required void Function(String message) v,
      required PreflectorFactory preflectorFactory,
      required ObjectFactory logicRegistry,
      LatticeReportStrings? customStrings,
      LatticeReportIcons? customIcons,
      Theming? theming}) async {
    HttpOverrides.global = LatticeHttpOverrides();

    LoggerWrapper().configure(i: i, v: v, e: e);
    LatticeReportsConfiguration.environmentInformation = environmentInfo;
    LatticeReportsConfiguration._strings =
        customStrings ?? LatticeReportStrings();
    LatticeReportsConfiguration._icons = customIcons ?? LatticeReportIcons();
    LatticeReportsConfiguration._theming = theming ?? Theming();
    ApplicationInformationMessenger()
        .configure(applicationInformation: applicationInfo);

    preflectorFactory
      ..addCreator(() => VendorLocationModel())
      ..addCreator(() => OrderDataPointModel())
      ..addCreator(() => LocationModel())
      ..addCreator(() => VendorProfileModel());

    logicRegistry
      ..registerImplicit(() => SalesListLogic())
      ..registerImplicit(() => QuickOverviewLogic())
      ..registerImplicit(() => RevenueListLogic());

    await AuthenticationMessenger()
        .configureAsync(authenticationInformation: authenticationInfo);
  }
}

import 'package:lattice_reports/ApplicationInformation/Data/application_information.dart';
import 'package:lattice_reports/ApplicationInformation/Data/application_information_messenger.dart';
import 'package:lattice_reports/Authentication/Data/authentication_information.dart';
import 'package:lattice_reports/Authentication/Messaging/authentication_messenger.dart';
import 'package:lattice_reports/Dataflow/environment_information.dart';
import 'package:lattice_reports/Logging/logger_wrapper.dart';

class LatticeReportsConfiguration {
  static EnvironmentInformation? environmentInformation;

  LatticeReportsConfiguration(
      {required EnvironmentInformation environmentInfo,
      required AuthenticationInformation authenticationInfo,
      required ApplicationInformation applicationInfo,
      required void Function(String message) e,
      required void Function(String message) i,
      required void Function(String message) v}) {
    LoggerWrapper().configure(i: i, v: v, e: e);
    LatticeReportsConfiguration.environmentInformation = environmentInfo;
    AuthenticationMessenger()
        .configure(authenticationInformation: authenticationInfo);

    ApplicationInformationMessenger()
        .configure(applicationInformation: applicationInfo);
  }
}

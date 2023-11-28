import 'package:lattice_reports/ApplicationInformation/Data/application_information.dart';
import 'package:lattice_reports/ApplicationInformation/Data/application_information_messenger.dart';
import 'package:lattice_reports/Authentication/Data/authentication_information.dart';
import 'package:lattice_reports/Authentication/Messaging/authentication_messenger.dart';
import 'package:lattice_reports/Dataflow/environment_information.dart';
import 'package:lattice_reports/Logging/logger_wrapper.dart';

class LatticeReportsConfiguration {
  static EnvironmentInformation? environmentInformation;

  LatticeReportsConfiguration({
    required EnvironmentInformation environmentInfo,
    required AuthenticationInformation authenticationInfo,
    required ApplicationInformation applicationInfo,
    required LoggerWrapper logger,
  }) {
    LatticeReportsConfiguration.environmentInformation = environmentInfo;
    AuthenticationMessenger().configure(
        getAuthenticationInformation: () async => authenticationInfo,
        authenticationInformation: authenticationInfo);

    ApplicationInformationMessenger().configure(
        getApplicationInformationAsync: () async => applicationInfo,
        applicationInformation: applicationInfo);
  }
}

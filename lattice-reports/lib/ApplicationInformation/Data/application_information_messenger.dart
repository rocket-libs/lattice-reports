import 'package:lattice_reports/ApplicationInformation/Data/application_information.dart';
import 'package:lattice_reports/Messaging/messenger.dart';

class ApplicationInformationMessenger
    extends Messenger<ApplicationInformation> {
  Future<ApplicationInformation> Function()? _getApplicationInformationAsync;

  ApplicationInformationMessenger._() {
    refreshAsync();
  }

  configure(
      {required Future<ApplicationInformation> Function()
          getApplicationInformationAsync,
      required ApplicationInformation applicationInformation}) {
    _getApplicationInformationAsync = getApplicationInformationAsync;
    single = applicationInformation;
  }

  static final ApplicationInformationMessenger _instance =
      ApplicationInformationMessenger._();

  factory ApplicationInformationMessenger() => _instance;

  @override
  String get name => "ApplicationInformationStream";

  ApplicationInformation get applicationInformation {
    if (many.isEmpty) {
      return ApplicationInformation(
          applicationName: "...",
          applicationVersion: "0.0.0",
          buildNumber: "0");
    } else {
      return many.first;
    }
  }

  @override
  Future refreshAsync() async {
    if (_getApplicationInformationAsync == null) {
      throw Exception("ApplicationInformation messenger is not configured.");
    }
    single = await _getApplicationInformationAsync!();
  }
}

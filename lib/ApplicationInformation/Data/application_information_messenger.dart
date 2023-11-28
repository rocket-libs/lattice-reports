import 'package:lattice_reports/ApplicationInformation/Data/application_information.dart';
import 'package:lattice_reports/Messaging/messenger.dart';

class ApplicationInformationMessenger
    extends Messenger<ApplicationInformation> {
  ApplicationInformationMessenger._();

  configure({required ApplicationInformation applicationInformation}) {
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
  Future refreshAsync() {
    return Future.value();
  }
}

import 'package:flutter/material.dart';
import 'package:lattice_reports/Authentication/Messaging/authentication_messenger.dart';
import 'package:lattice_reports/Data/report_argument_model.dart';
import 'package:lattice_reports/ReportArgumentsStrip/Data/report_arguments_strip_permissions.dart';
import 'package:lattice_reports/ReportArgumentsStrip/UI/report_arguments_strip.dart';

class ReportContainer extends StatefulWidget {
  final Widget? header;
  final Widget body;
  final ReportArgumentsStripPermissions reportArgumentsStripPermissions;
  final bool canRunReport;
  final ReportArgumentModel reportArgumentModel;
  final Future<void> Function() onRunReport;
  final Function(ReportArgumentModel) onReportArgumentModelChanged;
  final Function(bool) onDialogVisibilityChanged;
  final Widget? customArguments;

  const ReportContainer(
      {super.key,
      required this.body,
      required this.reportArgumentsStripPermissions,
      required this.canRunReport,
      required this.reportArgumentModel,
      required this.onRunReport,
      required this.onReportArgumentModelChanged,
      required this.onDialogVisibilityChanged,
      this.header,
      this.customArguments});
  @override
  State<StatefulWidget> createState() {
    return _ReportContainerState();
  }
}

class _ReportContainerState extends State<ReportContainer> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setDefaultVendorLocation();
      widget.onRunReport();
    });
  }

  _setDefaultVendorLocation() {
    if (widget.reportArgumentModel.vendorLocations.isEmpty) {
      final currentVendorLocation =
          AuthenticationMessenger().currentVendorLocation;
      if (currentVendorLocation != null) {
        widget.reportArgumentModel.vendorLocations.add(currentVendorLocation);
        widget.onReportArgumentModelChanged(widget.reportArgumentModel);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Fixed position widgets
        ReportArgumentsStrip(
          permissions: widget.reportArgumentsStripPermissions,
          onDialogVisibilityChanged: (visible) {
            widget.onDialogVisibilityChanged(visible);
          },
          canRunReport: widget.canRunReport,
          reportArgumentModel: widget.reportArgumentModel,
          onRunReport: (reportArgumentModel) async {
            await widget.onRunReport();
          },
          onReportArgumentModelChanged: (reportArgs) async {
            widget.onReportArgumentModelChanged(reportArgs);
            await widget.onRunReport();
          },
          customArguments: widget.customArguments ?? Container(),
        ),
        widget.header ?? Container(),
        // Scrollable content
        Expanded(
          child: widget.body,
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lattice_reports/AppMultiselect/check_box_dialog.dart';
import 'package:lattice_reports/Authentication/Messaging/authentication_messenger.dart';
import 'package:lattice_reports/Data/report_argument_model.dart';
import 'package:lattice_reports/NonNullable/non_nullable_extensions.dart';
import 'package:lattice_reports/ReportArgumentsStrip/Data/report_arguments_strip_permissions.dart';
import 'package:lattice_reports/UI/date_range_picker.dart';
import 'package:lattice_reports/VendorLocations/Data/vendor_location_model.dart';
import 'package:lattice_reports/lattice_reports_configuration.dart';

class ReportArgumentsStrip extends StatefulWidget {
  final ReportArgumentModel reportArgumentModel;
  final Function(ReportArgumentModel) onReportArgumentModelChanged;
  final Function(ReportArgumentModel reportArgumentModel) onRunReport;
  final Function(bool visible) onDialogVisibilityChanged;
  final ReportArgumentsStripPermissions permissions;
  final Widget? customArguments;

  final bool canRunReport;

  const ReportArgumentsStrip(
      {super.key,
      required this.reportArgumentModel,
      required this.onReportArgumentModelChanged,
      required this.onRunReport,
      required this.canRunReport,
      required this.onDialogVisibilityChanged,
      required this.permissions,
      this.customArguments});
  @override
  State<StatefulWidget> createState() {
    return _ReportArgumentsStripState();
  }
}

class _ReportArgumentsStripState extends State<ReportArgumentsStrip> {
  final strings = LatticeReportsConfiguration.strings;
  // showDialogVendorLocationPicker(BuildContext context) async {
  //   final tempArgs = ReportArgumentModel(
  //       dateOne: widget.reportArgumentModel.dateOne,
  //       dateTwo: widget.reportArgumentModel.dateTwo,
  //       vendorLocations: widget.reportArgumentModel.vendorLocations);

  //   await showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title:  Text(strings.selectStores),
  //       content: VendorLocationsPicker(
  //         vendorLocations: AuthenticationMessenger().vendorLocations,
  //         onSelectedVendorLocationsChanged: (selectedVendorLocations) {
  //           tempArgs.vendorLocations = selectedVendorLocations.toList();
  //         },
  //         selectedVendorLocations: tempArgs.vendorLocations,
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(
  //             context,
  //           ),
  //           child: const Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             widget.reportArgumentModel.vendorLocations =
  //                 tempArgs.vendorLocations;
  //             widget.onReportArgumentModelChanged(widget.reportArgumentModel);

  //             Navigator.pop(context);
  //           },
  //           child: const Text('OK'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  showDialogDateRange(BuildContext context) async {
    final tempArgs = ReportArgumentModel(
        dateOne: widget.reportArgumentModel.dateOne,
        dateTwo: widget.reportArgumentModel.dateTwo,
        vendorLocations: widget.reportArgumentModel.vendorLocations);

    try {
      widget.onDialogVisibilityChanged(true);
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(strings.selectDate),
          content: DateRangePicker(
            reportArgumentModel: tempArgs,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(
                context,
              ),
              child: Text(strings.cancel),
            ),
            TextButton(
              onPressed: () {
                widget.reportArgumentModel.dateOne = tempArgs.dateOne;
                widget.reportArgumentModel.dateTwo = tempArgs.dateTwo;
                widget.onReportArgumentModelChanged(widget.reportArgumentModel);

                Navigator.pop(context);
              },
              child: Text(strings.ok),
            ),
          ],
        ),
      );
    } finally {
      widget.onDialogVisibilityChanged(false);
    }
  }

  Widget _getGetArgItem({
    required String label,
    required String value,
    required Function onTapped,
    required Future<bool> Function() canChangeResolver,
  }) {
    return FutureBuilder<bool>(
        future: canChangeResolver(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container();
          } else {
            final canChange = snapshot.data ?? true;
            final linkStyle = canChange == false
                ? const TextStyle(color: Colors.grey)
                : const TextStyle(color: Colors.blue);
            return Container(
              margin: const EdgeInsets.only(top: 5),
              child: InkWell(
                onTap: canChange == false
                    ? null
                    : () {
                        onTapped();
                      },
                child: Row(
                  children: [
                    Text(
                      label,
                      style: linkStyle,
                    ),
                    Text(
                      value,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: linkStyle,
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }

  _showStorePickerAsync() async {
    try {
      widget.onDialogVisibilityChanged(true);
      await showDialog(
        context: context,
        builder: (context) {
          return CheckBoxDialog<VendorLocationModel>(
              key: UniqueKey(),
              options: AuthenticationMessenger().vendorLocations.toSet(),
              title: strings.selectStores,
              getLabel: (opt) =>
                  (opt as VendorLocationModel).displayLabel.valueOrDefault(),
              selectedOptions:
                  widget.reportArgumentModel.vendorLocations.toSet(),
              onOk: (selectedOptions) {
                widget.reportArgumentModel.vendorLocations = selectedOptions
                    .map((e) => e as VendorLocationModel)
                    .toList();
                widget.onReportArgumentModelChanged(widget.reportArgumentModel);
              });
        },
      );
    } finally {
      widget.onDialogVisibilityChanged(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Card(
        elevation: .3,
        child: Container(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.reportFilters,
                style: const TextStyle(fontSize: 20),
              ),
              _getGetArgItem(
                label: "${strings.date}: ",
                value: widget.reportArgumentModel.dateDescription,
                onTapped: () async {
                  await showDialogDateRange(context);
                },
                canChangeResolver: () async {
                  return await widget.permissions.canChangeDateRange();
                },
              ),
              _getGetArgItem(
                label: "${strings.stores}: ",
                value: widget.reportArgumentModel.vendorLocationsDescription,
                onTapped: () async {
                  await _showStorePickerAsync();
                },
                canChangeResolver: () async {
                  return await widget.permissions.canChangeVendorLocations();
                },
              ),
              widget.customArguments ?? Container(),
              // Container(
              //   margin: const EdgeInsets.only(top: 10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       ElevatedButton(
              //           onPressed: widget.canRunReport == false
              //               ? null
              //               : () {
              //                   widget.onRunReport(widget.reportArgumentModel);
              //                 },
              //           child: const Text("View Report"))
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

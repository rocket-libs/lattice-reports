import 'package:flutter/material.dart';
import 'package:lattice_reports/Data/report_argument_model.dart';
import 'package:lattice_reports/UI/date_range_picker.dart';
import 'package:lattice_reports/VendorLocations/Data/vendor_location_model.dart';
import 'package:lattice_reports/VendorLocations/UI/vendor_locations_picker.dart';

class ReportArgumentsStrip extends StatefulWidget {
  final ReportArgumentModel reportArgumentModel;
  final Function(ReportArgumentModel) onReportArgumentModelChanged;
  final Function(ReportArgumentModel reportArgumentModel) onRunReport;
  final List<VendorLocationModel> vendorLocations;
  final bool canRunReport;

  const ReportArgumentsStrip(
      {super.key,
      required this.reportArgumentModel,
      required this.onReportArgumentModelChanged,
      required this.onRunReport,
      required this.vendorLocations,
      required this.canRunReport});
  @override
  State<StatefulWidget> createState() {
    return _ReportArgumentsStripState();
  }
}

class _ReportArgumentsStripState extends State<ReportArgumentsStrip> {
  showDialogVendorLocationPicker(BuildContext context) async {
    final tempArgs = ReportArgumentModel(
        dateOne: widget.reportArgumentModel.dateOne,
        dateTwo: widget.reportArgumentModel.dateTwo,
        vendorLocations: widget.reportArgumentModel.vendorLocations);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Branches"),
        content: VendorLocationsPicker(
          vendorLocations: widget.vendorLocations,
          onSelectedVendorLocationsChanged: (selectedVendorLocations) {
            tempArgs.vendorLocations = selectedVendorLocations.toList();
          },
          selectedVendorLocations: tempArgs.vendorLocations,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(
              context,
            ),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.reportArgumentModel.vendorLocations =
                  tempArgs.vendorLocations;
              widget.onReportArgumentModelChanged(widget.reportArgumentModel);

              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  showDialogDateRange(BuildContext context) async {
    final tempArgs = ReportArgumentModel(
        dateOne: widget.reportArgumentModel.dateOne,
        dateTwo: widget.reportArgumentModel.dateTwo,
        vendorLocations: widget.reportArgumentModel.vendorLocations);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Date"),
        content: DateRangePicker(
          reportArgumentModel: tempArgs,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(
              context,
            ),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.reportArgumentModel.dateOne = tempArgs.dateOne;
              widget.reportArgumentModel.dateTwo = tempArgs.dateTwo;
              widget.onReportArgumentModelChanged(widget.reportArgumentModel);

              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _getGetArgItem({
    required String label,
    required String value,
    required Function onTapped,
  }) {
    const linkStyle = TextStyle(color: Colors.blue);
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: InkWell(
        onTap: () {
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
              const Text(
                "Report Filters",
                style: TextStyle(fontSize: 20),
              ),
              _getGetArgItem(
                label: "Date: ",
                value: widget.reportArgumentModel.dateDescription,
                onTapped: () async {
                  await showDialogDateRange(context);
                },
              ),
              _getGetArgItem(
                label: "Branches: ",
                value: widget.reportArgumentModel.vendorLocationsDescription,
                onTapped: () async {
                  await showDialogVendorLocationPicker(context);
                },
              ),
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

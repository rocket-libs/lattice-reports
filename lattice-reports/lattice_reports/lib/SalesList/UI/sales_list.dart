import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:lattice_reports/Blocstar/UI/widget_state.dart';
import 'package:lattice_reports/NonNullable/non_nullable_extensions.dart';
import 'package:lattice_reports/UI/report_arguments_strip.dart';
import 'package:lattice_reports/VendorLocations/Data/vendor_location_model.dart';
import 'package:lattice_reports/WithProgress/UI/with_progress.dart';
import '../Blocstar/sales_list_logic.dart';

class SalesList extends StatefulWidget {
  final List<VendorLocationModel> vendorLocations;
  const SalesList({super.key, required this.vendorLocations});

  @override
  State<StatefulWidget> createState() {
    return _SalesListState();
  }
}

class _SalesListState extends WidgetState<SalesList, SalesListLogic> {
  String _getPrettyLabel({required String value}) {
    final bits = value.split(".");
    try {
      Guid(bits[0]);
      return bits[1];
    } catch (e) {
      return value;
    }
  }

  Widget _getCardRow({required String label, dynamic value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(label),
        ),
        SizedBox(
          width: 60,
          child: Text(
            (value ?? "").toString(),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  @override
  Widget buildRootWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales List"),
      ),
      body: WithProgress(
        showProgress: isBusy,
        child: Column(
          children: [
            // Fixed position widgets
            ReportArgumentsStrip(
              canRunReport: logic.canCallApi,
              vendorLocations: widget.vendorLocations,
              reportArgumentModel: logic.context.reportArgumentModel,
              onRunReport: (reportArgumentModel) async {
                await logic.runReportAsync();
              },
              onReportArgumentModelChanged: (reportArgs) async {
                logic.context.merge(newReportArgumentModel: reportArgs);
                await logic.runReportAsync();
              },
            ),
            Container(
                margin: const EdgeInsets.only(top: 0),
                child: Card(
                  elevation: 0.3,
                  child: ListTile(
                    title: Text(
                      "Grand Total",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    trailing: Text(
                      logic.grandTotal.formatAsCurrency(),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                )),
            // Scrollable content
            Expanded(
              child: ListView(
                children: List.generate(logic.sales.length, (index) {
                  final item = logic.sales[index];
                  return Card(
                    elevation: 0.3,
                    child: ListTile(
                      leading: Text((index + 1).toString()),
                      title: Text(
                        _getPrettyLabel(
                            value: item.displayLabel.valueOrDefault()),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: logic.showingMultipleDates
                          ? Container()
                          : Column(
                              children: [
                                _getCardRow(
                                    label: "Quantity",
                                    value: item.quantity
                                        .toDouble()
                                        .formatAsCurrency()),
                                _getCardRow(
                                    label: "Price",
                                    value: item.value.formatAsCurrency()),
                              ],
                            ),
                      trailing: Text(
                        item.lineTotal.formatAsCurrency(),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                      ),
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:lattice_reports/Blocstar/UI/widget_state.dart';
import 'package:lattice_reports/NonNullable/non_nullable_extensions.dart';
import 'package:lattice_reports/UI/report_arguments_strip.dart';
import 'package:lattice_reports/WithProgress/UI/with_progress.dart';
import 'package:lattice_reports/lattice_reports_configuration.dart';
import '../Blocstar/sales_list_logic.dart';

class SalesList extends StatefulWidget {
  const SalesList({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SalesListState();
  }
}

class _SalesListState extends WidgetState<SalesList, SalesListLogic> {
  bool _hideContent = false;
  final strings = LatticeReportsConfiguration.strings;
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
  Future<void> onFirstBuildAsync() async {
    if (logic.canCallApi) {
      await logic.runReportAsync();
    }
    return super.onFirstBuildAsync();
  }

  @override
  Widget buildRootWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.salesList),
      ),
      body: _hideContent
          ? Container()
          : WithProgress(
              showProgress: isBusy,
              child: Column(
                children: [
                  // Fixed position widgets
                  ReportArgumentsStrip(
                    onDialogVisibilityChanged: (visible) {
                      setState(() {
                        _hideContent = visible;
                      });
                    },
                    canRunReport: logic.canCallApi,
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

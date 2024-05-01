import 'package:flutter/material.dart';
import 'package:lattice_reports/AppMultiselect/check_box_dialog.dart';
import 'package:lattice_reports/NonNullable/non_nullable_extensions.dart';
import 'package:lattice_reports/lattice_reports_configuration.dart';

class ReportPaymentMethodPicker extends StatefulWidget {
  final Set<String> paymentMethods;
  final Set<String> selectedOptions;
  final Function(Set<dynamic> selectedOptions) onSelectedOptionsChanged;

  const ReportPaymentMethodPicker(
      {super.key,
      required this.paymentMethods,
      required this.selectedOptions,
      required this.onSelectedOptionsChanged});
  @override
  State<StatefulWidget> createState() {
    return _ReportPaymentMethodPickerState();
  }
}

class _ReportPaymentMethodPickerState extends State<ReportPaymentMethodPicker> {
  final strings = LatticeReportsConfiguration.strings;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  _showPaymentMethodPicker() async {
    await showDialog(
      context: context,
      builder: (context) {
        return CheckBoxDialog<String>(
            key: UniqueKey(),
            options: widget.paymentMethods.toSet(),
            title: strings.selectPaymentMethods,
            getLabel: (opt) => (opt ?? "").toString().valueOrDefault(),
            selectedOptions: widget.selectedOptions.toSet(),
            onOk: (selectedOptions) {
              widget.onSelectedOptionsChanged(selectedOptions);
            });
      },
    );
  }

  String get _description {
    if (widget.selectedOptions.isEmpty) {
      return strings.all;
    } else {
      return widget.selectedOptions.join(", ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () async {
            await _showPaymentMethodPicker();
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Text(
              "${strings.paymentMethods}: $_description",
              style: const TextStyle(color: Colors.blue),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }
}

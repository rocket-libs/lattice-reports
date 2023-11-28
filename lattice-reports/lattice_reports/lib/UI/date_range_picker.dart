import 'package:flutter/material.dart';
import 'package:lattice_reports/Data/report_argument_model.dart';
import 'package:lattice_reports/NonNullable/non_nullable_extensions.dart';

class DateRangePicker extends StatefulWidget {
  final ReportArgumentModel reportArgumentModel;
  const DateRangePicker({super.key, required this.reportArgumentModel});

  @override
  State<StatefulWidget> createState() {
    return _DateRangePickerState();
  }
}

class _DateRangePickerState extends State<DateRangePicker> {
  Widget _getDatePicker(
      {required String label,
      required DateTime value,
      required Function(DateTime pickedDate) onDatePicked,
      DateTime? minDate}) {
    return InkWell(
      child: Container(
          width: 200,
          margin: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5)),
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(label),
              Text(value.toDDDashMMMDashYYYY()),
            ],
          )),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: minDate ?? DateTime(2023),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          onDatePicked(date);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _getDatePicker(
                label: "From",
                value: widget.reportArgumentModel.dateOne,
                onDatePicked: (date) {
                  setState(() {
                    if (widget.reportArgumentModel.dateTwo.isBefore(date)) {
                      widget.reportArgumentModel.dateTwo = date;
                    }
                    widget.reportArgumentModel.dateOne = date;
                  });
                },
                minDate: DateTime(2023)),
            _getDatePicker(
                label: "To",
                value: widget.reportArgumentModel.dateTwo,
                onDatePicked: (date) {
                  setState(() {
                    widget.reportArgumentModel.dateTwo = date;
                  });
                },
                minDate: widget.reportArgumentModel.dateOne),
          ],
        ),
      ),
    );
  }
}

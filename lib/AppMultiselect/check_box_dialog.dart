import 'package:flutter/material.dart';
import 'package:lattice_reports/lattice_reports_configuration.dart';

class CheckBoxDialog<TOption> extends StatefulWidget {
  final Set<TOption> options;
  final String title;
  final String Function(dynamic) getLabel;
  final Set<TOption> selectedOptions;
  final Function(Set<dynamic> selectedOptions) onOk;
  final Function()? onCancel;

  const CheckBoxDialog({
    super.key,
    required this.options,
    required this.title,
    required this.getLabel,
    required this.selectedOptions,
    required this.onOk,
    this.onCancel,
  });
  @override
  State<StatefulWidget> createState() {
    return _CheckBoxDialogState<TOption>();
  }
}

class _CheckBoxDialogState<TOption> extends State<CheckBoxDialog> {
  late final Set<TOption> _checkedItems;

  @override
  void initState() {
    super.initState();
    _checkedItems = widget.selectedOptions as Set<TOption>;
  }

  @override
  Widget build(BuildContext context) {
    final title = Container(
        padding: const EdgeInsets.all(10),
        child: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 25,
          ),
        ));

    final List<Widget> children = widget.options.map((specificItem) {
      final isChecked = _checkedItems.any((element) => element == specificItem);
      final label = widget.getLabel(specificItem);
      // ignore: unnecessary_cast
      return Row(
        children: [
          Checkbox(
              key: ValueKey(label),
              value: isChecked,
              onChanged: (value) {
                value = value ?? false;
                if (value) {
                  setState(() {
                    _checkedItems.add(specificItem);
                  });
                } else {
                  setState(() {
                    _checkedItems.remove(specificItem);
                  });
                }
              }),
          Text(
            label,
          ),
        ],
      ) as Widget;
    }).toList();
    children.insert(
      0,
      const Divider(),
    );
    children.insert(0, title);
    children.add(
      const Divider(),
    );
    children.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 20, bottom: 5),
            child: TextButton(
              onPressed: () {
                if (widget.onCancel != null) {
                  widget.onCancel!();
                }
                Navigator.of(context).pop();
              },
              child: Text(LatticeReportsConfiguration.strings.cancel),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 20, bottom: 5),
            child: TextButton(
              onPressed: () {
                widget.onOk(_checkedItems);
                Navigator.of(context).pop();
              },
              child: Text(LatticeReportsConfiguration.strings.select),
            ),
          ),
        ],
      ),
    );

    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

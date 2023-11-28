// import 'package:flutter/material.dart';

// class AppMultiselect<TOption> extends StatelessWidget {
//   final String label;
//   final Set<TOption> options;
//   final String Function(dynamic) getOptionLabel;
//   final Function(Set<dynamic> selectedOptions) onClosed;
//   final Set<TOption> selectedOptions;
//   final _textController = TextEditingController();

//   AppMultiselect(
//       {super.key,
//       required this.label,
//       required this.options,
//       required this.getOptionLabel,
//       required this.onClosed,
//       required this.selectedOptions});

//   _setText() {
//     _textController.text = "";
//     for (var selectedItem in selectedOptions) {
//       _textController.text += " ${getOptionLabel(selectedItem)},";
//     }
//     _textController.text = _textController.text.trim();
//     if (_textController.text.endsWith(",")) {
//       _textController.text =
//           _textController.text.substring(0, _textController.text.length - 1);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     _setText();
//     return TextFormField(
//       readOnly: true,
//       controller: _textController,
//       maxLines: 3,
//       decoration: InputDecoration(
//         labelText: label,
//         suffixIcon: Icon(LookAndFeelManager.icons.dropdownArrow),
//       ),
//       onTap: () async {
//         await showDialog(
//           context: context,
//           builder: (context) {
//             return _CheckBoxDialog<TOption>(
//               key: UniqueKey(),
//               options: options,
//               title: label,
//               getLabel: (opt) => getOptionLabel(opt),
//               selectedOptions: selectedOptions,
//               onClosed: onClosed,
//             );
//           },
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:lattice_reports/NonNullable/non_nullable_extensions.dart';
import 'package:lattice_reports/VendorLocations/Data/vendor_location_model.dart';

class VendorLocationsPicker extends StatefulWidget {
  final List<VendorLocationModel> vendorLocations;
  final List<VendorLocationModel> selectedVendorLocations;
  final Function(List<VendorLocationModel>) onSelectedVendorLocationsChanged;

  const VendorLocationsPicker(
      {super.key,
      required this.vendorLocations,
      required this.onSelectedVendorLocationsChanged,
      required this.selectedVendorLocations});

  @override
  State<StatefulWidget> createState() {
    return _VendorLocationsPickerState();
  }
}

class _VendorLocationsPickerState extends State<VendorLocationsPicker> {
  bool _getIsChecked({required VendorLocationModel vendorLocationModel}) {
    return widget.selectedVendorLocations
        .any((element) => element.id == vendorLocationModel.id);
  }

  List<Widget> get _vendoLocationCheckBoxes {
    return widget.vendorLocations.map((e) {
      return Row(
        key: Key(e.id.toString()),
        children: [
          Checkbox(
            value: _getIsChecked(vendorLocationModel: e),
            onChanged: (value) {
              setState(() {
                if (value ?? false) {
                  widget.selectedVendorLocations.add(e);
                } else {
                  widget.selectedVendorLocations.remove(e);
                }
                widget.onSelectedVendorLocationsChanged(
                    widget.selectedVendorLocations);
              });
            },
          ),
          Text(e.displayLabel.valueOrDefault()),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ..._vendoLocationCheckBoxes,
          ],
        ),
      ),
    );
  }
}

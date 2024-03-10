// Auto generated file, change at risk of code getting overwritten later

import 'package:flutter_guid/flutter_guid.dart';
import 'package:lattice_reports/Dataflow/model.dart';
import 'package:preflection/MapReader.dart';
import 'package:preflection/Preflectable.dart';

class OrderDataPointModel extends Model<OrderDataPointModel> {
  final DateTime? dated;
  final Guid? orderHeaderId;
  final String? displayLabel;
  final int? quantity;
  final double? value;
  final double? lineTotal;
  final Guid? orderLineItemId;
  final String? dateLabel;
  final String? methodOfPayment;
  final Guid? aggregatorId;
  final int? unAggregatedItemsCount;
  final String? phoneNumber;
  final String? orderNumber;

  OrderDataPointModel(
      {Guid? id,
      this.dated,
      this.orderHeaderId,
      this.displayLabel,
      this.quantity,
      this.value,
      this.lineTotal,
      this.orderLineItemId,
      this.dateLabel,
      this.methodOfPayment,
      this.aggregatorId,
      this.unAggregatedItemsCount,
      this.phoneNumber,
      this.orderNumber}) {
    this.id = id;
  }

  @override
  merge(
      {DateTime? newDated,
      Guid? newOrderHeaderId,
      String? newDisplayLabel,
      int? newQuantity,
      double? newValue,
      double? newLineTotal,
      Guid? newOrderLineItemId,
      String? newDateLabel,
      String? newMethodOfPayment,
      Guid? newAggregatorId,
      int? newUnAggregatedItemsCount,
      String? newPhoneNumber,
      String? newOrderNumber}) {
    return OrderDataPointModel(
        dated: resolveValue(dated, newDated),
        orderHeaderId: resolveValue(orderHeaderId, newOrderHeaderId),
        displayLabel: resolveValue(displayLabel, newDisplayLabel),
        quantity: resolveValue(quantity, newQuantity),
        value: resolveValue(value, newValue),
        lineTotal: resolveValue(lineTotal, newLineTotal),
        orderLineItemId: resolveValue(orderLineItemId, newOrderLineItemId),
        dateLabel: resolveValue(dateLabel, newDateLabel),
        methodOfPayment: resolveValue(methodOfPayment, newMethodOfPayment),
        aggregatorId: resolveValue(aggregatorId, newAggregatorId),
        unAggregatedItemsCount:
            resolveValue(unAggregatedItemsCount, newUnAggregatedItemsCount),
        phoneNumber: resolveValue(phoneNumber, newPhoneNumber),
        orderNumber: resolveValue(orderNumber, newOrderNumber),
        id: id);
  }

  @override
  OrderDataPointModel singleFromMap(Map<String, dynamic> map) {
    final mapReader = MapReader(map);
    return OrderDataPointModel(
      dated: mapReader.read<DateTime>(_FieldNames.dated),
      orderHeaderId: mapReader.read<Guid>(_FieldNames.orderHeaderId),
      displayLabel: mapReader.read<String>(_FieldNames.displayLabel),
      quantity: mapReader.read<int>(_FieldNames.quantity),
      value: mapReader.read<double>(_FieldNames.value),
      lineTotal: mapReader.read<double>(_FieldNames.lineTotal),
      orderLineItemId: mapReader.read<Guid>(_FieldNames.orderLineItemId),
      dateLabel: mapReader.read<String>(_FieldNames.dateLabel),
      methodOfPayment: mapReader.read<String>(_FieldNames.methodOfPayment),
      aggregatorId: mapReader.read<Guid>(_FieldNames.aggregatorId),
      unAggregatedItemsCount:
          mapReader.read<int>(_FieldNames.unAggregatedItemsCount),
      phoneNumber: mapReader.read<String>(_FieldNames.phoneNumber),
      orderNumber: mapReader.read<String>(_FieldNames.orderNumber,
          valueIfKeyMissing: ""),
      id: mapReader.read<Guid>(idFieldName,
          valueIfKeyMissing: Guid.defaultValue),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      _FieldNames.dated: dated?.toIso8601String(),
      _FieldNames.orderHeaderId: orderHeaderId != null
          ? orderHeaderId?.value
          : Guid.defaultValue.value,
      _FieldNames.displayLabel: displayLabel,
      _FieldNames.quantity: quantity,
      _FieldNames.value: value,
      _FieldNames.lineTotal: lineTotal,
      _FieldNames.orderLineItemId: orderLineItemId != null
          ? orderLineItemId?.value
          : Guid.defaultValue.value,
      _FieldNames.dateLabel: dateLabel,
      _FieldNames.methodOfPayment: methodOfPayment,
      _FieldNames.aggregatorId:
          aggregatorId != null ? aggregatorId?.value : Guid.defaultValue.value,
      _FieldNames.unAggregatedItemsCount: unAggregatedItemsCount,
      _FieldNames.phoneNumber: phoneNumber,
      _FieldNames.orderNumber: orderNumber,
      idFieldName: id != null ? id!.value : Guid.defaultValue.value,
    };
  }
}

class _FieldNames {
  static const String dated = "dated";
  static const String orderHeaderId = "orderHeaderId";
  static const String displayLabel = "displayLabel";
  static const String quantity = "quantity";
  static const String value = "value";
  static const String lineTotal = "lineTotal";
  static const String orderLineItemId = "orderLineItemId";
  static const String dateLabel = "dateLabel";
  static const String methodOfPayment = "methodOfPayment";
  static const String aggregatorId = "aggregatorId";
  static const String unAggregatedItemsCount = "unAggregatedItemsCount";
  static const String phoneNumber = "phoneNumber";
  static const String orderNumber = "orderNumber";
}

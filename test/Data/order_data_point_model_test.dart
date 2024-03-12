import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lattice_reports/Data/order_data_point_model.dart';

import 'test_preflector_config.dart';

void main() {
  final mappedData = {
    "dated": DateTime.now(),
    "orderHeaderId": Guid.defaultValue.toString(),
    "displayLabel": "displayLabel",
    "quantity": 1,
    "value": 1.0,
    "lineTotal": 1.0,
    "orderLineItemId": Guid.defaultValue.toString(),
    "dateLabel": "dateLabel",
    "methodOfPayment": "methodOfPayment",
    "aggregatorId": Guid.defaultValue.toString(),
    "unAggregatedItemsCount": 1,
    "phoneNumber": "phoneNumber"
  };

  testMissingValueDoesNotCrash<T>(String field, T expectedValue,
      T Function(OrderDataPointModel order) actualValueReader) {
    TestPreflectorConfig.configureForTest();

    if (mappedData.containsKey(field)) {
      mappedData.remove(field);
    }

    final dataPoint = OrderDataPointModel().singleFromMap(mappedData);
    expect(actualValueReader(dataPoint), expectedValue);
  }

  test("OrderDataPointModel does not crash if id is missing", () {
    testMissingValueDoesNotCrash("id", Guid.defaultValue, (a) => a.id);
  });

  test("OrderDataPointModel does not crash if orderNumber is missing", () {
    testMissingValueDoesNotCrash("orderNumber", "", (a) => a.orderNumber);
  });

  test("OrderDataPointModel does not crash if customerName is missing", () {
    testMissingValueDoesNotCrash("customerName", "", (a) => a.customerName);
  });

  test("OrderDataPointModel does not crash if accountNumber is missing", () {
    testMissingValueDoesNotCrash("accountNumber", "", (a) => a.accountNumber);
  });
}

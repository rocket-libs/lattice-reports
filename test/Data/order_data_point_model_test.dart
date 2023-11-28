import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lattice_reports/Data/order_data_point_model.dart';

import 'test_preflector_config.dart';

void main() {
  test("OrderDataPointModel does not crash if id is missing", () {
    TestPreflectorConfig.configureForTest();
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

    if (mappedData.containsKey("id")) {
      mappedData.remove("id");
    }

    final paymentInformation = OrderDataPointModel().singleFromMap(mappedData);
    expect(paymentInformation.id, Guid.defaultValue);
  });
}

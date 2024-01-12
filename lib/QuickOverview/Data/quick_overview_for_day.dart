class QuickOverviewForDay {
  final double sales;
  final int orders;
  final double revenue;
  final double discounts;
  final int customers;

  QuickOverviewForDay(
      {required this.customers,
      required this.discounts,
      required this.revenue,
      required this.sales,
      required this.orders});

  double get averageRevenuePerCustomer {
    if (orders == 0) {
      return 0;
    } else {
      return sales / customers;
    }
  }
}

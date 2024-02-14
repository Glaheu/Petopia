class Order {
  final String orderNumber;
  final DateTime date;
  final String time;
  final int numberOfItems;
  final double cost;
  final DateTime estimatedDeliveryTime;

  Order(
      {this.orderNumber,
      this.date,
      this.time,
      this.numberOfItems,
      this.cost,
      this.estimatedDeliveryTime});
}

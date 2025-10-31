import '../database.dart';

class OrderitemsTable extends SupabaseTable<OrderitemsRow> {
  @override
  String get tableName => 'Orderitems';

  @override
  OrderitemsRow createRow(Map<String, dynamic> data) => OrderitemsRow(data);
}

class OrderitemsRow extends SupabaseDataRow {
  OrderitemsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OrderitemsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  int? get orderId => getField<int>('order_id');
  set orderId(int? value) => setField<int>('order_id', value);

  int? get ticketId => getField<int>('ticket_id');
  set ticketId(int? value) => setField<int>('ticket_id', value);

  int? get quantity => getField<int>('quantity');
  set quantity(int? value) => setField<int>('quantity', value);

  String? get subPrice => getField<String>('sub_price');
  set subPrice(String? value) => setField<String>('sub_price', value);

  String? get userid => getField<String>('userid');
  set userid(String? value) => setField<String>('userid', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  bool? get usedPremiumDiscount => getField<bool>('used_premium_discount');
  set usedPremiumDiscount(bool? value) =>
      setField<bool>('used_premium_discount', value);

  dynamic get userequipments => getField<dynamic>('userequipments');
  set userequipments(dynamic value) =>
      setField<dynamic>('userequipments', value);
}

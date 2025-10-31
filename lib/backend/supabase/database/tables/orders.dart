import '../database.dart';

class OrdersTable extends SupabaseTable<OrdersRow> {
  @override
  String get tableName => 'orders';

  @override
  OrdersRow createRow(Map<String, dynamic> data) => OrdersRow(data);
}

class OrdersRow extends SupabaseDataRow {
  OrdersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OrdersTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get totalPrice => getField<String>('total_price');
  set totalPrice(String? value) => setField<String>('total_price', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get paymentid => getField<String>('paymentid');
  set paymentid(String? value) => setField<String>('paymentid', value);

  String get type => getField<String>('type')!;
  set type(String value) => setField<String>('type', value);
}

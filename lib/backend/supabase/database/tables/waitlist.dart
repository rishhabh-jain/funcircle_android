import '../database.dart';

class WaitlistTable extends SupabaseTable<WaitlistRow> {
  @override
  String get tableName => 'waitlist';

  @override
  WaitlistRow createRow(Map<String, dynamic> data) => WaitlistRow(data);
}

class WaitlistRow extends SupabaseDataRow {
  WaitlistRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => WaitlistTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  int get orderId => getField<int>('order_id')!;
  set orderId(int value) => setField<int>('order_id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  int? get ticketId => getField<int>('ticket_id');
  set ticketId(int? value) => setField<int>('ticket_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);
}

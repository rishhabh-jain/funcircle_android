import '../database.dart';

class DuosTable extends SupabaseTable<DuosRow> {
  @override
  String get tableName => 'duos';

  @override
  DuosRow createRow(Map<String, dynamic> data) => DuosRow(data);
}

class DuosRow extends SupabaseDataRow {
  DuosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DuosTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get requesterId => getField<String>('requester_id')!;
  set requesterId(String value) => setField<String>('requester_id', value);

  String get partnerId => getField<String>('partner_id')!;
  set partnerId(String value) => setField<String>('partner_id', value);

  String get status => getField<String>('status')!;
  set status(String value) => setField<String>('status', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

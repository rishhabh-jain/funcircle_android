import '../database.dart';

class RequestsTable extends SupabaseTable<RequestsRow> {
  @override
  String get tableName => 'requests';

  @override
  RequestsRow createRow(Map<String, dynamic> data) => RequestsRow(data);
}

class RequestsRow extends SupabaseDataRow {
  RequestsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => RequestsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  int? get groupId => getField<int>('group_id');
  set groupId(int? value) => setField<int>('group_id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  int? get membersNeeded => getField<int>('members_needed');
  set membersNeeded(int? value) => setField<int>('members_needed', value);
}

import '../database.dart';

class InterestedRequestsTable extends SupabaseTable<InterestedRequestsRow> {
  @override
  String get tableName => 'interested_requests';

  @override
  InterestedRequestsRow createRow(Map<String, dynamic> data) =>
      InterestedRequestsRow(data);
}

class InterestedRequestsRow extends SupabaseDataRow {
  InterestedRequestsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => InterestedRequestsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get otherUserId => getField<String>('other_user_id');
  set otherUserId(String? value) => setField<String>('other_user_id', value);

  int? get requestId => getField<int>('request_id');
  set requestId(int? value) => setField<int>('request_id', value);
}

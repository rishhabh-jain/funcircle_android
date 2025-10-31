import '../database.dart';

class PlayerRequestResponsesTable
    extends SupabaseTable<PlayerRequestResponsesRow> {
  @override
  String get tableName => 'findplayers.player_request_responses';

  @override
  PlayerRequestResponsesRow createRow(Map<String, dynamic> data) =>
      PlayerRequestResponsesRow(data);
}

class PlayerRequestResponsesRow extends SupabaseDataRow {
  PlayerRequestResponsesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PlayerRequestResponsesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get requestId => getField<String>('request_id')!;
  set requestId(String value) => setField<String>('request_id', value);

  String get responderId => getField<String>('responder_id')!;
  set responderId(String value) => setField<String>('responder_id', value);

  String get status => getField<String>('status')!;
  set status(String value) => setField<String>('status', value);

  String? get message => getField<String>('message');
  set message(String? value) => setField<String>('message', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}

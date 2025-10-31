import '../database.dart';

class ChatTypingIndicatorsTable extends SupabaseTable<ChatTypingIndicatorsRow> {
  @override
  String get tableName => 'typing_indicators';

  @override
  ChatTypingIndicatorsRow createRow(Map<String, dynamic> data) =>
      ChatTypingIndicatorsRow(data);
}

class ChatTypingIndicatorsRow extends SupabaseDataRow {
  ChatTypingIndicatorsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ChatTypingIndicatorsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get roomId => getField<String>('room_id')!;
  set roomId(String value) => setField<String>('room_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  DateTime? get startedAt => getField<DateTime>('started_at');
  set startedAt(DateTime? value) => setField<DateTime>('started_at', value);

  DateTime? get expiresAt => getField<DateTime>('expires_at');
  set expiresAt(DateTime? value) => setField<DateTime>('expires_at', value);
}

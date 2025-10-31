import '../database.dart';

class ChatMessageReadStatusTable extends SupabaseTable<ChatMessageReadStatusRow> {
  @override
  String get tableName => 'message_read_status';

  @override
  ChatMessageReadStatusRow createRow(Map<String, dynamic> data) =>
      ChatMessageReadStatusRow(data);
}

class ChatMessageReadStatusRow extends SupabaseDataRow {
  ChatMessageReadStatusRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ChatMessageReadStatusTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get messageId => getField<String>('message_id')!;
  set messageId(String value) => setField<String>('message_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  DateTime? get readAt => getField<DateTime>('read_at');
  set readAt(DateTime? value) => setField<DateTime>('read_at', value);
}

import '../database.dart';

class ChatMessageReactionsTable extends SupabaseTable<ChatMessageReactionsRow> {
  @override
  String get tableName => 'message_reactions';

  @override
  ChatMessageReactionsRow createRow(Map<String, dynamic> data) =>
      ChatMessageReactionsRow(data);
}

class ChatMessageReactionsRow extends SupabaseDataRow {
  ChatMessageReactionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ChatMessageReactionsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get messageId => getField<String>('message_id')!;
  set messageId(String value) => setField<String>('message_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get emoji => getField<String>('emoji')!;
  set emoji(String value) => setField<String>('emoji', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

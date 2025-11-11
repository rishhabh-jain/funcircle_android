import '../database.dart';

class ChatMessagesTable extends SupabaseTable<ChatMessagesRow> {
  @override
  String get tableName => 'messages';

  @override
  ChatMessagesRow createRow(Map<String, dynamic> data) => ChatMessagesRow(data);
}

class ChatMessagesRow extends SupabaseDataRow {
  ChatMessagesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ChatMessagesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get roomId => getField<String>('room_id')!;
  set roomId(String value) => setField<String>('room_id', value);

  String get senderId => getField<String>('sender_id')!;
  set senderId(String value) => setField<String>('sender_id', value);

  String? get content => getField<String>('content');
  set content(String? value) => setField<String>('content', value);

  String? get messageType => getField<String>('message_type');
  set messageType(String? value) => setField<String>('message_type', value);

  String? get mediaUrl => getField<String>('media_url');
  set mediaUrl(String? value) => setField<String>('media_url', value);

  String? get mediaType => getField<String>('media_type');
  set mediaType(String? value) => setField<String>('media_type', value);

  int? get mediaSize => getField<int>('media_size');
  set mediaSize(int? value) => setField<int>('media_size', value);

  String? get thumbnailUrl => getField<String>('thumbnail_url');
  set thumbnailUrl(String? value) => setField<String>('thumbnail_url', value);

  int? get sharedGroupId => getField<int>('shared_group_id');
  set sharedGroupId(int? value) => setField<int>('shared_group_id', value);

  int? get sharedTicketId => getField<int>('shared_ticket_id');
  set sharedTicketId(int? value) => setField<int>('shared_ticket_id', value);

  dynamic get sharedContentPreview => getField<dynamic>('shared_content_preview');
  set sharedContentPreview(dynamic value) =>
      setField<dynamic>('shared_content_preview', value);

  String? get replyToMessageId => getField<String>('reply_to_message_id');
  set replyToMessageId(String? value) =>
      setField<String>('reply_to_message_id', value);

  bool? get isEdited => getField<bool>('is_edited');
  set isEdited(bool? value) => setField<bool>('is_edited', value);

  DateTime? get editedAt => getField<DateTime>('edited_at');
  set editedAt(DateTime? value) => setField<DateTime>('edited_at', value);

  bool? get isDeleted => getField<bool>('is_deleted');
  set isDeleted(bool? value) => setField<bool>('is_deleted', value);

  DateTime? get deletedAt => getField<DateTime>('deleted_at');
  set deletedAt(DateTime? value) => setField<DateTime>('deleted_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get senderName => getField<String>('sender_name');
  set senderName(String? value) => setField<String>('sender_name', value);

  String? get senderProfilePicture => getField<String>('sender_profile_picture');
  set senderProfilePicture(String? value) => setField<String>('sender_profile_picture', value);
}

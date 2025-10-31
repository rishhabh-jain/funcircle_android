import '../database.dart';

class ChatRoomMembersTable extends SupabaseTable<ChatRoomMembersRow> {
  @override
  String get tableName => 'room_members';

  @override
  ChatRoomMembersRow createRow(Map<String, dynamic> data) =>
      ChatRoomMembersRow(data);
}

class ChatRoomMembersRow extends SupabaseDataRow {
  ChatRoomMembersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ChatRoomMembersTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get roomId => getField<String>('room_id')!;
  set roomId(String value) => setField<String>('room_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String? get role => getField<String>('role');
  set role(String? value) => setField<String>('role', value);

  DateTime? get joinedAt => getField<DateTime>('joined_at');
  set joinedAt(DateTime? value) => setField<DateTime>('joined_at', value);

  DateTime? get lastSeenAt => getField<DateTime>('last_seen_at');
  set lastSeenAt(DateTime? value) => setField<DateTime>('last_seen_at', value);

  bool? get isMuted => getField<bool>('is_muted');
  set isMuted(bool? value) => setField<bool>('is_muted', value);

  bool? get isBanned => getField<bool>('is_banned');
  set isBanned(bool? value) => setField<bool>('is_banned', value);
}

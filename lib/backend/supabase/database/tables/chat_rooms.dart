import '../database.dart';

class ChatRoomsTable extends SupabaseTable<ChatRoomsRow> {
  @override
  String get tableName => 'rooms';

  @override
  ChatRoomsRow createRow(Map<String, dynamic> data) => ChatRoomsRow(data);
}

class ChatRoomsRow extends SupabaseDataRow {
  ChatRoomsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ChatRoomsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String get type => getField<String>('type')!;
  set type(String value) => setField<String>('type', value);

  String? get sportType => getField<String>('sport_type');
  set sportType(String? value) => setField<String>('sport_type', value);

  String? get avatarUrl => getField<String>('avatar_url');
  set avatarUrl(String? value) => setField<String>('avatar_url', value);

  int? get maxMembers => getField<int>('max_members');
  set maxMembers(int? value) => setField<int>('max_members', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  String? get createdBy => getField<String>('created_by');
  set createdBy(String? value) => setField<String>('created_by', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  dynamic get metaData => getField<dynamic>('meta_data');
  set metaData(dynamic value) => setField<dynamic>('meta_data', value);

  int? get venueId => getField<int>('venue_id');
  set venueId(int? value) => setField<int>('venue_id', value);
}

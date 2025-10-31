import '../database.dart';

class TagsTable extends SupabaseTable<TagsRow> {
  @override
  String get tableName => 'tags';

  @override
  TagsRow createRow(Map<String, dynamic> data) => TagsRow(data);
}

class TagsRow extends SupabaseDataRow {
  TagsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TagsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  int get ticketId => getField<int>('ticket_id')!;
  set ticketId(int value) => setField<int>('ticket_id', value);

  String get tag => getField<String>('tag')!;
  set tag(String value) => setField<String>('tag', value);
}

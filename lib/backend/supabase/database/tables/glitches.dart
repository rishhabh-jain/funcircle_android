import '../database.dart';

class GlitchesTable extends SupabaseTable<GlitchesRow> {
  @override
  String get tableName => 'glitches';

  @override
  GlitchesRow createRow(Map<String, dynamic> data) => GlitchesRow(data);
}

class GlitchesRow extends SupabaseDataRow {
  GlitchesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => GlitchesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  List<String> get images => getListField<String>('images');
  set images(List<String>? value) => setListField<String>('images', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);
}

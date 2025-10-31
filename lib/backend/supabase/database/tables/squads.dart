import '../database.dart';

class SquadsTable extends SupabaseTable<SquadsRow> {
  @override
  String get tableName => 'squads';

  @override
  SquadsRow createRow(Map<String, dynamic> data) => SquadsRow(data);
}

class SquadsRow extends SupabaseDataRow {
  SquadsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SquadsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get squadName => getField<String>('squad_name')!;
  set squadName(String value) => setField<String>('squad_name', value);

  dynamic get squadMembers => getField<dynamic>('squad_members')!;
  set squadMembers(dynamic value) => setField<dynamic>('squad_members', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String get squadAdmin => getField<String>('squad_admin')!;
  set squadAdmin(String value) => setField<String>('squad_admin', value);
}

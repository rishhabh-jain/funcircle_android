import '../database.dart';

class ConnectionsTable extends SupabaseTable<ConnectionsRow> {
  @override
  String get tableName => 'connections';

  @override
  ConnectionsRow createRow(Map<String, dynamic> data) => ConnectionsRow(data);
}

class ConnectionsRow extends SupabaseDataRow {
  ConnectionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ConnectionsTable();

  int get connectionId => getField<int>('connection_id')!;
  set connectionId(int value) => setField<int>('connection_id', value);

  String? get userId1 => getField<String>('user_id1');
  set userId1(String? value) => setField<String>('user_id1', value);

  String? get userId2 => getField<String>('user_id2');
  set userId2(String? value) => setField<String>('user_id2', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);
}

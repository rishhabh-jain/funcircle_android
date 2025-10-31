import '../database.dart';

class GameRequestsTable extends SupabaseTable<GameRequestsRow> {
  @override
  String get tableName => 'game_requests';

  @override
  GameRequestsRow createRow(Map<String, dynamic> data) => GameRequestsRow(data);
}

class GameRequestsRow extends SupabaseDataRow {
  GameRequestsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => GameRequestsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get sender => getField<String>('sender')!;
  set sender(String value) => setField<String>('sender', value);

  String get reciever => getField<String>('reciever')!;
  set reciever(String value) => setField<String>('reciever', value);

  String get type => getField<String>('type')!;
  set type(String value) => setField<String>('type', value);

  dynamic get dataField => getField<dynamic>('data');
  set dataField(dynamic value) => setField<dynamic>('data', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}

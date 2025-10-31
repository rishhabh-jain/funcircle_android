import '../database.dart';

class InterestsTable extends SupabaseTable<InterestsRow> {
  @override
  String get tableName => 'interests';

  @override
  InterestsRow createRow(Map<String, dynamic> data) => InterestsRow(data);
}

class InterestsRow extends SupabaseDataRow {
  InterestsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => InterestsTable();

  int get interestId => getField<int>('interest_id')!;
  set interestId(int value) => setField<int>('interest_id', value);

  String? get category => getField<String>('category');
  set category(String? value) => setField<String>('category', value);

  String? get interestName => getField<String>('interest_name');
  set interestName(String? value) => setField<String>('interest_name', value);
}

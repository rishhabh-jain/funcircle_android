import '../database.dart';

class GroupcategoriesTable extends SupabaseTable<GroupcategoriesRow> {
  @override
  String get tableName => 'groupcategories';

  @override
  GroupcategoriesRow createRow(Map<String, dynamic> data) =>
      GroupcategoriesRow(data);
}

class GroupcategoriesRow extends SupabaseDataRow {
  GroupcategoriesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => GroupcategoriesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get category => getField<String>('category');
  set category(String? value) => setField<String>('category', value);
}

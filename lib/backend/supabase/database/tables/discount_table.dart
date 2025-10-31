import '../database.dart';

class DiscountTableTable extends SupabaseTable<DiscountTableRow> {
  @override
  String get tableName => 'discount_table';

  @override
  DiscountTableRow createRow(Map<String, dynamic> data) =>
      DiscountTableRow(data);
}

class DiscountTableRow extends SupabaseDataRow {
  DiscountTableRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DiscountTableTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String get type => getField<String>('type')!;
  set type(String value) => setField<String>('type', value);

  double get value => getField<double>('value')!;
  set value(double value) => setField<double>('value', value);

  dynamic get metaFields => getField<dynamic>('meta_fields');
  set metaFields(dynamic value) => setField<dynamic>('meta_fields', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}

import '../database.dart';

class UserLocationsTable extends SupabaseTable<UserLocationsRow> {
  @override
  String get tableName => 'findplayers.user_locations';

  @override
  UserLocationsRow createRow(Map<String, dynamic> data) =>
      UserLocationsRow(data);
}

class UserLocationsRow extends SupabaseDataRow {
  UserLocationsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserLocationsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  double get latitude => getField<double>('latitude')!;
  set latitude(double value) => setField<double>('latitude', value);

  double get longitude => getField<double>('longitude')!;
  set longitude(double value) => setField<double>('longitude', value);

  bool get isAvailable => getField<bool>('is_available')!;
  set isAvailable(bool value) => setField<bool>('is_available', value);

  String? get sportType => getField<String>('sport_type');
  set sportType(String? value) => setField<String>('sport_type', value);

  int? get skillLevel => getField<int>('skill_level');
  set skillLevel(int? value) => setField<int>('skill_level', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);
}

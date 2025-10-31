import '../database.dart';

class VenuesTable extends SupabaseTable<VenuesRow> {
  @override
  String get tableName => 'venues';

  @override
  VenuesRow createRow(Map<String, dynamic> data) => VenuesRow(data);
}

class VenuesRow extends SupabaseDataRow {
  VenuesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VenuesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get venueName => getField<String>('venue_name');
  set venueName(String? value) => setField<String>('venue_name', value);

  List<String> get images => getListField<String>('images');
  set images(List<String>? value) => setListField<String>('images', value);

  String? get mapsLink => getField<String>('maps_link');
  set mapsLink(String? value) => setField<String>('maps_link', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get location => getField<String>('location');
  set location(String? value) => setField<String>('location', value);

  double? get lat => getField<double>('lat');
  set lat(double? value) => setField<double>('lat', value);

  double? get lng => getField<double>('lng');
  set lng(double? value) => setField<double>('lng', value);

  int? get groupId => getField<int>('group_id');
  set groupId(int? value) => setField<int>('group_id', value);
}

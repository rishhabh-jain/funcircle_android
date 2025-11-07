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

  String? get sportType => getField<String>('sport_type');
  set sportType(String? value) => setField<String>('sport_type', value);

  String? get city => getField<String>('city');
  set city(String? value) => setField<String>('city', value);

  String? get state => getField<String>('state');
  set state(String? value) => setField<String>('state', value);

  List<String> get amenities => getListField<String>('amenities');
  set amenities(List<String>? value) =>
      setListField<String>('amenities', value);

  int? get courtCount => getField<int>('court_count');
  set courtCount(int? value) => setField<int>('court_count', value);

  double? get pricePerHour => getField<double>('price_per_hour');
  set pricePerHour(double? value) => setField<double>('price_per_hour', value);

  bool? get isFeatured => getField<bool>('is_featured');
  set isFeatured(bool? value) => setField<bool>('is_featured', value);
}

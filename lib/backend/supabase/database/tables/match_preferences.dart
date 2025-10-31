import '../database.dart';

class MatchPreferencesTable extends SupabaseTable<MatchPreferencesRow> {
  @override
  String get tableName => 'findplayers.match_preferences';

  @override
  MatchPreferencesRow createRow(Map<String, dynamic> data) =>
      MatchPreferencesRow(data);
}

class MatchPreferencesRow extends SupabaseDataRow {
  MatchPreferencesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MatchPreferencesTable();

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get sportType => getField<String>('sport_type')!;
  set sportType(String value) => setField<String>('sport_type', value);

  double? get maxDistanceKm => getField<double>('max_distance_km');
  set maxDistanceKm(double? value) => setField<double>('max_distance_km', value);

  dynamic get preferredTimes => getField<dynamic>('preferred_times');
  set preferredTimes(dynamic value) =>
      setField<dynamic>('preferred_times', value);

  List<int> get skillLevelRange => getListField<int>('skill_level_range');
  set skillLevelRange(List<int>? value) =>
      setListField<int>('skill_level_range', value);

  List<int> get preferredVenues => getListField<int>('preferred_venues');
  set preferredVenues(List<int>? value) =>
      setListField<int>('preferred_venues', value);

  bool? get autoMatchEnabled => getField<bool>('auto_match_enabled');
  set autoMatchEnabled(bool? value) =>
      setField<bool>('auto_match_enabled', value);

  bool? get notificationEnabled => getField<bool>('notification_enabled');
  set notificationEnabled(bool? value) =>
      setField<bool>('notification_enabled', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}

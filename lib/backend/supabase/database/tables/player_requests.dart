import '../database.dart';

class PlayerRequestsTable extends SupabaseTable<PlayerRequestsRow> {
  @override
  String get tableName => 'findplayers.player_requests';

  @override
  PlayerRequestsRow createRow(Map<String, dynamic> data) =>
      PlayerRequestsRow(data);
}

class PlayerRequestsRow extends SupabaseDataRow {
  PlayerRequestsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PlayerRequestsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get sportType => getField<String>('sport_type')!;
  set sportType(String value) => setField<String>('sport_type', value);

  int? get venueId => getField<int>('venue_id');
  set venueId(int? value) => setField<int>('venue_id', value);

  String? get customLocation => getField<String>('custom_location');
  set customLocation(String? value) =>
      setField<String>('custom_location', value);

  double? get latitude => getField<double>('latitude');
  set latitude(double? value) => setField<double>('latitude', value);

  double? get longitude => getField<double>('longitude');
  set longitude(double? value) => setField<double>('longitude', value);

  int get playersNeeded => getField<int>('players_needed')!;
  set playersNeeded(int value) => setField<int>('players_needed', value);

  DateTime get scheduledTime => getField<DateTime>('scheduled_time')!;
  set scheduledTime(DateTime value) =>
      setField<DateTime>('scheduled_time', value);

  int? get skillLevel => getField<int>('skill_level');
  set skillLevel(int? value) => setField<int>('skill_level', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String get status => getField<String>('status')!;
  set status(String value) => setField<String>('status', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get expiresAt => getField<DateTime>('expires_at')!;
  set expiresAt(DateTime value) => setField<DateTime>('expires_at', value);
}

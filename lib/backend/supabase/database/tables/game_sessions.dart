import '../database.dart';

class GameSessionsTable extends SupabaseTable<GameSessionsRow> {
  @override
  String get tableName => 'findplayers.game_sessions';

  @override
  GameSessionsRow createRow(Map<String, dynamic> data) => GameSessionsRow(data);
}

class GameSessionsRow extends SupabaseDataRow {
  GameSessionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => GameSessionsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get creatorId => getField<String>('creator_id')!;
  set creatorId(String value) => setField<String>('creator_id', value);

  String get sportType => getField<String>('sport_type')!;
  set sportType(String value) => setField<String>('sport_type', value);

  int? get venueId => getField<int>('venue_id');
  set venueId(int? value) => setField<int>('venue_id', value);

  String get sessionType => getField<String>('session_type')!;
  set sessionType(String value) => setField<String>('session_type', value);

  int get maxPlayers => getField<int>('max_players')!;
  set maxPlayers(int value) => setField<int>('max_players', value);

  dynamic get currentPlayers => getField<dynamic>('current_players')!;
  set currentPlayers(dynamic value) =>
      setField<dynamic>('current_players', value);

  DateTime get scheduledTime => getField<DateTime>('scheduled_time')!;
  set scheduledTime(DateTime value) =>
      setField<DateTime>('scheduled_time', value);

  int get durationMinutes => getField<int>('duration_minutes')!;
  set durationMinutes(int value) => setField<int>('duration_minutes', value);

  int? get skillLevelRequired => getField<int>('skill_level_required');
  set skillLevelRequired(int? value) =>
      setField<int>('skill_level_required', value);

  bool? get isPrivate => getField<bool>('is_private');
  set isPrivate(bool? value) => setField<bool>('is_private', value);

  String? get sessionCode => getField<String>('session_code');
  set sessionCode(String? value) => setField<String>('session_code', value);

  String get status => getField<String>('status')!;
  set status(String value) => setField<String>('status', value);

  double? get latitude => getField<double>('latitude');
  set latitude(double? value) => setField<double>('latitude', value);

  double? get longitude => getField<double>('longitude');
  set longitude(double? value) => setField<double>('longitude', value);

  double? get costPerPlayer => getField<double>('cost_per_player');
  set costPerPlayer(double? value) => setField<double>('cost_per_player', value);

  String? get notes => getField<String>('notes');
  set notes(String? value) => setField<String>('notes', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}

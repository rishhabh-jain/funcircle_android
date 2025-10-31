import '../database.dart';

class MatchHistoryTable extends SupabaseTable<MatchHistoryRow> {
  @override
  String get tableName => 'findplayers.match_history';

  @override
  MatchHistoryRow createRow(Map<String, dynamic> data) => MatchHistoryRow(data);
}

class MatchHistoryRow extends SupabaseDataRow {
  MatchHistoryRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MatchHistoryTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get user1Id => getField<String>('user1_id')!;
  set user1Id(String value) => setField<String>('user1_id', value);

  String get user2Id => getField<String>('user2_id')!;
  set user2Id(String value) => setField<String>('user2_id', value);

  String get sportType => getField<String>('sport_type')!;
  set sportType(String value) => setField<String>('sport_type', value);

  double? get matchQualityScore => getField<double>('match_quality_score');
  set matchQualityScore(double? value) =>
      setField<double>('match_quality_score', value);

  String? get user1Feedback => getField<String>('user1_feedback');
  set user1Feedback(String? value) =>
      setField<String>('user1_feedback', value);

  String? get user2Feedback => getField<String>('user2_feedback');
  set user2Feedback(String? value) =>
      setField<String>('user2_feedback', value);

  bool? get playedTogether => getField<bool>('played_together');
  set playedTogether(bool? value) => setField<bool>('played_together', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

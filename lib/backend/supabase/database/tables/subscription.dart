import '../database.dart';

class SubscriptionTable extends SupabaseTable<SubscriptionRow> {
  @override
  String get tableName => 'subscription';

  @override
  SubscriptionRow createRow(Map<String, dynamic> data) => SubscriptionRow(data);
}

class SubscriptionRow extends SupabaseDataRow {
  SubscriptionRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SubscriptionTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  int get venueId => getField<int>('venue_id')!;
  set venueId(int value) => setField<int>('venue_id', value);

  dynamic get playingDateAndTime => getField<dynamic>('playing_date_and_time')!;
  set playingDateAndTime(dynamic value) =>
      setField<dynamic>('playing_date_and_time', value);

  String get type => getField<String>('type')!;
  set type(String value) => setField<String>('type', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);

  DateTime get endDate => getField<DateTime>('end_date')!;
  set endDate(DateTime value) => setField<DateTime>('end_date', value);
}

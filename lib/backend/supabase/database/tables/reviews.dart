import '../database.dart';

class ReviewsTable extends SupabaseTable<ReviewsRow> {
  @override
  String get tableName => 'reviews';

  @override
  ReviewsRow createRow(Map<String, dynamic> data) => ReviewsRow(data);
}

class ReviewsRow extends SupabaseDataRow {
  ReviewsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ReviewsTable();

  int get rating => getField<int>('rating')!;
  set rating(int value) => setField<int>('rating', value);

  String get toUserId => getField<String>('to_user_id')!;
  set toUserId(String value) => setField<String>('to_user_id', value);

  String get fromUserId => getField<String>('from_user_id')!;
  set fromUserId(String value) => setField<String>('from_user_id', value);

  int get ticketId => getField<int>('ticket_id')!;
  set ticketId(int value) => setField<int>('ticket_id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);
}

import '../database.dart';

class UserlikesTable extends SupabaseTable<UserlikesRow> {
  @override
  String get tableName => 'userlikes';

  @override
  UserlikesRow createRow(Map<String, dynamic> data) => UserlikesRow(data);
}

class UserlikesRow extends SupabaseDataRow {
  UserlikesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserlikesTable();

  int get likeId => getField<int>('like_id')!;
  set likeId(int value) => setField<int>('like_id', value);

  String? get likerUserId => getField<String>('liker_user_id');
  set likerUserId(String? value) => setField<String>('liker_user_id', value);

  String? get likedUserId => getField<String>('liked_user_id');
  set likedUserId(String? value) => setField<String>('liked_user_id', value);

  DateTime? get timestamp => getField<DateTime>('timestamp');
  set timestamp(DateTime? value) => setField<DateTime>('timestamp', value);

  bool? get fromrecommended => getField<bool>('fromrecommended');
  set fromrecommended(bool? value) => setField<bool>('fromrecommended', value);
}

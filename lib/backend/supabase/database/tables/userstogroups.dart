import '../database.dart';

class UserstogroupsTable extends SupabaseTable<UserstogroupsRow> {
  @override
  String get tableName => 'userstogroups';

  @override
  UserstogroupsRow createRow(Map<String, dynamic> data) =>
      UserstogroupsRow(data);
}

class UserstogroupsRow extends SupabaseDataRow {
  UserstogroupsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserstogroupsTable();

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  int get groupId => getField<int>('group_id')!;
  set groupId(int value) => setField<int>('group_id', value);

  String? get invitationStatus => getField<String>('invitation_status');
  set invitationStatus(String? value) =>
      setField<String>('invitation_status', value);

  String? get mobileNumber => getField<String>('mobile_number');
  set mobileNumber(String? value) => setField<String>('mobile_number', value);

  int get usertogroupid => getField<int>('usertogroupid')!;
  set usertogroupid(int value) => setField<int>('usertogroupid', value);
}

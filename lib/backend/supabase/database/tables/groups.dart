import '../database.dart';

class GroupsTable extends SupabaseTable<GroupsRow> {
  @override
  String get tableName => 'groups';

  @override
  GroupsRow createRow(Map<String, dynamic> data) => GroupsRow(data);
}

class GroupsRow extends SupabaseDataRow {
  GroupsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => GroupsTable();

  int get groupId => getField<int>('group_id')!;
  set groupId(int value) => setField<int>('group_id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get location => getField<String>('location');
  set location(String? value) => setField<String>('location', value);

  int? get joinedMembers => getField<int>('joined_members');
  set joinedMembers(int? value) => setField<int>('joined_members', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  bool? get exclusive => getField<bool>('exclusive');
  set exclusive(bool? value) => setField<bool>('exclusive', value);

  String? get profileImage => getField<String>('profile_image');
  set profileImage(String? value) => setField<String>('profile_image', value);

  List<String> get interests => getListField<String>('interests');
  set interests(List<String>? value) =>
      setListField<String>('interests', value);

  List<String> get images => getListField<String>('images');
  set images(List<String>? value) => setListField<String>('images', value);

  bool? get topEvents => getField<bool>('top_events');
  set topEvents(bool? value) => setField<bool>('top_events', value);

  String? get groupType => getField<String>('group_type');
  set groupType(String? value) => setField<String>('group_type', value);

  String? get category => getField<String>('category');
  set category(String? value) => setField<String>('category', value);

  String? get city => getField<String>('city');
  set city(String? value) => setField<String>('city', value);

  DateTime? get startdatetime => getField<DateTime>('startdatetime');
  set startdatetime(DateTime? value) =>
      setField<DateTime>('startdatetime', value);

  DateTime? get enddatetime => getField<DateTime>('enddatetime');
  set enddatetime(DateTime? value) => setField<DateTime>('enddatetime', value);

  String? get eventStatus => getField<String>('event_status');
  set eventStatus(String? value) => setField<String>('event_status', value);

  bool? get hidden => getField<bool>('hidden');
  set hidden(bool? value) => setField<bool>('hidden', value);

  bool? get iftickets => getField<bool>('iftickets');
  set iftickets(bool? value) => setField<bool>('iftickets', value);

  String? get userid => getField<String>('userid');
  set userid(String? value) => setField<String>('userid', value);

  String? get videos => getField<String>('videos');
  set videos(String? value) => setField<String>('videos', value);

  String? get premiumtype => getField<String>('premiumtype');
  set premiumtype(String? value) => setField<String>('premiumtype', value);
}

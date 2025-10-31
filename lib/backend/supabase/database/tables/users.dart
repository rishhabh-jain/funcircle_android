import '../database.dart';

class UsersTable extends SupabaseTable<UsersRow> {
  @override
  String get tableName => 'users';

  @override
  UsersRow createRow(Map<String, dynamic> data) => UsersRow(data);
}

class UsersRow extends SupabaseDataRow {
  UsersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UsersTable();

  String? get age => getField<String>('age');
  set age(String? value) => setField<String>('age', value);

  List<String> get images => getListField<String>('images');
  set images(List<String>? value) => setListField<String>('images', value);

  String? get location => getField<String>('location');
  set location(String? value) => setField<String>('location', value);

  String? get faith => getField<String>('faith');
  set faith(String? value) => setField<String>('faith', value);

  String? get drink => getField<String>('drink');
  set drink(String? value) => setField<String>('drink', value);

  String? get smoke => getField<String>('smoke');
  set smoke(String? value) => setField<String>('smoke', value);

  String? get college => getField<String>('college');
  set college(String? value) => setField<String>('college', value);

  String? get work => getField<String>('work');
  set work(String? value) => setField<String>('work', value);

  List<String> get interests => getListField<String>('interests');
  set interests(List<String>? value) =>
      setListField<String>('interests', value);

  String? get zodiac => getField<String>('zodiac');
  set zodiac(String? value) => setField<String>('zodiac', value);

  String? get politicalLeaning => getField<String>('political_leaning');
  set politicalLeaning(String? value) =>
      setField<String>('political_leaning', value);

  String? get hometown => getField<String>('hometown');
  set hometown(String? value) => setField<String>('hometown', value);

  List<String> get motherTongue => getListField<String>('mother_tongue');
  set motherTongue(List<String>? value) =>
      setListField<String>('mother_tongue', value);

  List<String> get recommendedUsers =>
      getListField<String>('recommended_users');
  set recommendedUsers(List<String>? value) =>
      setListField<String>('recommended_users', value);

  DateTime? get lastUpdated => getField<DateTime>('last_updated');
  set lastUpdated(DateTime? value) => setField<DateTime>('last_updated', value);

  List<String> get likedUsers => getListField<String>('liked_users');
  set likedUsers(List<String>? value) =>
      setListField<String>('liked_users', value);

  String? get firstName => getField<String>('first_name');
  set firstName(String? value) => setField<String>('first_name', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  DateTime? get birthday => getField<DateTime>('birthday');
  set birthday(DateTime? value) => setField<DateTime>('birthday', value);

  String? get gender => getField<String>('gender');
  set gender(String? value) => setField<String>('gender', value);

  String? get lookingFor => getField<String>('looking_for');
  set lookingFor(String? value) => setField<String>('looking_for', value);

  String? get height => getField<String>('height');
  set height(String? value) => setField<String>('height', value);

  String? get workoutStatus => getField<String>('workout_status');
  set workoutStatus(String? value) => setField<String>('workout_status', value);

  String? get pets => getField<String>('pets');
  set pets(String? value) => setField<String>('pets', value);

  String? get bio => getField<String>('bio');
  set bio(String? value) => setField<String>('bio', value);

  bool? get isPremium => getField<bool>('is_premium');
  set isPremium(bool? value) => setField<bool>('is_premium', value);

  int? get profileCompletion => getField<int>('profile_completion');
  set profileCompletion(int? value) =>
      setField<int>('profile_completion', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String? get graduationYear => getField<String>('graduation_year');
  set graduationYear(String? value) =>
      setField<String>('graduation_year', value);

  String? get company => getField<String>('company');
  set company(String? value) => setField<String>('company', value);

  int? get recommendationtimedays => getField<int>('recommendationtimedays');
  set recommendationtimedays(int? value) =>
      setField<int>('recommendationtimedays', value);

  bool? get openfordating => getField<bool>('openfordating');
  set openfordating(bool? value) => setField<bool>('openfordating', value);

  String? get premiumtype => getField<String>('premiumtype');
  set premiumtype(String? value) => setField<String>('premiumtype', value);

  DateTime? get premiumvalidtill => getField<DateTime>('premiumvalidtill');
  set premiumvalidtill(DateTime? value) =>
      setField<DateTime>('premiumvalidtill', value);

  List<String> get secrets => getListField<String>('secrets');
  set secrets(List<String>? value) => setListField<String>('secrets', value);

  DateTime? get created => getField<DateTime>('created');
  set created(DateTime? value) => setField<DateTime>('created', value);

  String? get usersetlevel => getField<String>('usersetlevel');
  set usersetlevel(String? value) => setField<String>('usersetlevel', value);

  String? get adminsetlevel => getField<String>('adminsetlevel');
  set adminsetlevel(String? value) => setField<String>('adminsetlevel', value);

  DateTime? get lastactive => getField<DateTime>('lastactive');
  set lastactive(DateTime? value) => setField<DateTime>('lastactive', value);

  bool? get isOnline => getField<bool>('isOnline');
  set isOnline(bool? value) => setField<bool>('isOnline', value);

  String? get profilePicture => getField<String>('profile_picture');
  set profilePicture(String? value) => setField<String>('profile_picture', value);

  int? get skillLevelBadminton => getField<int>('skill_level_badminton');
  set skillLevelBadminton(int? value) => setField<int>('skill_level_badminton', value);

  int? get skillLevelPickleball => getField<int>('skill_level_pickleball');
  set skillLevelPickleball(int? value) => setField<int>('skill_level_pickleball', value);

  List<String> get preferredSports => getListField<String>('preferred_sports');
  set preferredSports(List<String>? value) => setListField<String>('preferred_sports', value);
}

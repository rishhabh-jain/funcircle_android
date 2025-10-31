import '../database.dart';

class UserprofilecompletionstatusTable
    extends SupabaseTable<UserprofilecompletionstatusRow> {
  @override
  String get tableName => 'userprofilecompletionstatus';

  @override
  UserprofilecompletionstatusRow createRow(Map<String, dynamic> data) =>
      UserprofilecompletionstatusRow(data);
}

class UserprofilecompletionstatusRow extends SupabaseDataRow {
  UserprofilecompletionstatusRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserprofilecompletionstatusTable();

  bool? get nameCompleted => getField<bool>('name_completed');
  set nameCompleted(bool? value) => setField<bool>('name_completed', value);

  bool? get imagesCompleted => getField<bool>('images_completed');
  set imagesCompleted(bool? value) => setField<bool>('images_completed', value);

  bool? get religionCompleted => getField<bool>('religion_completed');
  set religionCompleted(bool? value) =>
      setField<bool>('religion_completed', value);

  bool? get educationWorkCompleted =>
      getField<bool>('education_work_completed');
  set educationWorkCompleted(bool? value) =>
      setField<bool>('education_work_completed', value);

  bool? get drinkCompleted => getField<bool>('drink_completed');
  set drinkCompleted(bool? value) => setField<bool>('drink_completed', value);

  bool? get smokeCompleted => getField<bool>('smoke_completed');
  set smokeCompleted(bool? value) => setField<bool>('smoke_completed', value);

  bool? get lookingForCompleted => getField<bool>('looking_for_completed');
  set lookingForCompleted(bool? value) =>
      setField<bool>('looking_for_completed', value);

  bool get completionstatus => getField<bool>('completionstatus')!;
  set completionstatus(bool value) => setField<bool>('completionstatus', value);

  int get currentStep => getField<int>('current_step')!;
  set currentStep(int value) => setField<int>('current_step', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);
}

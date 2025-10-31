import '../database.dart';

class UserpromptsTable extends SupabaseTable<UserpromptsRow> {
  @override
  String get tableName => 'userprompts';

  @override
  UserpromptsRow createRow(Map<String, dynamic> data) => UserpromptsRow(data);
}

class UserpromptsRow extends SupabaseDataRow {
  UserpromptsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserpromptsTable();

  int get userPromptId => getField<int>('user_prompt_id')!;
  set userPromptId(int value) => setField<int>('user_prompt_id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  int? get promptId => getField<int>('prompt_id');
  set promptId(int? value) => setField<int>('prompt_id', value);

  String? get answerText => getField<String>('answer_text');
  set answerText(String? value) => setField<String>('answer_text', value);
}

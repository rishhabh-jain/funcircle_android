import '../database.dart';

class PromptsTable extends SupabaseTable<PromptsRow> {
  @override
  String get tableName => 'prompts';

  @override
  PromptsRow createRow(Map<String, dynamic> data) => PromptsRow(data);
}

class PromptsRow extends SupabaseDataRow {
  PromptsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PromptsTable();

  int get promptId => getField<int>('prompt_id')!;
  set promptId(int value) => setField<int>('prompt_id', value);

  String? get questionText => getField<String>('question_text');
  set questionText(String? value) => setField<String>('question_text', value);
}

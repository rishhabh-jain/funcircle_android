import '../database.dart';

class TicketsTable extends SupabaseTable<TicketsRow> {
  @override
  String get tableName => 'tickets';

  @override
  TicketsRow createRow(Map<String, dynamic> data) => TicketsRow(data);
}

class TicketsRow extends SupabaseDataRow {
  TicketsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TicketsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  int? get groupId => getField<int>('group_id');
  set groupId(int? value) => setField<int>('group_id', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  int? get capacity => getField<int>('capacity');
  set capacity(int? value) => setField<int>('capacity', value);

  DateTime? get startdatetime => getField<DateTime>('startdatetime');
  set startdatetime(DateTime? value) =>
      setField<DateTime>('startdatetime', value);

  DateTime? get enddatetime => getField<DateTime>('enddatetime');
  set enddatetime(DateTime? value) => setField<DateTime>('enddatetime', value);

  String? get ticketstatus => getField<String>('ticketstatus');
  set ticketstatus(String? value) => setField<String>('ticketstatus', value);

  String? get price => getField<String>('price');
  set price(String? value) => setField<String>('price', value);

  bool? get priceincludinggst => getField<bool>('priceincludinggst');
  set priceincludinggst(bool? value) =>
      setField<bool>('priceincludinggst', value);

  String? get ticketpergroup => getField<String>('ticketpergroup');
  set ticketpergroup(String? value) =>
      setField<String>('ticketpergroup', value);

  String? get sku => getField<String>('sku');
  set sku(String? value) => setField<String>('sku', value);

  int? get bookedtickets => getField<int>('bookedtickets');
  set bookedtickets(int? value) => setField<int>('bookedtickets', value);

  String? get location => getField<String>('location');
  set location(String? value) => setField<String>('location', value);

  int? get wooid => getField<int>('wooid');
  set wooid(int? value) => setField<int>('wooid', value);

  int? get venueid => getField<int>('venueid');
  set venueid(int? value) => setField<int>('venueid', value);

  List<String> get images => getListField<String>('images');
  set images(List<String>? value) => setListField<String>('images', value);

  String? get servicecharge => getField<String>('servicecharge');
  set servicecharge(String? value) => setField<String>('servicecharge', value);

  String? get ticketType => getField<String>('ticket_type');
  set ticketType(String? value) => setField<String>('ticket_type', value);
}

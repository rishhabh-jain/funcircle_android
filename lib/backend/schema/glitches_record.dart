import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GlitchesRecord extends FirestoreRecord {
  GlitchesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "glitchtext" field.
  String? _glitchtext;
  String get glitchtext => _glitchtext ?? '';
  bool hasGlitchtext() => _glitchtext != null;

  // "images" field.
  List<String>? _images;
  List<String> get images => _images ?? const [];
  bool hasImages() => _images != null;

  void _initializeFields() {
    _glitchtext = snapshotData['glitchtext'] as String?;
    _images = getDataList(snapshotData['images']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('glitches');

  static Stream<GlitchesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => GlitchesRecord.fromSnapshot(s));

  static Future<GlitchesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => GlitchesRecord.fromSnapshot(s));

  static GlitchesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      GlitchesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static GlitchesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      GlitchesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'GlitchesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is GlitchesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createGlitchesRecordData({
  String? glitchtext,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'glitchtext': glitchtext,
    }.withoutNulls,
  );

  return firestoreData;
}

class GlitchesRecordDocumentEquality implements Equality<GlitchesRecord> {
  const GlitchesRecordDocumentEquality();

  @override
  bool equals(GlitchesRecord? e1, GlitchesRecord? e2) {
    const listEquality = ListEquality();
    return e1?.glitchtext == e2?.glitchtext &&
        listEquality.equals(e1?.images, e2?.images);
  }

  @override
  int hash(GlitchesRecord? e) =>
      const ListEquality().hash([e?.glitchtext, e?.images]);

  @override
  bool isValidKey(Object? o) => o is GlitchesRecord;
}

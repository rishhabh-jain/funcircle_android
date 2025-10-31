import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'add_images_widget.dart' show AddImagesWidget;
import 'package:flutter/material.dart';

class AddImagesModel extends FlutterFlowModel<AddImagesWidget> {
  ///  Local state fields for this page.

  List<String> imagesupdates = [];
  void addToImagesupdates(String item) => imagesupdates.add(item);
  void removeFromImagesupdates(String item) => imagesupdates.remove(item);
  void removeAtIndexFromImagesupdates(int index) =>
      imagesupdates.removeAt(index);
  void insertAtIndexInImagesupdates(int index, String item) =>
      imagesupdates.insert(index, item);
  void updateImagesupdatesAtIndex(int index, Function(String) updateFn) =>
      imagesupdates[index] = updateFn(imagesupdates[index]);

  int? addimagesindex = 0;

  ///  State fields for stateful widgets in this page.

  bool isDataUploading_firebaseImages = false;
  List<FFUploadedFile> uploadedLocalFiles_firebaseImages = [];
  List<String> uploadedFileUrls_firebaseImages = [];

  // Stores action output result for [Backend Call - Update Row(s)] action in IconButton widget.
  List<UsersRow>? images;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

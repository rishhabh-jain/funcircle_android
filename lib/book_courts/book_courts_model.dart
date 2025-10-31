import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'book_courts_widget.dart';

class BookCourtsModel extends FlutterFlowModel<BookCourtsWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for search widget.
  FocusNode? searchFocusNode;
  TextEditingController? searchController;
  String? Function(BuildContext, String?)? searchControllerValidator;

  // State field(s) for sport filter
  String? selectedSportType;
  String? sportTypeController;

  // State field(s) for location sorting
  String? locationSortType; // 'current' or 'entered'
  String? enteredLocation;

  @override
  void initState(BuildContext context) {
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
    selectedSportType = 'All';
    locationSortType = 'current';
  }

  @override
  void dispose() {
    searchFocusNode?.dispose();
    searchController?.dispose();
  }
}

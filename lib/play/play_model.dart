import '/components/navbarnew_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'play_widget.dart' show PlayWidget;
import 'package:flutter/material.dart';

class PlayModel extends FlutterFlowModel<PlayWidget> {
  ///  Local state fields for this page.

  String? url;

  bool webviewGoBack = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Model for navbarnew component.
  late NavbarnewModel navbarnewModel;

  @override
  void initState(BuildContext context) {
    navbarnewModel = createModel(context, () => NavbarnewModel());
  }

  @override
  void dispose() {
    navbarnewModel.dispose();
  }
}

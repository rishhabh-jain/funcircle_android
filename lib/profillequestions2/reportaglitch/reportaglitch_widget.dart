import '/auth/firebase_auth/auth_util.dart';
import '/backend/firebase_storage/storage.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'package:flutter/material.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'reportaglitch_model.dart';
export 'reportaglitch_model.dart';

class ReportaglitchWidget extends StatefulWidget {
  const ReportaglitchWidget({
    super.key,
    this.uid,
    this.biotext,
  });

  final String? uid;
  final String? biotext;

  static String routeName = 'reportaglitch';
  static String routePath = '/reportaglitch';

  @override
  State<ReportaglitchWidget> createState() => _ReportaglitchWidgetState();
}

class _ReportaglitchWidgetState extends State<ReportaglitchWidget> {
  late ReportaglitchModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReportaglitchModel());

    _model.glitchtextTextController ??=
        TextEditingController(text: widget.biotext);
    _model.glitchtextFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      height: 93.0,
                      decoration: BoxDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Icon(
                              FFIcons.khandshake,
                              color: Color(0xFFF902FF),
                              size: 32.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 12.0, 0.0, 0.0),
                            child: Text(
                              FFLocalizations.of(context).getText(
                                'c2wpjeoc' /* You are helpful */,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    fontSize: 30.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 15.0, 30.0, 0.0),
                  child: Text(
                    FFLocalizations.of(context).getText(
                      'ahjpipur' /* Report a glitch which you want... */,
                    ),
                    textAlign: TextAlign.start,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          color: Color(0xFF64748B),
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1.0, 0.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        logFirebaseEvent('Button_upload_media_to_firebase');
                        final selectedMedia = await selectMedia(
                          imageQuality: 30,
                          mediaSource: MediaSource.photoGallery,
                          multiImage: true,
                        );
                        if (selectedMedia != null &&
                            selectedMedia.every((m) =>
                                validateFileFormat(m.storagePath, context))) {
                          safeSetState(
                              () => _model.isDataUploading_glitchimages = true);
                          var selectedUploadedFiles = <FFUploadedFile>[];

                          var downloadUrls = <String>[];
                          try {
                            showUploadMessage(
                              context,
                              'Uploading file...',
                              showLoading: true,
                            );
                            selectedUploadedFiles = selectedMedia
                                .map((m) => FFUploadedFile(
                                      name: m.storagePath.split('/').last,
                                      bytes: m.bytes,
                                      height: m.dimensions?.height,
                                      width: m.dimensions?.width,
                                      blurHash: m.blurHash,
                                    ))
                                .toList();

                            downloadUrls = (await Future.wait(
                              selectedMedia.map(
                                (m) async =>
                                    await uploadData(m.storagePath, m.bytes),
                              ),
                            ))
                                .where((u) => u != null)
                                .map((u) => u!)
                                .toList();
                          } finally {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            _model.isDataUploading_glitchimages = false;
                          }
                          if (selectedUploadedFiles.length ==
                                  selectedMedia.length &&
                              downloadUrls.length == selectedMedia.length) {
                            safeSetState(() {
                              _model.uploadedLocalFiles_glitchimages =
                                  selectedUploadedFiles;
                              _model.uploadedFileUrls_glitchimages =
                                  downloadUrls;
                            });
                            showUploadMessage(context, 'Success!');
                          } else {
                            safeSetState(() {});
                            showUploadMessage(context, 'Failed to upload data');
                            return;
                          }
                        }
                      },
                      text: _model.uploadedFileUrls_glitchimages.isNotEmpty
                          ? 'Uploaded'
                          : 'Attach a Image',
                      icon: Icon(
                        Icons.attach_file,
                        size: 15.0,
                      ),
                      options: FFButtonOptions(
                        height: 37.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 0.0, 24.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        iconColor: valueOrDefault<Color>(
                          _model.uploadedFileUrls_glitchimages.isNotEmpty
                              ? FlutterFlowTheme.of(context).success
                              : FlutterFlowTheme.of(context).tertiary,
                          FlutterFlowTheme.of(context).tertiary,
                        ),
                        color: FlutterFlowTheme.of(context).secondary,
                        textStyle: FlutterFlowTheme.of(context)
                            .titleSmall
                            .override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).titleSmallFamily,
                              color: Colors.white,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .titleSmallIsCustom,
                            ),
                        elevation: 0.0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                Form(
                  key: _model.formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 0.0),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      child: TextFormField(
                        controller: _model.glitchtextTextController,
                        focusNode: _model.glitchtextFocusNode,
                        autofocus: true,
                        textInputAction: TextInputAction.send,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: false,
                          labelText: FFLocalizations.of(context).getText(
                            '8fx5rlir' /* Glitch details */,
                          ),
                          labelStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .labelMediumFamily,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .labelMediumIsCustom,
                              ),
                          alignLabelWithHint: true,
                          hintStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .labelMediumFamily,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .labelMediumIsCustom,
                              ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFD0D5DD),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                        textAlign: TextAlign.start,
                        maxLines: 5,
                        validator: _model.glitchtextTextControllerValidator
                            .asValidator(context),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 100.0, 0.0, 20.0),
                  child: Container(
                    width: 335.0,
                    height: 50.0,
                    decoration: BoxDecoration(),
                    child: Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(1.0, 0.0),
                            child: Container(
                              width: 52.0,
                              height: 52.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              child: FlutterFlowIconButton(
                                borderRadius: 20.0,
                                borderWidth: 1.0,
                                buttonSize: 40.0,
                                icon: Icon(
                                  FFIcons.karrowLeft,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 32.0,
                                ),
                                showLoadingIndicator: true,
                                onPressed: () async {
                                  logFirebaseEvent('IconButton_navigate_back');
                                  context.safePop();
                                },
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(1.0, 0.0),
                            child: Container(
                              width: 52.0,
                              height: 52.0,
                              decoration: BoxDecoration(
                                color: Color(0xFFFEE6FF),
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              child: FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 20.0,
                                borderWidth: 1.0,
                                buttonSize: 40.0,
                                fillColor: Color(0xFFFEE6FF),
                                icon: Icon(
                                  FFIcons.kcaretRight,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 32.0,
                                ),
                                showLoadingIndicator: true,
                                onPressed: () async {
                                  logFirebaseEvent('IconButton_validate_form');
                                  if (_model.formKey.currentState == null ||
                                      !_model.formKey.currentState!
                                          .validate()) {
                                    return;
                                  }
                                  logFirebaseEvent('IconButton_backend_call');
                                  await GlitchesTable().insert({
                                    'description':
                                        _model.glitchtextTextController.text,
                                    'images':
                                        _model.uploadedFileUrls_glitchimages,
                                    'user_id': currentUserUid,
                                  });
                                  logFirebaseEvent('IconButton_navigate_back');
                                  context.safePop();
                                  logFirebaseEvent('IconButton_alert_dialog');
                                  await showDialog(
                                    context: context,
                                    builder: (alertDialogContext) {
                                      return WebViewAware(
                                        child: AlertDialog(
                                          title: Text('Glitch submitted'),
                                          content: Text(
                                              'Thanks for making us better.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  alertDialogContext),
                                              child: Text('Ok'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

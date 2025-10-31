import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/upload_data.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'add_images_model.dart';
export 'add_images_model.dart';

class AddImagesWidget extends StatefulWidget {
  const AddImagesWidget({super.key});

  static String routeName = 'AddImages';
  static String routePath = '/addImages';

  @override
  State<AddImagesWidget> createState() => _AddImagesWidgetState();
}

class _AddImagesWidgetState extends State<AddImagesWidget> {
  late AddImagesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddImagesModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Stack(
            alignment: AlignmentDirectional(0.0, 1.0),
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (!FFAppConstants.onlysocial)
                      LinearPercentIndicator(
                        percent: 0.24,
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        lineHeight: 12.0,
                        animation: false,
                        animateFromLastPercent: true,
                        progressColor: FlutterFlowTheme.of(context).primary,
                        backgroundColor: Color(0xFFDADADA),
                        center: Text(
                          FFLocalizations.of(context).getText(
                            'ma6xi67i' /* 24% */,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontSize: 10.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    if (!FFAppConstants.onlysocial)
                      Container(
                        width: double.infinity,
                        height: 40.0,
                        decoration: BoxDecoration(),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              10.0, 0.0, 10.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Material(
                                color: Colors.transparent,
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                child: Container(
                                  height: 25.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFF5FB),
                                    borderRadius: BorderRadius.circular(40.0),
                                    border: Border.all(
                                      color: Color(0xFFFFA7DB),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10.0, 0.0, 10.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            '75ulwsjx' /* Add 2+ images for increased vi... */,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
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
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.9,
                        height: 380.0,
                        decoration: BoxDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 15.0, 0.0, 20.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: Text(
                                      FFLocalizations.of(context).getText(
                                        '2w0ip7q9' /* Add your best images */,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                            fontSize: 22.0,
                                            letterSpacing: 0.2,
                                            fontWeight: FontWeight.w500,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0x53FF5963),
                                      borderRadius: BorderRadius.circular(32.0),
                                      border: Border.all(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Align(
                                      alignment:
                                          AlignmentDirectional(-1.0, 0.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10.0, 5.0, 10.0, 5.0),
                                        child: Text(
                                          FFLocalizations.of(context).getText(
                                            'jqg74eun' /* 2  required */,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                fontSize: 13.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: GridView(
                                  padding: EdgeInsets.zero,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 30.0,
                                    childAspectRatio: 1.0,
                                  ),
                                  primary: false,
                                  scrollDirection: Axis.vertical,
                                  children: [
                                    FlutterFlowIconButton(
                                      borderColor: FlutterFlowTheme.of(context)
                                          .secondary,
                                      borderRadius: 20.0,
                                      borderWidth: 1.0,
                                      buttonSize: 40.0,
                                      icon: Icon(
                                        FFIcons.kplus,
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        size: 32.0,
                                      ),
                                      onPressed: () async {
                                        logFirebaseEvent(
                                            'IconButton_upload_media_to_firebase');
                                        final selectedMedia = await selectMedia(
                                          imageQuality: 60,
                                          mediaSource: MediaSource.photoGallery,
                                          multiImage: true,
                                        );
                                        if (selectedMedia != null &&
                                            selectedMedia.every((m) =>
                                                validateFileFormat(
                                                    m.storagePath, context))) {
                                          safeSetState(() => _model
                                                  .isDataUploading_firebaseImages =
                                              true);
                                          var selectedUploadedFiles =
                                              <FFUploadedFile>[];

                                          var downloadUrls = <String>[];
                                          try {
                                            showUploadMessage(
                                              context,
                                              'Uploading file...',
                                              showLoading: true,
                                            );
                                            selectedUploadedFiles =
                                                selectedMedia
                                                    .map((m) => FFUploadedFile(
                                                          name: m.storagePath
                                                              .split('/')
                                                              .last,
                                                          bytes: m.bytes,
                                                          height: m.dimensions
                                                              ?.height,
                                                          width: m.dimensions
                                                              ?.width,
                                                          blurHash: m.blurHash,
                                                        ))
                                                    .toList();

                                            downloadUrls = (await Future.wait(
                                              selectedMedia.map(
                                                (m) async => await uploadData(
                                                    m.storagePath, m.bytes),
                                              ),
                                            ))
                                                .where((u) => u != null)
                                                .map((u) => u!)
                                                .toList();
                                          } finally {
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                            _model.isDataUploading_firebaseImages =
                                                false;
                                          }
                                          if (selectedUploadedFiles.length ==
                                                  selectedMedia.length &&
                                              downloadUrls.length ==
                                                  selectedMedia.length) {
                                            safeSetState(() {
                                              _model.uploadedLocalFiles_firebaseImages =
                                                  selectedUploadedFiles;
                                              _model.uploadedFileUrls_firebaseImages =
                                                  downloadUrls;
                                            });
                                            showUploadMessage(
                                                context, 'Success!');
                                          } else {
                                            safeSetState(() {});
                                            showUploadMessage(context,
                                                'Failed to upload data');
                                            return;
                                          }
                                        }

                                        if (_model.imagesupdates.length > 0) {
                                          while (_model
                                                  .uploadedFileUrls_firebaseImages
                                                  .length >
                                              _model.addimagesindex!) {
                                            logFirebaseEvent(
                                                'IconButton_update_page_state');
                                            _model.addToImagesupdates(_model
                                                .uploadedFileUrls_firebaseImages
                                                .elementAtOrNull(
                                                    _model.addimagesindex!)!);
                                            _model.addimagesindex =
                                                _model.addimagesindex! + 1;
                                            safeSetState(() {});
                                          }
                                          logFirebaseEvent(
                                              'IconButton_update_page_state');
                                          _model.addimagesindex = 0;
                                          safeSetState(() {});
                                        } else {
                                          logFirebaseEvent(
                                              'IconButton_update_page_state');
                                          _model.imagesupdates = _model
                                              .uploadedFileUrls_firebaseImages
                                              .toList()
                                              .cast<String>();
                                          safeSetState(() {});
                                        }
                                      },
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(1.0, 0.0),
                                      child: Stack(
                                        children: [
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              logFirebaseEvent(
                                                  'Image_expand_image');
                                              await Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType.fade,
                                                  child:
                                                      FlutterFlowExpandedImageView(
                                                    image: Image.network(
                                                      valueOrDefault<String>(
                                                        _model.imagesupdates
                                                                    .length >
                                                                0
                                                            ? _model
                                                                .imagesupdates
                                                                .elementAtOrNull(
                                                                    0)
                                                            : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                        'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                      ),
                                                      fit: BoxFit.contain,
                                                    ),
                                                    allowRotation: false,
                                                    tag: valueOrDefault<String>(
                                                      _model.imagesupdates
                                                                  .length >
                                                              0
                                                          ? _model.imagesupdates
                                                              .elementAtOrNull(
                                                                  0)
                                                          : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                      'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                    ),
                                                    useHeroAnimation: true,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Hero(
                                              tag: valueOrDefault<String>(
                                                _model.imagesupdates.length > 0
                                                    ? _model.imagesupdates
                                                        .elementAtOrNull(0)
                                                    : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                              ),
                                              transitionOnUserGestures: true,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Image.network(
                                                  valueOrDefault<String>(
                                                    _model.imagesupdates
                                                                .length >
                                                            0
                                                        ? _model.imagesupdates
                                                            .elementAtOrNull(0)
                                                        : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                    'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                  ),
                                                  width: 300.0,
                                                  height: 200.0,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 1.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 6.0),
                                              child: Container(
                                                width: 70.0,
                                                height: 15.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondary,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      '6cljojzj' /* Main */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .tertiary,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Stack(
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            logFirebaseEvent(
                                                'Image_expand_image');
                                            await Navigator.push(
                                              context,
                                              PageTransition(
                                                type: PageTransitionType.fade,
                                                child:
                                                    FlutterFlowExpandedImageView(
                                                  image: Image.network(
                                                    valueOrDefault<String>(
                                                      _model.imagesupdates
                                                                  .length >
                                                              1
                                                          ? _model.imagesupdates
                                                              .elementAtOrNull(
                                                                  1)
                                                          : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                      'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                    ),
                                                    fit: BoxFit.contain,
                                                  ),
                                                  allowRotation: false,
                                                  tag: valueOrDefault<String>(
                                                    _model.imagesupdates
                                                                .length >
                                                            1
                                                        ? _model.imagesupdates
                                                            .elementAtOrNull(1)
                                                        : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                    'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                  ),
                                                  useHeroAnimation: true,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Hero(
                                            tag: valueOrDefault<String>(
                                              _model.imagesupdates.length > 1
                                                  ? _model.imagesupdates
                                                      .elementAtOrNull(1)
                                                  : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                              'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                            ),
                                            transitionOnUserGestures: true,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                valueOrDefault<String>(
                                                  _model.imagesupdates.length >
                                                          1
                                                      ? _model.imagesupdates
                                                          .elementAtOrNull(1)
                                                      : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                  'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                ),
                                                width: 300.0,
                                                height: 200.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(1.0, -1.0),
                                          child: FlutterFlowIconButton(
                                            borderColor: Colors.transparent,
                                            borderRadius: 20.0,
                                            borderWidth: 1.0,
                                            buttonSize: 35.0,
                                            icon: Icon(
                                              Icons.delete_outline,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                              size: 18.0,
                                            ),
                                            onPressed: () async {
                                              logFirebaseEvent(
                                                  'IconButton_update_page_state');
                                              _model
                                                  .removeAtIndexFromImagesupdates(
                                                      1);
                                              safeSetState(() {});
                                            },
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 1.0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 6.0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                logFirebaseEvent(
                                                    'Container_update_app_state');
                                                FFAppState().tempImagePath =
                                                    _model.imagesupdates
                                                        .elementAtOrNull(0)!;
                                                safeSetState(() {});
                                                logFirebaseEvent(
                                                    'Container_update_page_state');
                                                _model
                                                    .updateImagesupdatesAtIndex(
                                                  0,
                                                  (_) => _model.imagesupdates
                                                      .elementAtOrNull(1)!,
                                                );
                                                safeSetState(() {});
                                                logFirebaseEvent(
                                                    'Container_update_page_state');
                                                _model
                                                    .updateImagesupdatesAtIndex(
                                                  1,
                                                  (_) => FFAppState()
                                                      .tempImagePath,
                                                );
                                                safeSetState(() {});
                                              },
                                              child: Container(
                                                width: 90.0,
                                                height: 15.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .warning,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'srdhtu7z' /* Set as Main */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            logFirebaseEvent(
                                                'Image_expand_image');
                                            await Navigator.push(
                                              context,
                                              PageTransition(
                                                type: PageTransitionType.fade,
                                                child:
                                                    FlutterFlowExpandedImageView(
                                                  image: Image.network(
                                                    valueOrDefault<String>(
                                                      _model.imagesupdates
                                                                  .length >
                                                              2
                                                          ? _model.imagesupdates
                                                              .elementAtOrNull(
                                                                  2)
                                                          : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                      'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                    ),
                                                    fit: BoxFit.contain,
                                                  ),
                                                  allowRotation: false,
                                                  tag: valueOrDefault<String>(
                                                    _model.imagesupdates
                                                                .length >
                                                            2
                                                        ? _model.imagesupdates
                                                            .elementAtOrNull(2)
                                                        : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                    'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                  ),
                                                  useHeroAnimation: true,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Hero(
                                            tag: valueOrDefault<String>(
                                              _model.imagesupdates.length > 2
                                                  ? _model.imagesupdates
                                                      .elementAtOrNull(2)
                                                  : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                              'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                            ),
                                            transitionOnUserGestures: true,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                valueOrDefault<String>(
                                                  _model.imagesupdates.length >
                                                          2
                                                      ? _model.imagesupdates
                                                          .elementAtOrNull(2)
                                                      : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                  'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                ),
                                                width: 300.0,
                                                height: 200.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(1.0, -1.0),
                                          child: FlutterFlowIconButton(
                                            borderColor: Colors.transparent,
                                            borderRadius: 20.0,
                                            borderWidth: 1.0,
                                            buttonSize: 35.0,
                                            icon: Icon(
                                              Icons.delete_outline,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                              size: 18.0,
                                            ),
                                            onPressed: () async {
                                              logFirebaseEvent(
                                                  'IconButton_update_page_state');
                                              _model
                                                  .removeAtIndexFromImagesupdates(
                                                      2);
                                              safeSetState(() {});
                                            },
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 1.0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 6.0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                logFirebaseEvent(
                                                    'Container_update_app_state');
                                                FFAppState().tempImagePath =
                                                    _model.imagesupdates
                                                        .elementAtOrNull(0)!;
                                                safeSetState(() {});
                                                logFirebaseEvent(
                                                    'Container_update_page_state');
                                                _model
                                                    .updateImagesupdatesAtIndex(
                                                  0,
                                                  (_) => _model.imagesupdates
                                                      .elementAtOrNull(2)!,
                                                );
                                                safeSetState(() {});
                                                logFirebaseEvent(
                                                    'Container_update_page_state');
                                                _model
                                                    .updateImagesupdatesAtIndex(
                                                  2,
                                                  (_) => FFAppState()
                                                      .tempImagePath,
                                                );
                                                safeSetState(() {});
                                              },
                                              child: Container(
                                                width: 80.0,
                                                height: 15.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .warning,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'e4nnt2oz' /* Set as Main */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            logFirebaseEvent(
                                                'Image_expand_image');
                                            await Navigator.push(
                                              context,
                                              PageTransition(
                                                type: PageTransitionType.fade,
                                                child:
                                                    FlutterFlowExpandedImageView(
                                                  image: Image.network(
                                                    valueOrDefault<String>(
                                                      _model.imagesupdates
                                                                  .length >
                                                              3
                                                          ? _model.imagesupdates
                                                              .elementAtOrNull(
                                                                  3)
                                                          : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                      'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                    ),
                                                    fit: BoxFit.contain,
                                                  ),
                                                  allowRotation: false,
                                                  tag: valueOrDefault<String>(
                                                    _model.imagesupdates
                                                                .length >
                                                            3
                                                        ? _model.imagesupdates
                                                            .elementAtOrNull(3)
                                                        : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                    'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                  ),
                                                  useHeroAnimation: true,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Hero(
                                            tag: valueOrDefault<String>(
                                              _model.imagesupdates.length > 3
                                                  ? _model.imagesupdates
                                                      .elementAtOrNull(3)
                                                  : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                              'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                            ),
                                            transitionOnUserGestures: true,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                valueOrDefault<String>(
                                                  _model.imagesupdates.length >
                                                          3
                                                      ? _model.imagesupdates
                                                          .elementAtOrNull(3)
                                                      : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                  'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                ),
                                                width: 300.0,
                                                height: 200.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(1.0, -1.0),
                                          child: FlutterFlowIconButton(
                                            borderColor: Colors.transparent,
                                            borderRadius: 20.0,
                                            borderWidth: 1.0,
                                            buttonSize: 35.0,
                                            icon: Icon(
                                              Icons.delete_outline,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                              size: 18.0,
                                            ),
                                            onPressed: () async {
                                              logFirebaseEvent(
                                                  'IconButton_update_page_state');
                                              _model
                                                  .removeAtIndexFromImagesupdates(
                                                      3);
                                              safeSetState(() {});
                                            },
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 1.0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 6.0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                logFirebaseEvent(
                                                    'Container_update_app_state');
                                                FFAppState().tempImagePath =
                                                    _model.imagesupdates
                                                        .elementAtOrNull(0)!;
                                                safeSetState(() {});
                                                logFirebaseEvent(
                                                    'Container_update_page_state');
                                                _model
                                                    .updateImagesupdatesAtIndex(
                                                  0,
                                                  (_) => _model.imagesupdates
                                                      .elementAtOrNull(3)!,
                                                );
                                                safeSetState(() {});
                                                logFirebaseEvent(
                                                    'Container_update_page_state');
                                                _model
                                                    .updateImagesupdatesAtIndex(
                                                  3,
                                                  (_) => FFAppState()
                                                      .tempImagePath,
                                                );
                                                safeSetState(() {});
                                              },
                                              child: Container(
                                                width: 80.0,
                                                height: 15.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .warning,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'z2frd8y1' /* Set as Main */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            logFirebaseEvent(
                                                'Image_expand_image');
                                            await Navigator.push(
                                              context,
                                              PageTransition(
                                                type: PageTransitionType.fade,
                                                child:
                                                    FlutterFlowExpandedImageView(
                                                  image: Image.network(
                                                    valueOrDefault<String>(
                                                      _model.imagesupdates
                                                                  .length >
                                                              4
                                                          ? _model.imagesupdates
                                                              .elementAtOrNull(
                                                                  4)
                                                          : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                      'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                    ),
                                                    fit: BoxFit.contain,
                                                  ),
                                                  allowRotation: false,
                                                  tag: valueOrDefault<String>(
                                                    _model.imagesupdates
                                                                .length >
                                                            4
                                                        ? _model.imagesupdates
                                                            .elementAtOrNull(4)
                                                        : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                    'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                  ),
                                                  useHeroAnimation: true,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Hero(
                                            tag: valueOrDefault<String>(
                                              _model.imagesupdates.length > 4
                                                  ? _model.imagesupdates
                                                      .elementAtOrNull(4)
                                                  : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                              'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                            ),
                                            transitionOnUserGestures: true,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                valueOrDefault<String>(
                                                  _model.imagesupdates.length >
                                                          4
                                                      ? _model.imagesupdates
                                                          .elementAtOrNull(4)
                                                      : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                  'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                ),
                                                width: 300.0,
                                                height: 200.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(1.0, -1.0),
                                          child: FlutterFlowIconButton(
                                            borderColor: Colors.transparent,
                                            borderRadius: 20.0,
                                            borderWidth: 1.0,
                                            buttonSize: 35.0,
                                            icon: Icon(
                                              Icons.delete_outline,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                              size: 18.0,
                                            ),
                                            onPressed: () async {
                                              logFirebaseEvent(
                                                  'IconButton_update_page_state');
                                              _model
                                                  .removeAtIndexFromImagesupdates(
                                                      4);
                                              safeSetState(() {});
                                            },
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 1.0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 6.0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                logFirebaseEvent(
                                                    'Container_update_app_state');
                                                FFAppState().tempImagePath =
                                                    _model.imagesupdates
                                                        .elementAtOrNull(0)!;
                                                safeSetState(() {});
                                                logFirebaseEvent(
                                                    'Container_update_page_state');
                                                _model
                                                    .updateImagesupdatesAtIndex(
                                                  0,
                                                  (_) => _model.imagesupdates
                                                      .elementAtOrNull(4)!,
                                                );
                                                safeSetState(() {});
                                                logFirebaseEvent(
                                                    'Container_update_page_state');
                                                _model
                                                    .updateImagesupdatesAtIndex(
                                                  4,
                                                  (_) => FFAppState()
                                                      .tempImagePath,
                                                );
                                                safeSetState(() {});
                                              },
                                              child: Container(
                                                width: 80.0,
                                                height: 15.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .warning,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Text(
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                      'zahqfbsq' /* Set as Main */,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        height: 248.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                            color: Color(0xFFE7EAEE),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              15.0, 20.0, 0.0, 20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (!FFAppConstants.onlysocial)
                                Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      FFLocalizations.of(context).getText(
                                        'krv4kghn' /* For more results do this */,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                ),
                              Container(
                                width: 296.0,
                                height: 160.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 20.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.check_circle_outlined,
                                            color: Color(0xFFF902FF),
                                            size: 20.0,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    7.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              FFLocalizations.of(context)
                                                  .getText(
                                                '6ejfanek' /* Upload atleast 2 images */,
                                              ),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: Color(0xFF323A46),
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 20.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.check_circle_outlined,
                                            color: Color(0xFFF902FF),
                                            size: 20.0,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    7.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              FFLocalizations.of(context)
                                                  .getText(
                                                'yy2k3x8x' /* Smile please */,
                                              ),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: Color(0xFF323A46),
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 20.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.check_circle_outlined,
                                            color: Color(0xFFF902FF),
                                            size: 20.0,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    7.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              FFLocalizations.of(context)
                                                  .getText(
                                                'buejbo4j' /* No inappropriate content */,
                                              ),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: Color(0xFF323A46),
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 20.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.check_circle_outlined,
                                            color: Color(0xFFF902FF),
                                            size: 20.0,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    7.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              FFLocalizations.of(context)
                                                  .getText(
                                                'lplct64b' /* Real images of yourself */,
                                              ),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: Color(0xFF323A46),
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 20.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.check_circle_outlined,
                                            color: Color(0xFFF902FF),
                                            size: 20.0,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    7.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              FFLocalizations.of(context)
                                                  .getText(
                                                'yhtdyqqx' /* Well-lit, Bright photo */,
                                              ),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: Color(0xFF323A46),
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (!FFAppConstants.onlysocial)
                                      Container(
                                        width: double.infinity,
                                        height: 20.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Icon(
                                              Icons.check_circle_outlined,
                                              color: Color(0xFFF902FF),
                                              size: 20.0,
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(7.0, 0.0, 0.0, 0.0),
                                              child: Text(
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  '2e4s0o0p' /* Group photo */,
                                                ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumFamily,
                                                      color: Color(0xFF323A46),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumIsCustom,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
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
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  height: 50.0,
                  decoration: BoxDecoration(),
                  child: Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 32.0,
                              ),
                              showLoadingIndicator: true,
                              onPressed: () async {
                                if (_model.imagesupdates.length >= 2) {
                                  logFirebaseEvent('IconButton_backend_call');
                                  await UsersTable().update(
                                    data: {
                                      'images': _model.imagesupdates,
                                    },
                                    matchingRows: (rows) => rows.eqOrNull(
                                      'user_id',
                                      currentUserUid,
                                    ),
                                  );
                                  logFirebaseEvent('IconButton_backend_call');

                                  await currentUserReference!.update({
                                    ...mapToFirestore(
                                      {
                                        'photo_url': FieldValue.delete(),
                                      },
                                    ),
                                  });
                                  logFirebaseEvent('IconButton_backend_call');
                                  await UserprofilecompletionstatusTable()
                                      .update(
                                    data: {
                                      'images_completed': true,
                                      'current_step': 3,
                                    },
                                    matchingRows: (rows) => rows.eqOrNull(
                                      'user_id',
                                      currentUserUid,
                                    ),
                                  );
                                  if (FFAppConstants.onlysocial == true) {
                                    logFirebaseEvent('IconButton_backend_call');
                                    await UsersTable().update(
                                      data: {
                                        'openfordating': false,
                                      },
                                      matchingRows: (rows) => rows.eqOrNull(
                                        'user_id',
                                        currentUserUid,
                                      ),
                                    );
                                    logFirebaseEvent('IconButton_backend_call');
                                    await UserprofilecompletionstatusTable()
                                        .update(
                                      data: {
                                        'completionstatus': true,
                                      },
                                      matchingRows: (rows) => rows.eqOrNull(
                                        'user_id',
                                        currentUserUid,
                                      ),
                                    );
                                    logFirebaseEvent('IconButton_backend_call');

                                    await currentUserReference!
                                        .update(createUsersRecordData(
                                      completionstatus: true,
                                    ));
                                    logFirebaseEvent('IconButton_navigate_to');

                                    context.pushNamed(BioWidget.routeName);
                                  } else {
                                    logFirebaseEvent('IconButton_navigate_to');

                                    context.pushNamed(
                                        GroupordatingWidget.routeName);
                                  }
                                } else {
                                  logFirebaseEvent('IconButton_show_snack_bar');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Please add atleast 2  images',
                                        style: GoogleFonts.inter(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                        ),
                                      ),
                                      duration: Duration(milliseconds: 4000),
                                      backgroundColor:
                                          FlutterFlowTheme.of(context).tertiary,
                                    ),
                                  );
                                }

                                safeSetState(() {});
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
    );
  }
}

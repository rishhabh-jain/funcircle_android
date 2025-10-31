import '/backend/firebase_storage/storage.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_place_picker.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'editgroups_model.dart';
export 'editgroups_model.dart';

class EditgroupsWidget extends StatefulWidget {
  const EditgroupsWidget({
    super.key,
    required this.groupid,
  });

  final int? groupid;

  static String routeName = 'editgroups';
  static String routePath = '/editgroups';

  @override
  State<EditgroupsWidget> createState() => _EditgroupsWidgetState();
}

class _EditgroupsWidgetState extends State<EditgroupsWidget> {
  late EditgroupsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditgroupsModel());

    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textFieldFocusNode2 ??= FocusNode();

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

    return FutureBuilder<List<GroupsRow>>(
      future: GroupsTable().querySingleRow(
        queryFn: (q) => q.eqOrNull(
          'group_id',
          widget.groupid,
        ),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: SpinKitRing(
                  color: FlutterFlowTheme.of(context).primary,
                  size: 50.0,
                ),
              ),
            ),
          );
        }
        List<GroupsRow> editgroupsGroupsRowList = snapshot.data!;

        final editgroupsGroupsRow = editgroupsGroupsRowList.isNotEmpty
            ? editgroupsGroupsRowList.first
            : null;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: AppBar(
                backgroundColor:
                    FlutterFlowTheme.of(context).secondaryBackground,
                iconTheme: IconThemeData(
                    color: FlutterFlowTheme.of(context).secondary),
                automaticallyImplyLeading: true,
                leading: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    logFirebaseEvent('Icon_navigate_back');
                    context.safePop();
                  },
                  child: Icon(
                    FFIcons.karrowLeft,
                    color: FlutterFlowTheme.of(context).secondary,
                    size: 24.0,
                  ),
                ),
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 206.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            FFLocalizations.of(context).getText(
                              'urmbfqm8' /* Edit group */,
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  fontSize: 18.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [],
                centerTitle: true,
                toolbarHeight: MediaQuery.sizeOf(context).height * 1.0,
                elevation: 1.0,
              ),
            ),
            body: SafeArea(
              top: true,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 5.0, 0.0, 0.0),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 1.0,
                              height: 290.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).tertiary,
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12.0, 5.0, 12.0, 5.0),
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
                                        borderColor:
                                            FlutterFlowTheme.of(context)
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
                                          final selectedMedia =
                                              await selectMedia(
                                            imageQuality: 87,
                                            includeBlurHash: true,
                                            mediaSource:
                                                MediaSource.photoGallery,
                                            multiImage: true,
                                          );
                                          if (selectedMedia != null &&
                                              selectedMedia.every((m) =>
                                                  validateFileFormat(
                                                      m.storagePath,
                                                      context))) {
                                            safeSetState(() => _model
                                                    .isDataUploading_groupimages =
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
                                                      .map(
                                                          (m) => FFUploadedFile(
                                                                name: m
                                                                    .storagePath
                                                                    .split('/')
                                                                    .last,
                                                                bytes: m.bytes,
                                                                height: m
                                                                    .dimensions
                                                                    ?.height,
                                                                width: m
                                                                    .dimensions
                                                                    ?.width,
                                                                blurHash:
                                                                    m.blurHash,
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
                                              _model.isDataUploading_groupimages =
                                                  false;
                                            }
                                            if (selectedUploadedFiles.length ==
                                                    selectedMedia.length &&
                                                downloadUrls.length ==
                                                    selectedMedia.length) {
                                              safeSetState(() {
                                                _model.uploadedLocalFiles_groupimages =
                                                    selectedUploadedFiles;
                                                _model.uploadedFileUrls_groupimages =
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

                                          logFirebaseEvent(
                                              'IconButton_update_page_state');
                                          _model.imagesupdates = _model
                                              .uploadedFileUrls_groupimages
                                              .toList()
                                              .cast<String>();
                                          safeSetState(() {});
                                        },
                                      ),
                                      Align(
                                        alignment:
                                            AlignmentDirectional(1.0, 0.0),
                                        child: Stack(
                                          children: [
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                logFirebaseEvent(
                                                    'Image_expand_image');
                                                await Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    type:
                                                        PageTransitionType.fade,
                                                    child:
                                                        FlutterFlowExpandedImageView(
                                                      image: Image.network(
                                                        valueOrDefault<String>(
                                                          () {
                                                            if (_model
                                                                    .imagesupdates
                                                                    .length >
                                                                0) {
                                                              return _model
                                                                  .imagesupdates
                                                                  .elementAtOrNull(
                                                                      0);
                                                            } else if (editgroupsGroupsRow!
                                                                    .images
                                                                    .length >
                                                                0) {
                                                              return (editgroupsGroupsRow
                                                                  .images
                                                                  .elementAtOrNull(
                                                                      0));
                                                            } else {
                                                              return 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png';
                                                            }
                                                          }(),
                                                          'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                        ),
                                                        fit: BoxFit.contain,
                                                      ),
                                                      allowRotation: false,
                                                      tag: valueOrDefault<
                                                          String>(
                                                        () {
                                                          if (_model
                                                                  .imagesupdates
                                                                  .length >
                                                              0) {
                                                            return _model
                                                                .imagesupdates
                                                                .elementAtOrNull(
                                                                    0);
                                                          } else if (editgroupsGroupsRow!
                                                                  .images
                                                                  .length >
                                                              0) {
                                                            return (editgroupsGroupsRow
                                                                .images
                                                                .elementAtOrNull(
                                                                    0));
                                                          } else {
                                                            return 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png';
                                                          }
                                                        }(),
                                                        'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                      ),
                                                      useHeroAnimation: true,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Hero(
                                                tag: valueOrDefault<String>(
                                                  () {
                                                    if (_model.imagesupdates
                                                            .length >
                                                        0) {
                                                      return _model
                                                          .imagesupdates
                                                          .elementAtOrNull(0);
                                                    } else if (editgroupsGroupsRow!
                                                            .images.length >
                                                        0) {
                                                      return (editgroupsGroupsRow
                                                          .images
                                                          .elementAtOrNull(0));
                                                    } else {
                                                      return 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png';
                                                    }
                                                  }(),
                                                  'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                ),
                                                transitionOnUserGestures: true,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Image.network(
                                                    valueOrDefault<String>(
                                                      () {
                                                        if (_model.imagesupdates
                                                                .length >
                                                            0) {
                                                          return _model
                                                              .imagesupdates
                                                              .elementAtOrNull(
                                                                  0);
                                                        } else if (editgroupsGroupsRow!
                                                                .images.length >
                                                            0) {
                                                          return (editgroupsGroupsRow
                                                              .images
                                                              .elementAtOrNull(
                                                                  0));
                                                        } else {
                                                          return 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png';
                                                        }
                                                      }(),
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
                                              alignment: AlignmentDirectional(
                                                  0.0, 1.0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 6.0),
                                                child: Container(
                                                  width: 70.0,
                                                  height: 15.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'tr18uxm2' /* Primary */,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
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
                                                                !FlutterFlowTheme.of(
                                                                        context)
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
                                                        () {
                                                          if (_model
                                                                  .imagesupdates
                                                                  .length >
                                                              1) {
                                                            return _model
                                                                .imagesupdates
                                                                .elementAtOrNull(
                                                                    1);
                                                          } else if (editgroupsGroupsRow!
                                                                  .images
                                                                  .length >
                                                              1) {
                                                            return (editgroupsGroupsRow
                                                                .images
                                                                .elementAtOrNull(
                                                                    1));
                                                          } else {
                                                            return 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png';
                                                          }
                                                        }(),
                                                        'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                      ),
                                                      fit: BoxFit.contain,
                                                    ),
                                                    allowRotation: false,
                                                    tag: valueOrDefault<String>(
                                                      () {
                                                        if (_model.imagesupdates
                                                                .length >
                                                            1) {
                                                          return _model
                                                              .imagesupdates
                                                              .elementAtOrNull(
                                                                  1);
                                                        } else if (editgroupsGroupsRow!
                                                                .images.length >
                                                            1) {
                                                          return (editgroupsGroupsRow
                                                              .images
                                                              .elementAtOrNull(
                                                                  1));
                                                        } else {
                                                          return 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png';
                                                        }
                                                      }(),
                                                      'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                    ),
                                                    useHeroAnimation: true,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Hero(
                                              tag: valueOrDefault<String>(
                                                () {
                                                  if (_model.imagesupdates
                                                          .length >
                                                      1) {
                                                    return _model.imagesupdates
                                                        .elementAtOrNull(1);
                                                  } else if (editgroupsGroupsRow!
                                                          .images.length >
                                                      1) {
                                                    return (editgroupsGroupsRow
                                                        .images
                                                        .elementAtOrNull(1));
                                                  } else {
                                                    return 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png';
                                                  }
                                                }(),
                                                'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                              ),
                                              transitionOnUserGestures: true,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Image.network(
                                                  valueOrDefault<String>(
                                                    () {
                                                      if (_model.imagesupdates
                                                              .length >
                                                          1) {
                                                        return _model
                                                            .imagesupdates
                                                            .elementAtOrNull(1);
                                                      } else if (editgroupsGroupsRow!
                                                              .images.length >
                                                          1) {
                                                        return (editgroupsGroupsRow
                                                            .images
                                                            .elementAtOrNull(
                                                                1));
                                                      } else {
                                                        return 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png';
                                                      }
                                                    }(),
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
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 6.0),
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
                                                  width: 70.0,
                                                  height: 15.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .success,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'wjy0pdmr' /* Set as Primary */,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .tertiary,
                                                            fontSize: 8.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
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
                                                        () {
                                                          if (_model
                                                                  .imagesupdates
                                                                  .length >
                                                              2) {
                                                            return _model
                                                                .imagesupdates
                                                                .elementAtOrNull(
                                                                    2);
                                                          } else if (editgroupsGroupsRow!
                                                                  .images
                                                                  .length >
                                                              2) {
                                                            return (editgroupsGroupsRow
                                                                .images
                                                                .elementAtOrNull(
                                                                    2));
                                                          } else {
                                                            return 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png';
                                                          }
                                                        }(),
                                                        'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                      ),
                                                      fit: BoxFit.contain,
                                                    ),
                                                    allowRotation: false,
                                                    tag: valueOrDefault<String>(
                                                      () {
                                                        if (_model.imagesupdates
                                                                .length >
                                                            2) {
                                                          return _model
                                                              .imagesupdates
                                                              .elementAtOrNull(
                                                                  2);
                                                        } else if (editgroupsGroupsRow!
                                                                .images.length >
                                                            2) {
                                                          return (editgroupsGroupsRow
                                                              .images
                                                              .elementAtOrNull(
                                                                  2));
                                                        } else {
                                                          return 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png';
                                                        }
                                                      }(),
                                                      'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                    ),
                                                    useHeroAnimation: true,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Hero(
                                              tag: valueOrDefault<String>(
                                                () {
                                                  if (_model.imagesupdates
                                                          .length >
                                                      2) {
                                                    return _model.imagesupdates
                                                        .elementAtOrNull(2);
                                                  } else if (editgroupsGroupsRow!
                                                          .images.length >
                                                      2) {
                                                    return (editgroupsGroupsRow
                                                        .images
                                                        .elementAtOrNull(2));
                                                  } else {
                                                    return 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png';
                                                  }
                                                }(),
                                                'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                              ),
                                              transitionOnUserGestures: true,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Image.network(
                                                  valueOrDefault<String>(
                                                    () {
                                                      if (_model.imagesupdates
                                                              .length >
                                                          2) {
                                                        return _model
                                                            .imagesupdates
                                                            .elementAtOrNull(2);
                                                      } else if (editgroupsGroupsRow!
                                                              .images.length >
                                                          2) {
                                                        return (editgroupsGroupsRow
                                                            .images
                                                            .elementAtOrNull(
                                                                2));
                                                      } else {
                                                        return 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png';
                                                      }
                                                    }(),
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
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 6.0),
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
                                                  width: 70.0,
                                                  height: 15.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .success,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'o2e5ckh7' /* Set as Primary */,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .tertiary,
                                                            fontSize: 8.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
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
                                                        () {
                                                          if (_model
                                                                  .imagesupdates
                                                                  .length >
                                                              3) {
                                                            return _model
                                                                .imagesupdates
                                                                .elementAtOrNull(
                                                                    3);
                                                          } else if (editgroupsGroupsRow!
                                                                  .images
                                                                  .length >
                                                              3) {
                                                            return (editgroupsGroupsRow
                                                                .images
                                                                .elementAtOrNull(
                                                                    3));
                                                          } else {
                                                            return 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png';
                                                          }
                                                        }(),
                                                        'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                      ),
                                                      fit: BoxFit.contain,
                                                    ),
                                                    allowRotation: false,
                                                    tag: valueOrDefault<String>(
                                                      () {
                                                        if (_model.imagesupdates
                                                                .length >
                                                            3) {
                                                          return _model
                                                              .imagesupdates
                                                              .elementAtOrNull(
                                                                  3);
                                                        } else if (editgroupsGroupsRow!
                                                                .images.length >
                                                            3) {
                                                          return (editgroupsGroupsRow
                                                              .images
                                                              .elementAtOrNull(
                                                                  3));
                                                        } else {
                                                          return 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png';
                                                        }
                                                      }(),
                                                      'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                    ),
                                                    useHeroAnimation: true,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Hero(
                                              tag: valueOrDefault<String>(
                                                () {
                                                  if (_model.imagesupdates
                                                          .length >
                                                      3) {
                                                    return _model.imagesupdates
                                                        .elementAtOrNull(3);
                                                  } else if (editgroupsGroupsRow!
                                                          .images.length >
                                                      3) {
                                                    return (editgroupsGroupsRow
                                                        .images
                                                        .elementAtOrNull(3));
                                                  } else {
                                                    return 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png';
                                                  }
                                                }(),
                                                'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                              ),
                                              transitionOnUserGestures: true,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Image.network(
                                                  valueOrDefault<String>(
                                                    () {
                                                      if (_model.imagesupdates
                                                              .length >
                                                          3) {
                                                        return _model
                                                            .imagesupdates
                                                            .elementAtOrNull(3);
                                                      } else if (editgroupsGroupsRow!
                                                              .images.length >
                                                          3) {
                                                        return (editgroupsGroupsRow
                                                            .images
                                                            .elementAtOrNull(
                                                                3));
                                                      } else {
                                                        return 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png';
                                                      }
                                                    }(),
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
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 6.0),
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
                                                  width: 70.0,
                                                  height: 15.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .success,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'go1rvue0' /* Set as Primary */,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .tertiary,
                                                            fontSize: 8.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
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
                                                        () {
                                                          if (_model
                                                                  .imagesupdates
                                                                  .length >
                                                              4) {
                                                            return _model
                                                                .imagesupdates
                                                                .elementAtOrNull(
                                                                    4);
                                                          } else if (editgroupsGroupsRow!
                                                                  .images
                                                                  .length >
                                                              4) {
                                                            return (editgroupsGroupsRow
                                                                .images
                                                                .elementAtOrNull(
                                                                    4));
                                                          } else {
                                                            return 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png';
                                                          }
                                                        }(),
                                                        'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                      ),
                                                      fit: BoxFit.contain,
                                                    ),
                                                    allowRotation: false,
                                                    tag: valueOrDefault<String>(
                                                      () {
                                                        if (_model.imagesupdates
                                                                .length >
                                                            4) {
                                                          return _model
                                                              .imagesupdates
                                                              .elementAtOrNull(
                                                                  4);
                                                        } else if (editgroupsGroupsRow!
                                                                .images.length >
                                                            4) {
                                                          return (editgroupsGroupsRow
                                                              .images
                                                              .elementAtOrNull(
                                                                  4));
                                                        } else {
                                                          return 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png';
                                                        }
                                                      }(),
                                                      'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                    ),
                                                    useHeroAnimation: true,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Hero(
                                              tag: valueOrDefault<String>(
                                                () {
                                                  if (_model.imagesupdates
                                                          .length >
                                                      4) {
                                                    return _model.imagesupdates
                                                        .elementAtOrNull(4);
                                                  } else if (editgroupsGroupsRow!
                                                          .images.length >
                                                      4) {
                                                    return (editgroupsGroupsRow
                                                        .images
                                                        .elementAtOrNull(4));
                                                  } else {
                                                    return 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png';
                                                  }
                                                }(),
                                                'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                              ),
                                              transitionOnUserGestures: true,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Image.network(
                                                  valueOrDefault<String>(
                                                    () {
                                                      if (_model.imagesupdates
                                                              .length >
                                                          4) {
                                                        return _model
                                                            .imagesupdates
                                                            .elementAtOrNull(4);
                                                      } else if (editgroupsGroupsRow!
                                                              .images.length >
                                                          4) {
                                                        return (editgroupsGroupsRow
                                                            .images
                                                            .elementAtOrNull(
                                                                4));
                                                      } else {
                                                        return 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png';
                                                      }
                                                    }(),
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
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 6.0),
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
                                                  width: 70.0,
                                                  height: 15.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .success,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Text(
                                                      FFLocalizations.of(
                                                              context)
                                                          .getText(
                                                        'z2q6b330' /* Set as Primary */,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .tertiary,
                                                            fontSize: 8.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
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
                            ),
                          ),
                          if (_model.imagesupdates.length >= 02)
                            Align(
                              alignment: AlignmentDirectional(1.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 12.0, 12.0, 0.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    logFirebaseEvent('Button_backend_call');
                                    await GroupsTable().update(
                                      data: {
                                        'images': _model.imagesupdates,
                                        'profile_image':
                                            _model.imagesupdates.firstOrNull,
                                      },
                                      matchingRows: (rows) => rows.eqOrNull(
                                        'group_id',
                                        widget.groupid,
                                      ),
                                    );
                                    logFirebaseEvent(
                                        'Button_update_page_state');
                                    _model.rebuildpagestate = false;
                                    safeSetState(() {});
                                  },
                                  text: FFLocalizations.of(context).getText(
                                    '84h8dtgx' /* Save Images */,
                                  ),
                                  options: FFButtonOptions(
                                    height: 40.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24.0, 0.0, 24.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FlutterFlowTheme.of(context).primary,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmallFamily,
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .titleSmallIsCustom,
                                        ),
                                    elevation: 3.0,
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ),
                          Form(
                            key: _model.formKey,
                            autovalidateMode: AutovalidateMode.disabled,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 10.0, 0.0, 10.0),
                                  child: Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.9,
                                    decoration: BoxDecoration(),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.9,
                                          child: TextFormField(
                                            controller:
                                                _model.textController1 ??=
                                                    TextEditingController(
                                              text: editgroupsGroupsRow?.name,
                                            ),
                                            focusNode:
                                                _model.textFieldFocusNode1,
                                            autofocus: false,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText:
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                'r6xcygt2' /* Enter group name */,
                                              ),
                                              labelStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMediumFamily,
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .labelMediumIsCustom,
                                                  ),
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMediumFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMediumIsCustom,
                                                      ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xFFDADADA),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumIsCustom,
                                                ),
                                            validator: _model
                                                .textController1Validator
                                                .asValidator(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.sizeOf(context).width * 0.9,
                                  height: 45.0,
                                  decoration: BoxDecoration(),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FlutterFlowPlacePicker(
                                        iOSGoogleMapsApiKey:
                                            'AIzaSyDObdEGkY8kLUYdPypdFuxpk_s-ZSDsD5s',
                                        androidGoogleMapsApiKey:
                                            'AIzaSyDObdEGkY8kLUYdPypdFuxpk_s-ZSDsD5s',
                                        webGoogleMapsApiKey:
                                            'AIzaSyDObdEGkY8kLUYdPypdFuxpk_s-ZSDsD5s',
                                        onSelect: (place) async {
                                          safeSetState(() =>
                                              _model.placePickerValue = place);
                                        },
                                        defaultText:
                                            FFLocalizations.of(context).getText(
                                          'ceiuxs3b' /* Select location */,
                                        ),
                                        icon: Icon(
                                          FFIcons.kmapPin,
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          size: 16.0,
                                        ),
                                        buttonOptions: FFButtonOptions(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.9,
                                          height: 40.0,
                                          color: FlutterFlowTheme.of(context)
                                              .tertiary,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmallFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .titleSmallIsCustom,
                                              ),
                                          borderSide: BorderSide(
                                            color: Color(0xFF5A5A5A),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 5.0, 0.0, 0.0),
                                  child: Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.9,
                                    decoration: BoxDecoration(),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.9,
                                          child: TextFormField(
                                            controller:
                                                _model.textController2 ??=
                                                    TextEditingController(
                                              text: editgroupsGroupsRow
                                                  ?.description,
                                            ),
                                            focusNode:
                                                _model.textFieldFocusNode2,
                                            autofocus: false,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText:
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                '0t5o7n08' /* Group Description */,
                                              ),
                                              labelStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMediumFamily,
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .labelMediumIsCustom,
                                                  ),
                                              alignLabelWithHint: true,
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMediumFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMediumIsCustom,
                                                      ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xFFDADADA),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumIsCustom,
                                                ),
                                            maxLines: 4,
                                            validator: _model
                                                .textController2Validator
                                                .asValidator(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 10.0, 0.0, 0.0),
                                  child: Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.9,
                                    height: 89.0,
                                    decoration: BoxDecoration(),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        FFButtonWidget(
                                          onPressed: () async {
                                            logFirebaseEvent(
                                                'Button_date_time_picker');
                                            final _datePicked1Date =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: getCurrentTimestamp,
                                              firstDate: getCurrentTimestamp,
                                              lastDate: DateTime(2050),
                                            );

                                            TimeOfDay? _datePicked1Time;
                                            if (_datePicked1Date != null) {
                                              _datePicked1Time =
                                                  await showTimePicker(
                                                context: context,
                                                initialTime:
                                                    TimeOfDay.fromDateTime(
                                                        getCurrentTimestamp),
                                              );
                                            }

                                            if (_datePicked1Date != null &&
                                                _datePicked1Time != null) {
                                              safeSetState(() {
                                                _model.datePicked1 = DateTime(
                                                  _datePicked1Date.year,
                                                  _datePicked1Date.month,
                                                  _datePicked1Date.day,
                                                  _datePicked1Time!.hour,
                                                  _datePicked1Time.minute,
                                                );
                                              });
                                            } else if (_model.datePicked1 !=
                                                null) {
                                              safeSetState(() {
                                                _model.datePicked1 =
                                                    getCurrentTimestamp;
                                              });
                                            }
                                          },
                                          text: valueOrDefault<String>(
                                            dateTimeFormat(
                                              "MMMMEEEEd",
                                              _model.datePicked1,
                                              locale:
                                                  FFLocalizations.of(context)
                                                      .languageCode,
                                            ),
                                            'Starting date and time',
                                          ),
                                          options: FFButtonOptions(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.9,
                                            height: 40.0,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    24.0, 0.0, 24.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallFamily,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      fontSize: 16.0,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallIsCustom,
                                                    ),
                                            elevation: 0.0,
                                            borderSide: BorderSide(
                                              color: Color(0xFFDADADA),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        FFButtonWidget(
                                          onPressed: () async {
                                            logFirebaseEvent(
                                                'Button_date_time_picker');
                                            final _datePicked2Date =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: getCurrentTimestamp,
                                              firstDate: getCurrentTimestamp,
                                              lastDate: DateTime(2050),
                                            );

                                            TimeOfDay? _datePicked2Time;
                                            if (_datePicked2Date != null) {
                                              _datePicked2Time =
                                                  await showTimePicker(
                                                context: context,
                                                initialTime:
                                                    TimeOfDay.fromDateTime(
                                                        getCurrentTimestamp),
                                              );
                                            }

                                            if (_datePicked2Date != null &&
                                                _datePicked2Time != null) {
                                              safeSetState(() {
                                                _model.datePicked2 = DateTime(
                                                  _datePicked2Date.year,
                                                  _datePicked2Date.month,
                                                  _datePicked2Date.day,
                                                  _datePicked2Time!.hour,
                                                  _datePicked2Time.minute,
                                                );
                                              });
                                            } else if (_model.datePicked2 !=
                                                null) {
                                              safeSetState(() {
                                                _model.datePicked2 =
                                                    getCurrentTimestamp;
                                              });
                                            }
                                          },
                                          text: valueOrDefault<String>(
                                            dateTimeFormat(
                                              "MMMMEEEEd",
                                              _model.datePicked2,
                                              locale:
                                                  FFLocalizations.of(context)
                                                      .languageCode,
                                            ),
                                            'Ending date and time',
                                          ),
                                          options: FFButtonOptions(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.9,
                                            height: 40.0,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    24.0, 0.0, 24.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallFamily,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      fontSize: 16.0,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallIsCustom,
                                                    ),
                                            elevation: 0.0,
                                            borderSide: BorderSide(
                                              color: Color(0xFFDADADA),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  20.0, 5.0, 0.0, 0.0),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  '2n0dl62p' /* Edit interests */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 10.0, 0.0, 70.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                logFirebaseEvent('Container_navigate_to');

                                context.pushNamed(
                                  InterestsWidget.routeName,
                                  queryParameters: {
                                    'groupid': serializeParam(
                                      widget.groupid,
                                      ParamType.int,
                                    ),
                                  }.withoutNulls,
                                  extra: <String, dynamic>{
                                    kTransitionInfoKey: TransitionInfo(
                                      hasTransition: true,
                                      transitionType:
                                          PageTransitionType.bottomToTop,
                                    ),
                                  },
                                );
                              },
                              child: Container(
                                width: MediaQuery.sizeOf(context).width * 0.9,
                                height: 150.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color: Color(0xFFD0D5DD),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: FlutterFlowChoiceChips(
                                    options: editgroupsGroupsRow!.interests
                                        .map((label) => ChipData(label))
                                        .toList(),
                                    onChanged: (val) => safeSetState(() =>
                                        _model.choiceChipsValue =
                                            val?.firstOrNull),
                                    selectedChipStyle: ChipStyle(
                                      backgroundColor: Color(0xFFFFE4F3),
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                      iconColor: Color(0xFFF902FF),
                                      iconSize: 18.0,
                                      elevation: 4.0,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    unselectedChipStyle: ChipStyle(
                                      backgroundColor: Color(0xFFFFE4F3),
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: Color(0xFFF902FF),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                      iconColor: Color(0xFFF902FF),
                                      iconSize: 18.0,
                                      elevation: 0.0,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    chipSpacing: 12.0,
                                    rowSpacing: 16.0,
                                    multiselect: false,
                                    alignment: WrapAlignment.start,
                                    controller:
                                        _model.choiceChipsValueController ??=
                                            FormFieldController<List<String>>(
                                      [],
                                    ),
                                    wrapped: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0.0, 1.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                      child: Container(
                        width: double.infinity,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              12.0, 0.0, 12.0, 0.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              logFirebaseEvent('Button_validate_form');
                              if (_model.formKey.currentState == null ||
                                  !_model.formKey.currentState!.validate()) {
                                return;
                              }
                              if (_model.placePickerValue == FFPlace()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Pick location',
                                      style: GoogleFonts.inter(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                      ),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).secondary,
                                  ),
                                );
                                return;
                              }
                              if (_model.datePicked1 == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Pick starting date',
                                      style: GoogleFonts.inter(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                      ),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).secondary,
                                  ),
                                );
                                return;
                              }
                              if (_model.datePicked2 == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Pick ending date',
                                      style: GoogleFonts.inter(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                      ),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).secondary,
                                  ),
                                );
                                return;
                              }
                              logFirebaseEvent('Button_backend_call');
                              _model.groupupdate = await GroupsTable().update(
                                data: {
                                  'name': _model.textController1.text,
                                  'location': _model.placePickerValue.address,
                                  'description': _model.textController2.text,
                                  'city': _model.placePickerValue.city,
                                  'startdatetime': supaSerialize<DateTime>(
                                      _model.datePicked1),
                                  'enddatetime': supaSerialize<DateTime>(
                                      _model.datePicked2),
                                },
                                matchingRows: (rows) => rows.eqOrNull(
                                  'group_id',
                                  widget.groupid,
                                ),
                                returnRows: true,
                              );
                              logFirebaseEvent('Button_navigate_back');
                              context.safePop();

                              safeSetState(() {});
                            },
                            text: FFLocalizations.of(context).getText(
                              '5pf7eord' /* Save */,
                            ),
                            options: FFButtonOptions(
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).secondary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .titleSmallFamily,
                                    color:
                                        FlutterFlowTheme.of(context).tertiary,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .titleSmallIsCustom,
                                  ),
                              elevation: 3.0,
                              borderSide: BorderSide(
                                width: 0.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

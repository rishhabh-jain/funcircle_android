import '/auth/firebase_auth/auth_util.dart';
import '/backend/firebase_storage/storage.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_place_picker.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'createvenue_model.dart';
export 'createvenue_model.dart';

class CreatevenueWidget extends StatefulWidget {
  const CreatevenueWidget({super.key});

  static String routeName = 'Createvenue';
  static String routePath = '/createvenue';

  @override
  State<CreatevenueWidget> createState() => _CreatevenueWidgetState();
}

class _CreatevenueWidgetState extends State<CreatevenueWidget> {
  late CreatevenueModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreatevenueModel());

    _model.venuenameTextController ??= TextEditingController();
    _model.venuenameFocusNode ??= FocusNode();

    _model.venuemapslinkTextController ??= TextEditingController();
    _model.venuemapslinkFocusNode ??= FocusNode();

    _model.venuedescriptionTextController ??= TextEditingController();
    _model.venuedescriptionFocusNode ??= FocusNode();

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
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).secondary),
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
                          'ymitfep5' /* Create venue */,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
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
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Container(
              height: MediaQuery.sizeOf(context).height * 1.0,
              child: Stack(
                alignment: AlignmentDirectional(0.0, -1.0),
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
                          if (currentUserUid == '')
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 10.0, 0.0, 0.0),
                              child: Container(
                                width: MediaQuery.sizeOf(context).width * 1.0,
                                height: 118.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFEE6FF),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        valueOrDefault<String>(
                                          _model.imagesupdates.length > 0
                                              ? _model.imagesupdates
                                                  .elementAtOrNull(0)
                                              : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                          'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                        ),
                                        width: double.infinity,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-0.8, 3.21),
                                      child: Container(
                                        width: 76.0,
                                        height: 80.0,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFDB1FF),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Stack(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.network(
                                                      valueOrDefault<String>(
                                                        _model.imagesupdates
                                                                    .length >
                                                                1
                                                            ? _model
                                                                .imagesupdates
                                                                .elementAtOrNull(
                                                                    1)
                                                            : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                        'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                      ),
                                                      width: 300.0,
                                                      height: 77.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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
                                        MediaQuery.sizeOf(context).width * 0.95,
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
                                                _model.venuenameTextController,
                                            focusNode:
                                                _model.venuenameFocusNode,
                                            autofocus: false,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText:
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                'n9mhhj4j' /* Enter venue name */,
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
                                                .venuenameTextControllerValidator
                                                .asValidator(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 10.0, 0.0, 10.0),
                                  child: Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.95,
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
                                            controller: _model
                                                .venuemapslinkTextController,
                                            focusNode:
                                                _model.venuemapslinkFocusNode,
                                            autofocus: false,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText:
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                'ov5r9gsw' /* Venue maps link */,
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
                                                .venuemapslinkTextControllerValidator
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
                                          'twnk42b1' /* Select Location */,
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
                                            controller: _model
                                                .venuedescriptionTextController,
                                            focusNode: _model
                                                .venuedescriptionFocusNode,
                                            autofocus: false,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText:
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                'ndu5t8u4' /* Venue Description */,
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
                                                .venuedescriptionTextControllerValidator
                                                .asValidator(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        20.0, 10.0, 0.0, 0.0),
                                    child: Text(
                                      FFLocalizations.of(context).getText(
                                        '8m317d54' /* Add Images */,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: Color(0xFF323A46),
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
                                      0.0, 12.0, 0.0, 0.0),
                                  child: Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 1.0,
                                    height: 287.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
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
                                                color:
                                                    FlutterFlowTheme.of(context)
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
                                                          .isDataUploading_venueImages =
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
                                                            .map((m) =>
                                                                FFUploadedFile(
                                                                  name: m
                                                                      .storagePath
                                                                      .split(
                                                                          '/')
                                                                      .last,
                                                                  bytes:
                                                                      m.bytes,
                                                                  height: m
                                                                      .dimensions
                                                                      ?.height,
                                                                  width: m
                                                                      .dimensions
                                                                      ?.width,
                                                                  blurHash: m
                                                                      .blurHash,
                                                                ))
                                                            .toList();

                                                    downloadUrls = (await Future
                                                            .wait(
                                                      selectedMedia.map(
                                                        (m) async =>
                                                            await uploadData(
                                                                m.storagePath,
                                                                m.bytes),
                                                      ),
                                                    ))
                                                        .where((u) => u != null)
                                                        .map((u) => u!)
                                                        .toList();
                                                  } finally {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .hideCurrentSnackBar();
                                                    _model.isDataUploading_venueImages =
                                                        false;
                                                  }
                                                  if (selectedUploadedFiles
                                                              .length ==
                                                          selectedMedia
                                                              .length &&
                                                      downloadUrls.length ==
                                                          selectedMedia
                                                              .length) {
                                                    safeSetState(() {
                                                      _model.uploadedLocalFiles_venueImages =
                                                          selectedUploadedFiles;
                                                      _model.uploadedFileUrls_venueImages =
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
                                                    .uploadedFileUrls_venueImages
                                                    .toList()
                                                    .cast<String>();
                                                safeSetState(() {});
                                              },
                                            ),
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  1.0, 0.0),
                                              child: Stack(
                                                children: [
                                                  InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      logFirebaseEvent(
                                                          'Image_expand_image');
                                                      await Navigator.push(
                                                        context,
                                                        PageTransition(
                                                          type:
                                                              PageTransitionType
                                                                  .fade,
                                                          child:
                                                              FlutterFlowExpandedImageView(
                                                            image:
                                                                Image.network(
                                                              valueOrDefault<
                                                                  String>(
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
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                            allowRotation:
                                                                false,
                                                            tag: valueOrDefault<
                                                                String>(
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
                                                            useHeroAnimation:
                                                                true,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Hero(
                                                      tag: valueOrDefault<
                                                          String>(
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
                                                      transitionOnUserGestures:
                                                          true,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: Image.network(
                                                          valueOrDefault<
                                                              String>(
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
                                                          width: 300.0,
                                                          height: 200.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 1.0),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0,
                                                                  6.0),
                                                      child: Container(
                                                        width: 70.0,
                                                        height: 15.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
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
                                                              'rqpsv3t6' /* Cover Pic */,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .tertiary,
                                                                  fontSize:
                                                                      12.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
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
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    logFirebaseEvent(
                                                        'Image_expand_image');
                                                    await Navigator.push(
                                                      context,
                                                      PageTransition(
                                                        type: PageTransitionType
                                                            .fade,
                                                        child:
                                                            FlutterFlowExpandedImageView(
                                                          image: Image.network(
                                                            valueOrDefault<
                                                                String>(
                                                              _model.imagesupdates
                                                                          .length >
                                                                      1
                                                                  ? _model
                                                                      .imagesupdates
                                                                      .elementAtOrNull(
                                                                          1)
                                                                  : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                              'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                            ),
                                                            fit: BoxFit.contain,
                                                          ),
                                                          allowRotation: false,
                                                          tag: valueOrDefault<
                                                              String>(
                                                            _model.imagesupdates
                                                                        .length >
                                                                    1
                                                                ? _model
                                                                    .imagesupdates
                                                                    .elementAtOrNull(
                                                                        1)
                                                                : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                            'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                          ),
                                                          useHeroAnimation:
                                                              true,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Hero(
                                                    tag: valueOrDefault<String>(
                                                      _model.imagesupdates
                                                                  .length >
                                                              1
                                                          ? _model.imagesupdates
                                                              .elementAtOrNull(
                                                                  1)
                                                          : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                      'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                    ),
                                                    transitionOnUserGestures:
                                                        true,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: Image.network(
                                                        valueOrDefault<String>(
                                                          _model.imagesupdates
                                                                      .length >
                                                                  1
                                                              ? _model
                                                                  .imagesupdates
                                                                  .elementAtOrNull(
                                                                      1)
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
                                                      AlignmentDirectional(
                                                          1.0, -1.0),
                                                  child: FlutterFlowIconButton(
                                                    borderColor:
                                                        Colors.transparent,
                                                    borderRadius: 20.0,
                                                    borderWidth: 1.0,
                                                    buttonSize: 35.0,
                                                    icon: Icon(
                                                      Icons.delete_outline,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
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
                                                      AlignmentDirectional(
                                                          0.0, 1.0),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 6.0),
                                                    child: InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        logFirebaseEvent(
                                                            'Container_update_app_state');
                                                        FFAppState()
                                                                .tempImagePath =
                                                            _model.imagesupdates
                                                                .elementAtOrNull(
                                                                    0)!;
                                                        safeSetState(() {});
                                                        logFirebaseEvent(
                                                            'Container_update_page_state');
                                                        _model
                                                            .updateImagesupdatesAtIndex(
                                                          0,
                                                          (_) => _model
                                                              .imagesupdates
                                                              .elementAtOrNull(
                                                                  1)!,
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
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .success,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
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
                                                              'cy955kol' /* Set as Primary */,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .tertiary,
                                                                  fontSize: 8.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
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
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    logFirebaseEvent(
                                                        'Image_expand_image');
                                                    await Navigator.push(
                                                      context,
                                                      PageTransition(
                                                        type: PageTransitionType
                                                            .fade,
                                                        child:
                                                            FlutterFlowExpandedImageView(
                                                          image: Image.network(
                                                            valueOrDefault<
                                                                String>(
                                                              _model.imagesupdates
                                                                          .length >
                                                                      2
                                                                  ? _model
                                                                      .imagesupdates
                                                                      .elementAtOrNull(
                                                                          2)
                                                                  : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                              'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                            ),
                                                            fit: BoxFit.contain,
                                                          ),
                                                          allowRotation: false,
                                                          tag: valueOrDefault<
                                                              String>(
                                                            _model.imagesupdates
                                                                        .length >
                                                                    2
                                                                ? _model
                                                                    .imagesupdates
                                                                    .elementAtOrNull(
                                                                        2)
                                                                : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                            'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                          ),
                                                          useHeroAnimation:
                                                              true,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Hero(
                                                    tag: valueOrDefault<String>(
                                                      _model.imagesupdates
                                                                  .length >
                                                              2
                                                          ? _model.imagesupdates
                                                              .elementAtOrNull(
                                                                  2)
                                                          : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                      'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                    ),
                                                    transitionOnUserGestures:
                                                        true,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: Image.network(
                                                        valueOrDefault<String>(
                                                          _model.imagesupdates
                                                                      .length >
                                                                  2
                                                              ? _model
                                                                  .imagesupdates
                                                                  .elementAtOrNull(
                                                                      2)
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
                                                      AlignmentDirectional(
                                                          1.0, -1.0),
                                                  child: FlutterFlowIconButton(
                                                    borderColor:
                                                        Colors.transparent,
                                                    borderRadius: 20.0,
                                                    borderWidth: 1.0,
                                                    buttonSize: 35.0,
                                                    icon: Icon(
                                                      Icons.delete_outline,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
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
                                                      AlignmentDirectional(
                                                          0.0, 1.0),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 6.0),
                                                    child: InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        logFirebaseEvent(
                                                            'Container_update_app_state');
                                                        FFAppState()
                                                                .tempImagePath =
                                                            _model.imagesupdates
                                                                .elementAtOrNull(
                                                                    0)!;
                                                        safeSetState(() {});
                                                        logFirebaseEvent(
                                                            'Container_update_page_state');
                                                        _model
                                                            .updateImagesupdatesAtIndex(
                                                          0,
                                                          (_) => _model
                                                              .imagesupdates
                                                              .elementAtOrNull(
                                                                  2)!,
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
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .success,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
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
                                                              '6jlma3of' /* Set as Primary */,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .tertiary,
                                                                  fontSize: 8.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
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
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    logFirebaseEvent(
                                                        'Image_expand_image');
                                                    await Navigator.push(
                                                      context,
                                                      PageTransition(
                                                        type: PageTransitionType
                                                            .fade,
                                                        child:
                                                            FlutterFlowExpandedImageView(
                                                          image: Image.network(
                                                            valueOrDefault<
                                                                String>(
                                                              _model.imagesupdates
                                                                          .length >
                                                                      3
                                                                  ? _model
                                                                      .imagesupdates
                                                                      .elementAtOrNull(
                                                                          3)
                                                                  : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                              'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                            ),
                                                            fit: BoxFit.contain,
                                                          ),
                                                          allowRotation: false,
                                                          tag: valueOrDefault<
                                                              String>(
                                                            _model.imagesupdates
                                                                        .length >
                                                                    3
                                                                ? _model
                                                                    .imagesupdates
                                                                    .elementAtOrNull(
                                                                        3)
                                                                : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                            'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                          ),
                                                          useHeroAnimation:
                                                              true,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Hero(
                                                    tag: valueOrDefault<String>(
                                                      _model.imagesupdates
                                                                  .length >
                                                              3
                                                          ? _model.imagesupdates
                                                              .elementAtOrNull(
                                                                  3)
                                                          : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                      'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                    ),
                                                    transitionOnUserGestures:
                                                        true,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: Image.network(
                                                        valueOrDefault<String>(
                                                          _model.imagesupdates
                                                                      .length >
                                                                  3
                                                              ? _model
                                                                  .imagesupdates
                                                                  .elementAtOrNull(
                                                                      3)
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
                                                      AlignmentDirectional(
                                                          1.0, -1.0),
                                                  child: FlutterFlowIconButton(
                                                    borderColor:
                                                        Colors.transparent,
                                                    borderRadius: 20.0,
                                                    borderWidth: 1.0,
                                                    buttonSize: 35.0,
                                                    icon: Icon(
                                                      Icons.delete_outline,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
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
                                                      AlignmentDirectional(
                                                          0.0, 1.0),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 6.0),
                                                    child: InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        logFirebaseEvent(
                                                            'Container_update_app_state');
                                                        FFAppState()
                                                                .tempImagePath =
                                                            _model.imagesupdates
                                                                .elementAtOrNull(
                                                                    0)!;
                                                        safeSetState(() {});
                                                        logFirebaseEvent(
                                                            'Container_update_page_state');
                                                        _model
                                                            .updateImagesupdatesAtIndex(
                                                          0,
                                                          (_) => _model
                                                              .imagesupdates
                                                              .elementAtOrNull(
                                                                  3)!,
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
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .success,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
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
                                                              'ykqs4rdl' /* Set as Primary */,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .tertiary,
                                                                  fontSize: 8.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
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
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    logFirebaseEvent(
                                                        'Image_expand_image');
                                                    await Navigator.push(
                                                      context,
                                                      PageTransition(
                                                        type: PageTransitionType
                                                            .fade,
                                                        child:
                                                            FlutterFlowExpandedImageView(
                                                          image: Image.network(
                                                            valueOrDefault<
                                                                String>(
                                                              _model.imagesupdates
                                                                          .length >
                                                                      4
                                                                  ? _model
                                                                      .imagesupdates
                                                                      .elementAtOrNull(
                                                                          4)
                                                                  : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                              'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                            ),
                                                            fit: BoxFit.contain,
                                                          ),
                                                          allowRotation: false,
                                                          tag: valueOrDefault<
                                                              String>(
                                                            _model.imagesupdates
                                                                        .length >
                                                                    4
                                                                ? _model
                                                                    .imagesupdates
                                                                    .elementAtOrNull(
                                                                        4)
                                                                : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                            'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                          ),
                                                          useHeroAnimation:
                                                              true,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Hero(
                                                    tag: valueOrDefault<String>(
                                                      _model.imagesupdates
                                                                  .length >
                                                              4
                                                          ? _model.imagesupdates
                                                              .elementAtOrNull(
                                                                  4)
                                                          : 'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                      'https://vtpylvqmrjlbdjhaxczd.supabase.co/storage/v1/object/public/userImages/images1/Add%20a%20heading%20(10).png',
                                                    ),
                                                    transitionOnUserGestures:
                                                        true,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: Image.network(
                                                        valueOrDefault<String>(
                                                          _model.imagesupdates
                                                                      .length >
                                                                  4
                                                              ? _model
                                                                  .imagesupdates
                                                                  .elementAtOrNull(
                                                                      4)
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
                                                      AlignmentDirectional(
                                                          1.0, -1.0),
                                                  child: FlutterFlowIconButton(
                                                    borderColor:
                                                        Colors.transparent,
                                                    borderRadius: 20.0,
                                                    borderWidth: 1.0,
                                                    buttonSize: 35.0,
                                                    icon: Icon(
                                                      Icons.delete_outline,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
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
                                                      AlignmentDirectional(
                                                          0.0, 1.0),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 6.0),
                                                    child: InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        logFirebaseEvent(
                                                            'Container_update_app_state');
                                                        FFAppState()
                                                                .tempImagePath =
                                                            _model.imagesupdates
                                                                .elementAtOrNull(
                                                                    0)!;
                                                        safeSetState(() {});
                                                        logFirebaseEvent(
                                                            'Container_update_page_state');
                                                        _model
                                                            .updateImagesupdatesAtIndex(
                                                          0,
                                                          (_) => _model
                                                              .imagesupdates
                                                              .elementAtOrNull(
                                                                  4)!,
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
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .success,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
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
                                                              'keix3fl6' /* Set as Primary */,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .tertiary,
                                                                  fontSize: 8.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0.0, 1.0),
                    child: Container(
                      width: double.infinity,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.0, 1.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 6.0, 5.0, 6.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  if (_model.imagesupdates.length >= 2) {
                                    logFirebaseEvent('Button_validate_form');
                                    if (_model.formKey.currentState == null ||
                                        !_model.formKey.currentState!
                                            .validate()) {
                                      return;
                                    }
                                    if (_model.placePickerValue == FFPlace()) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Select Location',
                                            style: GoogleFonts.inter(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                            ),
                                          ),
                                          duration:
                                              Duration(milliseconds: 4000),
                                          backgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondary,
                                        ),
                                      );
                                      return;
                                    }
                                    logFirebaseEvent('Button_backend_call');
                                    _model.venueoutput =
                                        await VenuesTable().insert({
                                      'venue_name':
                                          _model.venuenameTextController.text,
                                      'images': _model.imagesupdates,
                                      'maps_link': _model
                                          .venuemapslinkTextController.text,
                                      'description': _model
                                          .venuedescriptionTextController.text,
                                      'location':
                                          _model.placePickerValue.address,
                                    });
                                    logFirebaseEvent('Button_show_snack_bar');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Venue created successfully',
                                          style: GoogleFonts.roboto(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                          ),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                        backgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .secondary,
                                      ),
                                    );
                                    logFirebaseEvent('Button_navigate_to');

                                    context.goNamed(
                                      MygroupsWidget.routeName,
                                      extra: <String, dynamic>{
                                        kTransitionInfoKey: TransitionInfo(
                                          hasTransition: true,
                                          transitionType:
                                              PageTransitionType.leftToRight,
                                        ),
                                      },
                                    );
                                  } else {
                                    logFirebaseEvent('Button_show_snack_bar');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Add atleast 2 images',
                                          style: GoogleFonts.inter(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                          ),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                        backgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .tertiary,
                                      ),
                                    );
                                  }

                                  safeSetState(() {});
                                },
                                text: FFLocalizations.of(context).getText(
                                  '78f4h725' /* Create Venue */,
                                ),
                                options: FFButtonOptions(
                                  width: MediaQuery.sizeOf(context).width * 0.4,
                                  height: 45.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).tertiary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .titleSmallFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .titleSmallIsCustom,
                                      ),
                                  borderSide: BorderSide(
                                    color: Color(0xFFDADADA),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(51.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

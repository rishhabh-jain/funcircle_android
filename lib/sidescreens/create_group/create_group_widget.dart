import '/auth/firebase_auth/auth_util.dart';
import '/backend/firebase_storage/storage.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
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
import 'create_group_model.dart';
export 'create_group_model.dart';

class CreateGroupWidget extends StatefulWidget {
  const CreateGroupWidget({super.key});

  static String routeName = 'CreateGroup';
  static String routePath = '/createGroup';

  @override
  State<CreateGroupWidget> createState() => _CreateGroupWidgetState();
}

class _CreateGroupWidgetState extends State<CreateGroupWidget> {
  late CreateGroupModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateGroupModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
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
                          '2kyuvel5' /* Create group */,
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
                                            controller: _model.textController1,
                                            focusNode:
                                                _model.textFieldFocusNode1,
                                            autofocus: false,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText:
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                '2h3yqbxn' /* Enter group name */,
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
                                          'skahpv4s' /* Select Location */,
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
                                            controller: _model.textController2,
                                            focusNode:
                                                _model.textFieldFocusNode2,
                                            autofocus: false,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText:
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                'oa24hwck' /* Group Description */,
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
                                    height: 55.0,
                                    decoration: BoxDecoration(),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        FlutterFlowDropDown<String>(
                                          controller: _model
                                                  .dropDownValueController1 ??=
                                              FormFieldController<String>(
                                            _model.dropDownValue1 ??=
                                                FFLocalizations.of(context)
                                                    .getText(
                                              '2rd2n6nf' /* Outdoor */,
                                            ),
                                          ),
                                          options: [
                                            FFLocalizations.of(context).getText(
                                              'u7ya344u' /* Party */,
                                            ),
                                            FFLocalizations.of(context).getText(
                                              'wm9jk4kt' /* Event */,
                                            ),
                                            FFLocalizations.of(context).getText(
                                              'vqu9mgit' /* Meetup */,
                                            ),
                                            FFLocalizations.of(context).getText(
                                              '6godapd0' /* Outdoor */,
                                            )
                                          ],
                                          onChanged: (val) => safeSetState(() =>
                                              _model.dropDownValue1 = val),
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.9,
                                          height: 48.0,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color: Color(0xFF191D23),
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                          hintText: FFLocalizations.of(context)
                                              .getText(
                                            'b542h5uo' /* Party */,
                                          ),
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 20.0,
                                          ),
                                          fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                          elevation: 2.0,
                                          borderColor: Color(0xFFDADADA),
                                          borderWidth: 1.0,
                                          borderRadius: 8.0,
                                          margin:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 4.0, 16.0, 4.0),
                                          hidesUnderline: true,
                                          isSearchable: false,
                                          isMultiSelect: false,
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
                                    height: 80.0,
                                    decoration: BoxDecoration(),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(-1.0, 0.0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 5.0, 0.0, 0.0),
                                            child: Text(
                                              FFLocalizations.of(context)
                                                  .getText(
                                                'scsbprjg' /* Select Category */,
                                              ),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        FutureBuilder<List<GroupcategoriesRow>>(
                                          future:
                                              GroupcategoriesTable().queryRows(
                                            queryFn: (q) => q,
                                          ),
                                          builder: (context, snapshot) {
                                            // Customize what your widget looks like when it's loading.
                                            if (!snapshot.hasData) {
                                              return Center(
                                                child: SizedBox(
                                                  width: 50.0,
                                                  height: 50.0,
                                                  child: SpinKitRing(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    size: 50.0,
                                                  ),
                                                ),
                                              );
                                            }
                                            List<GroupcategoriesRow>
                                                dropDownGroupcategoriesRowList =
                                                snapshot.data!;

                                            return FlutterFlowDropDown<String>(
                                              controller: _model
                                                      .dropDownValueController2 ??=
                                                  FormFieldController<String>(
                                                _model.dropDownValue2 ??=
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                  'dtbfkkoa' /* Music Events */,
                                                ),
                                              ),
                                              options: [
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'pl6jl33p' /* Cultural */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  '8ffeuq5z' /* Charity */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'pumu8hch' /* Education */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'zonp76ss' /* Workshops */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'g40kje0q' /* Music Events */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'qrpcflaz' /* Comedy Events */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'qsy3xlat' /* Visual Arts */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  '2b9o2fce' /* Religion and Sprituality */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'xkc001k7' /* Festival & Fair */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'nfih1fbg' /* Home Concerts */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'acynjx0b' /* Poetry Events */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'z63oabcn' /* Award Show  */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  '7cv8hy9h' /* Conference */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'miw03jou' /* New year 2024 */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'ho2t0m1i' /* Movie Screening  */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  '7jc49pqz' /* Sports */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  '7w5ehdwg' /* Explore */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'jge6gncf' /* Foodies */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'kz8sm21n' /* Buddies */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'ta5gw0vp' /* Books& Literature */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  '11gtjl8t' /* Art and Craft */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'i3bsujck' /* Gaming */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  '9bnrn7qo' /* Pets */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  '7vjcs5a8' /* Coding and Tech */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  '2fbrkaq6' /* Fitness */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'rojjqap5' /* Volunteering */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'zywsc51r' /* Hiking */,
                                                ),
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  '91txz3do' /* Trips */,
                                                )
                                              ],
                                              onChanged: (val) => safeSetState(
                                                  () => _model.dropDownValue2 =
                                                      val),
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.9,
                                              height: 48.0,
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: Color(0xFF191D23),
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                              hintText:
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                'anosmdaz' /* Fitness */,
                                              ),
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                size: 20.0,
                                              ),
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              elevation: 2.0,
                                              borderColor: Color(0xFFDADADA),
                                              borderWidth: 1.0,
                                              borderRadius: 8.0,
                                              margin: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 4.0, 16.0, 4.0),
                                              hidesUnderline: true,
                                              isSearchable: false,
                                              isMultiSelect: false,
                                            );
                                          },
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
                                Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        20.0, 10.0, 0.0, 0.0),
                                    child: Text(
                                      FFLocalizations.of(context).getText(
                                        '5zq1nol9' /* Add Images */,
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
                                                          .isDataUploading_firebaseImages3 =
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
                                                    _model.isDataUploading_firebaseImages3 =
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
                                                      _model.uploadedLocalFiles_firebaseImages3 =
                                                          selectedUploadedFiles;
                                                      _model.uploadedFileUrls_firebaseImages3 =
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
                                                    .uploadedFileUrls_firebaseImages3
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
                                                              'tissf6qo' /* Cover Pic */,
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
                                                              't4lgftab' /* Set as Primary */,
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
                                                              'cwfoghqc' /* Set as Primary */,
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
                                                              'xjlbeu5h' /* Set as Primary */,
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
                                                              'yrt1c1qy' /* Set as Primary */,
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
                                Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        20.0, 25.0, 0.0, 0.0),
                                    child: Text(
                                      FFLocalizations.of(context).getText(
                                        'npb3r8vy' /* Interests */,
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
                                Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 15.0, 12.0, 60.0),
                                    child: FutureBuilder<List<InterestsRow>>(
                                      future: InterestsTable().queryRows(
                                        queryFn: (q) => q,
                                      ),
                                      builder: (context, snapshot) {
                                        // Customize what your widget looks like when it's loading.
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: SizedBox(
                                              width: 50.0,
                                              height: 50.0,
                                              child: SpinKitRing(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                size: 50.0,
                                              ),
                                            ),
                                          );
                                        }
                                        List<InterestsRow>
                                            selfcareInterestsRowList =
                                            snapshot.data!;

                                        return FlutterFlowChoiceChips(
                                          options: selfcareInterestsRowList
                                              .map((e) => e.interestName)
                                              .withoutNulls
                                              .toList()
                                              .map((label) => ChipData(label))
                                              .toList(),
                                          onChanged: (val) async {
                                            safeSetState(() =>
                                                _model.selfcareValues = val);
                                            logFirebaseEvent(
                                                'selfcare_update_page_state');

                                            safeSetState(() {});
                                          },
                                          selectedChipStyle: ChipStyle(
                                            backgroundColor: Color(0xFFFEE6FF),
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumFamily,
                                                      color: Color(0xFFF902FF),
                                                      fontSize: 12.0,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumIsCustom,
                                                    ),
                                            iconColor: Color(0xFFF902FF),
                                            iconSize: 18.0,
                                            elevation: 0.0,
                                            borderColor: Color(0xFFF902FF),
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          unselectedChipStyle: ChipStyle(
                                            backgroundColor: Color(0x00F902FF),
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumFamily,
                                                      color: Color(0xFF323A46),
                                                      fontSize: 12.0,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumIsCustom,
                                                    ),
                                            iconColor: Color(0xFF323A46),
                                            iconSize: 18.0,
                                            elevation: 0.0,
                                            borderColor: Color(0xFFE7EAEE),
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          chipSpacing: 12.0,
                                          rowSpacing: 12.0,
                                          multiselect: true,
                                          initialized:
                                              _model.selfcareValues != null,
                                          alignment: WrapAlignment.start,
                                          controller: _model
                                                  .selfcareValueController ??=
                                              FormFieldController<List<String>>(
                                            [],
                                          ),
                                          wrapped: true,
                                        );
                                      },
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
                                  5.0, 6.0, 5.0, 6.0),
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
                                    if (_model.dropDownValue1 == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Choose group type',
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
                                    if (_model.dropDownValue2 == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Choose Category',
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
                                    if (_model.datePicked1 == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Pick starting date',
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
                                    if (_model.datePicked2 == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Pick ending date',
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
                                    _model.groupoutput2 =
                                        await GroupsTable().insert({
                                      'name': _model.textController1.text,
                                      'location':
                                          _model.placePickerValue.address,
                                      'description':
                                          _model.textController2.text,
                                      'group_type': _model.dropDownValue1,
                                      'profile_image': _model.imagesupdates
                                          .elementAtOrNull(0),
                                      'interests': _model.selfcareValues,
                                      'images': _model.imagesupdates,
                                      'exclusive': false,
                                      'top_events': false,
                                      'startdatetime': supaSerialize<DateTime>(
                                          _model.datePicked1),
                                      'enddatetime': supaSerialize<DateTime>(
                                          _model.datePicked2),
                                      'category': _model.dropDownValue2,
                                      'city': _model.placePickerValue.city,
                                      'event_status': 'published',
                                      'hidden': false,
                                      'iftickets': true,
                                      'userid': currentUserUid,
                                    });
                                    logFirebaseEvent('Button_navigate_to');

                                    context.goNamed(
                                      CreateticketsWidget.routeName,
                                      queryParameters: {
                                        'groupId': serializeParam(
                                          _model.groupoutput2?.groupId,
                                          ParamType.int,
                                        ),
                                        'groupName': serializeParam(
                                          _model.groupoutput2?.name,
                                          ParamType.String,
                                        ),
                                        'ifMyGroups': serializeParam(
                                          false,
                                          ParamType.bool,
                                        ),
                                      }.withoutNulls,
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
                                  'mjvmqbqp' /* Create Group Ticket */,
                                ),
                                options: FFButtonOptions(
                                  width: MediaQuery.sizeOf(context).width * 0.5,
                                  height: 45.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).success,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .titleSmallFamily,
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .titleSmallIsCustom,
                                      ),
                                  elevation: 3.0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(51.0),
                                ),
                              ),
                            ),
                          ),
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
                                    if (_model.dropDownValue1 == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Choose group type',
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
                                    if (_model.dropDownValue2 == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Choose Category',
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
                                    if (_model.datePicked1 == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Pick starting date',
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
                                    if (_model.datePicked2 == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Pick ending date',
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
                                    _model.groupoutput =
                                        await GroupsTable().insert({
                                      'name': _model.textController1.text,
                                      'location':
                                          _model.placePickerValue.address,
                                      'description':
                                          _model.textController2.text,
                                      'group_type': _model.dropDownValue1,
                                      'profile_image': _model.imagesupdates
                                          .elementAtOrNull(0),
                                      'interests': _model.selfcareValues,
                                      'images': _model.imagesupdates,
                                      'exclusive': false,
                                      'top_events': false,
                                      'startdatetime': supaSerialize<DateTime>(
                                          _model.datePicked1),
                                      'enddatetime': supaSerialize<DateTime>(
                                          _model.datePicked2),
                                      'category': _model.dropDownValue2,
                                      'city': _model.placePickerValue.city,
                                      'event_status': 'published',
                                      'hidden': false,
                                      'iftickets': false,
                                      'userid': currentUserUid,
                                    });
                                    logFirebaseEvent('Button_navigate_to');

                                    context.goNamed(
                                      MyProfileWidget.routeName,
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
                                  '4zwoid1l' /* Create Group */,
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

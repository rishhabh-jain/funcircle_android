import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_count_controller.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'paidticketsaver_model.dart';
export 'paidticketsaver_model.dart';

class PaidticketsaverWidget extends StatefulWidget {
  const PaidticketsaverWidget({
    super.key,
    required this.groupId,
    this.ticketId,
  });

  final int? groupId;
  final int? ticketId;

  @override
  State<PaidticketsaverWidget> createState() => _PaidticketsaverWidgetState();
}

class _PaidticketsaverWidgetState extends State<PaidticketsaverWidget> {
  late PaidticketsaverModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaidticketsaverModel());

    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textFieldFocusNode3 ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
      child: FutureBuilder<List<TicketsRow>>(
        future: TicketsTable().querySingleRow(
          queryFn: (q) => q.eqOrNull(
            'id',
            widget.ticketId,
          ),
        ),
        builder: (context, snapshot) {
          // Customize what your widget looks like when it's loading.
          if (!snapshot.hasData) {
            return Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: SpinKitRing(
                  color: FlutterFlowTheme.of(context).primary,
                  size: 50.0,
                ),
              ),
            );
          }
          List<TicketsRow> containerTicketsRowList = snapshot.data!;

          final containerTicketsRow = containerTicketsRowList.isNotEmpty
              ? containerTicketsRowList.first
              : null;

          return Container(
            width: double.infinity,
            height: 600.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _model.textController1 ??=
                              TextEditingController(
                            text: containerTicketsRow?.title,
                          ),
                          focusNode: _model.textFieldFocusNode1,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: FFLocalizations.of(context).getText(
                              'j41th9b2' /* Ticket name */,
                            ),
                            labelStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .labelMediumFamily,
                                  color: FlutterFlowTheme.of(context).secondary,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .labelMediumIsCustom,
                                ),
                            hintStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .labelMediumFamily,
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
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontSize: 18.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                          validator: _model.textController1Validator
                              .asValidator(context),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        height: 89.0,
                        decoration: BoxDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FFButtonWidget(
                              onPressed: () async {
                                logFirebaseEvent('Button_date_time_picker');
                                final _datePicked1Date = await showDatePicker(
                                  context: context,
                                  initialDate: getCurrentTimestamp,
                                  firstDate: getCurrentTimestamp,
                                  lastDate: DateTime(2050),
                                );

                                TimeOfDay? _datePicked1Time;
                                if (_datePicked1Date != null) {
                                  _datePicked1Time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(
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
                                } else if (_model.datePicked1 != null) {
                                  safeSetState(() {
                                    _model.datePicked1 = getCurrentTimestamp;
                                  });
                                }
                              },
                              text: valueOrDefault<String>(
                                dateTimeFormat(
                                  "MMMMEEEEd",
                                  _model.datePicked1,
                                  locale:
                                      FFLocalizations.of(context).languageCode,
                                ),
                                'Sale start date and time',
                              ),
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 40.0,
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
                                          .secondaryText,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .titleSmallIsCustom,
                                    ),
                                borderSide: BorderSide(
                                  color: Color(0xFFD0D5DD),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                logFirebaseEvent('Button_date_time_picker');
                                final _datePicked2Date = await showDatePicker(
                                  context: context,
                                  initialDate: getCurrentTimestamp,
                                  firstDate: getCurrentTimestamp,
                                  lastDate: DateTime(2050),
                                );

                                TimeOfDay? _datePicked2Time;
                                if (_datePicked2Date != null) {
                                  _datePicked2Time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(
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
                                } else if (_model.datePicked2 != null) {
                                  safeSetState(() {
                                    _model.datePicked2 = getCurrentTimestamp;
                                  });
                                }
                              },
                              text: valueOrDefault<String>(
                                dateTimeFormat(
                                  "MMMMEEEEd",
                                  _model.datePicked2,
                                  locale:
                                      FFLocalizations.of(context).languageCode,
                                ),
                                'Sale end date and time',
                              ),
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 40.0,
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
                                          .secondaryText,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .titleSmallIsCustom,
                                    ),
                                borderSide: BorderSide(
                                  color: Color(0xFFD0D5DD),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                      child: FlutterFlowDropDown<String>(
                        controller: _model.dropDownValueController1 ??=
                            FormFieldController<String>(
                          _model.dropDownValue1 ??=
                              FFLocalizations.of(context).getText(
                            'zqdhqt8q' /* Single ticket */,
                          ),
                        ),
                        options: [
                          FFLocalizations.of(context).getText(
                            'dmq18ja9' /* Single ticket */,
                          ),
                          FFLocalizations.of(context).getText(
                            'e6retl5d' /* Group ticket */,
                          )
                        ],
                        onChanged: (val) =>
                            safeSetState(() => _model.dropDownValue1 = val),
                        width: double.infinity,
                        height: 40.0,
                        textStyle: FlutterFlowTheme.of(context)
                            .bodyMedium
                            .override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                        hintText: FFLocalizations.of(context).getText(
                          'mr8ked03' /* Please select... */,
                        ),
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 24.0,
                        ),
                        fillColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                        elevation: 2.0,
                        borderColor: Color(0xFFDADADA),
                        borderWidth: 1.0,
                        borderRadius: 8.0,
                        margin: EdgeInsetsDirectional.fromSTEB(
                            16.0, 4.0, 16.0, 4.0),
                        hidesUnderline: true,
                        isOverButton: true,
                        isSearchable: false,
                        isMultiSelect: false,
                      ),
                    ),
                    if (_model.dropDownValue1 == 'Group ticket')
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                        child: FlutterFlowDropDown<String>(
                          controller: _model.dropDownValueController2 ??=
                              FormFieldController<String>(
                            _model.dropDownValue2 ??=
                                FFLocalizations.of(context).getText(
                              'cqwoyuxf' /* 2 */,
                            ),
                          ),
                          options: [
                            FFLocalizations.of(context).getText(
                              '0hiziuli' /* 2 */,
                            ),
                            FFLocalizations.of(context).getText(
                              'qlwh78ef' /* 3 */,
                            ),
                            FFLocalizations.of(context).getText(
                              'zupzsekn' /* 4 */,
                            ),
                            FFLocalizations.of(context).getText(
                              '1nfapxiv' /* 5 */,
                            ),
                            FFLocalizations.of(context).getText(
                              'zlm69hot' /* 6 */,
                            )
                          ],
                          onChanged: (val) =>
                              safeSetState(() => _model.dropDownValue2 = val),
                          width: double.infinity,
                          height: 40.0,
                          textStyle: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                          hintText: FFLocalizations.of(context).getText(
                            'v2y32iub' /* Ticket per group */,
                          ),
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 24.0,
                          ),
                          fillColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          elevation: 2.0,
                          borderColor: Color(0xFFDADADA),
                          borderWidth: 1.0,
                          borderRadius: 8.0,
                          margin: EdgeInsetsDirectional.fromSTEB(
                              16.0, 4.0, 16.0, 4.0),
                          hidesUnderline: true,
                          isOverButton: true,
                          isSearchable: false,
                          isMultiSelect: false,
                        ),
                      ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        height: 59.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              FFLocalizations.of(context).getText(
                                'l437ss8u' /* Capacity */,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                            Container(
                              width: 160.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(8.0),
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                  color: Color(0xFFDADADA),
                                  width: 1.0,
                                ),
                              ),
                              child: FlutterFlowCountController(
                                decrementIconBuilder: (enabled) => FaIcon(
                                  FontAwesomeIcons.minus,
                                  color: enabled
                                      ? FlutterFlowTheme.of(context)
                                          .secondaryText
                                      : FlutterFlowTheme.of(context).alternate,
                                  size: 20.0,
                                ),
                                incrementIconBuilder: (enabled) => FaIcon(
                                  FontAwesomeIcons.plus,
                                  color: enabled
                                      ? FlutterFlowTheme.of(context).primary
                                      : FlutterFlowTheme.of(context).alternate,
                                  size: 20.0,
                                ),
                                countBuilder: (count) => Text(
                                  count.toString(),
                                  style: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .titleLargeFamily,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .titleLargeIsCustom,
                                      ),
                                ),
                                count: _model.countControllerValue ??= 0,
                                updateCount: (count) => safeSetState(
                                    () => _model.countControllerValue = count),
                                stepSize: 1,
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
                        height: 60.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              FFLocalizations.of(context).getText(
                                'ctsy1qd3' /* Price */,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.7,
                              height: 100.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 0.0, 0.0, 0.0),
                                      child: TextFormField(
                                        controller: _model.textController2 ??=
                                            TextEditingController(
                                          text: containerTicketsRow?.price,
                                        ),
                                        focusNode: _model.textFieldFocusNode2,
                                        autofocus: false,
                                        textCapitalization:
                                            TextCapitalization.none,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: FFLocalizations.of(context)
                                              .getText(
                                            '7wcpufyz' /* ₹ */,
                                          ),
                                          labelStyle: FlutterFlowTheme.of(
                                                  context)
                                              .labelMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMediumFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .labelMediumIsCustom,
                                              ),
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
                                              .labelMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .labelMediumIsCustom,
                                              ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D5DD),
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              fontSize: 18.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                        keyboardType: TextInputType.number,
                                        validator: _model
                                            .textController2Validator
                                            .asValidator(context),
                                        inputFormatters: [
                                          if (!isAndroid && !isiOS)
                                            TextInputFormatter.withFunction(
                                                (oldValue, newValue) {
                                              return TextEditingValue(
                                                selection: newValue.selection,
                                                text: newValue.text
                                                    .toCapitalization(
                                                        TextCapitalization
                                                            .none),
                                              );
                                            }),
                                          FilteringTextInputFormatter.allow(
                                              RegExp('[0-9]'))
                                        ],
                                      ),
                                    ),
                                  ),
                                  Text(
                                    FFLocalizations.of(context).getText(
                                      'and07284' /* Price should be under ₹500 */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          fontSize: 12.0,
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                ],
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
                        child: TextFormField(
                          controller: _model.textController3 ??=
                              TextEditingController(
                            text: containerTicketsRow?.description,
                          ),
                          focusNode: _model.textFieldFocusNode3,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: FFLocalizations.of(context).getText(
                              'zqvmlxzy' /* Description / Additional info */,
                            ),
                            labelStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .labelMediumFamily,
                                  color: FlutterFlowTheme.of(context).secondary,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .labelMediumIsCustom,
                                ),
                            hintStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .labelMediumFamily,
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
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontSize: 18.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                          maxLines: 2,
                          validator: _model.textController3Validator
                              .asValidator(context),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          logFirebaseEvent('Button_backend_call');
                          await TicketsTable().insert({
                            'created_at':
                                supaSerialize<DateTime>(getCurrentTimestamp),
                            'group_id': widget.groupId,
                            'type': 'Paid',
                            'title': _model.textController1.text,
                            'description': _model.textController3.text,
                            'capacity': _model.countControllerValue,
                            'startdatetime':
                                supaSerialize<DateTime>(_model.datePicked1),
                            'enddatetime':
                                supaSerialize<DateTime>(_model.datePicked2),
                            'ticketstatus': 'live',
                            'price': _model.textController2.text,
                            'priceincludinggst': true,
                            'ticketpergroup': _model.dropDownValue2,
                          });
                          logFirebaseEvent('Button_close_dialog_drawer_etc');
                          Navigator.pop(context);
                        },
                        text: FFLocalizations.of(context).getText(
                          'w65095l0' /* Save */,
                        ),
                        options: FFButtonOptions(
                          width: double.infinity,
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
                                color: Colors.white,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
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
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          logFirebaseEvent('Button_close_dialog_drawer_etc');
                          Navigator.pop(context);
                        },
                        text: FFLocalizations.of(context).getText(
                          'stk18u8p' /* Close */,
                        ),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          textStyle: FlutterFlowTheme.of(context)
                              .titleSmall
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .titleSmallFamily,
                                color: FlutterFlowTheme.of(context).secondary,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .titleSmallIsCustom,
                              ),
                          elevation: 3.0,
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).tertiary,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

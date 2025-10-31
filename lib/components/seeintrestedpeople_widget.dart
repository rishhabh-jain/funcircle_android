import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'seeintrestedpeople_model.dart';
export 'seeintrestedpeople_model.dart';

class SeeintrestedpeopleWidget extends StatefulWidget {
  const SeeintrestedpeopleWidget({
    super.key,
    required this.requestid,
  });

  final int? requestid;

  @override
  State<SeeintrestedpeopleWidget> createState() =>
      _SeeintrestedpeopleWidgetState();
}

class _SeeintrestedpeopleWidgetState extends State<SeeintrestedpeopleWidget> {
  late SeeintrestedpeopleModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SeeintrestedpeopleModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
          child: Container(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height * 0.8,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: FutureBuilder<List<InterestedRequestsRow>>(
              future: InterestedRequestsTable().queryRows(
                queryFn: (q) => q.eqOrNull(
                  'request_id',
                  widget.requestid,
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
                List<InterestedRequestsRow> columnInterestedRequestsRowList =
                    snapshot.data!;

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: List.generate(
                        columnInterestedRequestsRowList.length, (columnIndex) {
                      final columnInterestedRequestsRow =
                          columnInterestedRequestsRowList[columnIndex];
                      return Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            10.0, 5.0, 10.0, 10.0),
                        child: FutureBuilder<List<UsersRow>>(
                          future: UsersTable().querySingleRow(
                            queryFn: (q) => q.eqOrNull(
                              'user_id',
                              columnInterestedRequestsRow.otherUserId,
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
                            List<UsersRow> containerUsersRowList =
                                snapshot.data!;

                            final containerUsersRow =
                                containerUsersRowList.isNotEmpty
                                    ? containerUsersRowList.first
                                    : null;

                            return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(22.0),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10.0, 10.0, 10.0, 10.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: 40.0,
                                                height: 40.0,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.network(
                                                  valueOrDefault<String>(
                                                    containerUsersRow
                                                        ?.images.firstOrNull,
                                                    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fHww',
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 0.0, 0.0),
                                                child: Text(
                                                  valueOrDefault<String>(
                                                    containerUsersRow
                                                        ?.firstName,
                                                    'Name',
                                                  ),
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            fontSize: 16.0,
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
                                        FFButtonWidget(
                                          onPressed: () async {
                                            logFirebaseEvent(
                                                'Button_navigate_to');

                                            context.pushNamed(
                                              OthersProfileWidget.routeName,
                                              pathParameters: {
                                                'uid': serializeParam(
                                                  containerUsersRow?.userId,
                                                  ParamType.String,
                                                ),
                                              }.withoutNulls,
                                            );
                                          },
                                          text: FFLocalizations.of(context)
                                              .getText(
                                            'dpn98hz8' /* View Profile */,
                                          ),
                                          options: FFButtonOptions(
                                            height: 26.0,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 0.0, 10.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: Color(0xFFDCDCDC),
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
                                                              .secondary,
                                                      fontSize: 12.0,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallIsCustom,
                                                    ),
                                            elevation: 0.0,
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(28.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
          child: FFButtonWidget(
            onPressed: () async {
              logFirebaseEvent('Button_close_dialog_drawer_etc');
              Navigator.pop(context);
            },
            text: FFLocalizations.of(context).getText(
              '2ak4uv1d' /* Close */,
            ),
            options: FFButtonOptions(
              height: 40.0,
              padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              color: FlutterFlowTheme.of(context).primaryBackground,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                    color: FlutterFlowTheme.of(context).secondary,
                    letterSpacing: 0.0,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).titleSmallIsCustom,
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
    );
  }
}

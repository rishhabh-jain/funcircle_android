import 'package:flutter/material.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../../../models/booking.dart';

class BookingDetailsSheet extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onCancel;
  final VoidCallback? onRate;

  const BookingDetailsSheet({
    super.key,
    required this.booking,
    this.onCancel,
    this.onRate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    'Booking Details',
                    style: FlutterFlowTheme.of(context).headlineSmall,
                  ),
                  const SizedBox(height: 24),

                  // Game Title
                  _buildDetailRow(
                    context,
                    'Game',
                    booking.gameTitle,
                    Icons.sports_tennis,
                  ),

                  // Venue
                  _buildDetailRow(
                    context,
                    'Venue',
                    booking.venueName,
                    Icons.location_on,
                  ),

                  // Location
                  _buildDetailRow(
                    context,
                    'Location',
                    booking.venueLocation,
                    Icons.place,
                  ),

                  // Date & Time
                  _buildDetailRow(
                    context,
                    'Date & Time',
                    booking.formattedDateTime,
                    Icons.calendar_today,
                  ),

                  // Duration
                  _buildDetailRow(
                    context,
                    'Duration',
                    booking.formattedTime,
                    Icons.access_time,
                  ),

                  // Sport Type
                  _buildDetailRow(
                    context,
                    'Sport',
                    booking.gameSport,
                    Icons.sports,
                  ),

                  // Status
                  _buildDetailRow(
                    context,
                    'Status',
                    booking.statusDisplay,
                    Icons.info_outline,
                  ),

                  // Tickets
                  _buildDetailRow(
                    context,
                    'Tickets',
                    '${booking.totalTickets} tickets',
                    Icons.confirmation_number,
                  ),

                  // Total Amount
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: FlutterFlowTheme.of(context).titleMedium,
                      ),
                      Text(
                        '₹${booking.totalAmount.toStringAsFixed(0)}',
                        style: FlutterFlowTheme.of(context).headlineSmall.override(
                              fontFamily: 'Outfit',
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                      ),
                    ],
                  ),

                  // Cancellation Info
                  if (booking.isCancelled && booking.cancellationReason != null) ...[
                    const Divider(height: 32),
                    Text(
                      'Cancellation Reason',
                      style: FlutterFlowTheme.of(context).titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      booking.cancellationReason!,
                      style: FlutterFlowTheme.of(context).bodyMedium,
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Action Buttons
                  if (booking.canCancel && onCancel != null)
                    SizedBox(
                      width: double.infinity,
                      child: FFButtonWidget(
                        onPressed: onCancel,
                        text: 'Cancel Booking',
                        options: FFButtonOptions(
                          height: 50,
                          padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                          iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: Colors.red,
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                              ),
                          elevation: 3,
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                  if (booking.canRate && onRate != null) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FFButtonWidget(
                        onPressed: onRate,
                        text: 'Rate Game',
                        options: FFButtonOptions(
                          height: 50,
                          padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                          iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                              ),
                          elevation: 3,
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: FlutterFlowTheme.of(context).bodySmall,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

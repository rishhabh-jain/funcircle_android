import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../models/booking.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onTap;

  const BookingCard({
    super.key,
    required this.booking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(20),
                splashColor: Colors.orange.withValues(alpha: 0.1),
                highlightColor: Colors.orange.withValues(alpha: 0.05),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              booking.gameTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildStatusChip(context),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Venue
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.orange.withValues(alpha: 0.8),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              booking.venueName,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Date and Time
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            booking.formattedDate,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              booking.formattedTime,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Footer Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Sport Type
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.orange.withValues(alpha: 0.2),
                                  Colors.orange.withValues(alpha: 0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.orange.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              booking.gameSport,
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          // Total Amount
                          Text(
                            '₹${booking.totalAmount.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color chipColor;
    switch (booking.bookingStatus.toLowerCase()) {
      case 'confirmed':
        chipColor = Colors.green;
        break;
      case 'pending':
        chipColor = Colors.orange;
        break;
      case 'cancelled':
        chipColor = Colors.red;
        break;
      case 'completed':
        chipColor = const Color(0xFF4A9EFF);
        break;
      default:
        chipColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: chipColor.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Text(
        booking.statusDisplay,
        style: TextStyle(
          color: chipColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

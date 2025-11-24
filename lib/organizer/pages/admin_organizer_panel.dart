import 'package:flutter/material.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/push_notifications/push_notifications_util.dart';
import '../models/game_organizer_model.dart';

/// Admin panel for managing organizer applications
class AdminOrganizerPanel extends StatefulWidget {
  const AdminOrganizerPanel({super.key});

  static const String routeName = 'adminOrganizerPanel';
  static const String routePath = '/adminOrganizerPanel';

  @override
  State<AdminOrganizerPanel> createState() => _AdminOrganizerPanelState();
}

class _AdminOrganizerPanelState extends State<AdminOrganizerPanel> {
  String selectedStatus = 'all';
  List<GameOrganizerModel> applications = [];
  bool isLoading = true;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    try {
      final response = await SupaFlow.client
          .from('users')
          .select('is_admin')
          .eq('user_id', currentUserUid)
          .maybeSingle();

      setState(() {
        isAdmin = response != null && response['is_admin'] == true;
      });

      if (isAdmin) {
        _loadApplications();
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error checking admin status: $e')),
        );
      }
    }
  }

  Future<void> _loadApplications() async {
    setState(() {
      isLoading = true;
    });

    try {
      // First, try to load without joins to see if basic query works
      dynamic query = SupaFlow.client
          .schema('playnow')
          .from('game_organizers')
          .select('*');

      if (selectedStatus != 'all') {
        query = query.eq('status', selectedStatus);
      }

      query = query.order('created_at', ascending: false);

      final response = await query;

      print('Admin panel: Loaded ${(response as List).length} applications');

      // Load user and venue data separately for each application
      final List<GameOrganizerModel> loadedApplications = [];

      for (final appJson in response) {
        try {
          // Load user data
          String? userName;
          String? userEmail;
          String? userProfilePicture;

          try {
            final userResponse = await SupaFlow.client
                .from('users')
                .select('first_name, email, images')
                .eq('user_id', appJson['user_id'])
                .maybeSingle();

            if (userResponse != null) {
              userName = userResponse['first_name'] as String?;
              userEmail = userResponse['email'] as String?;
              // Get first image from images array
              if (userResponse['images'] is List && (userResponse['images'] as List).isNotEmpty) {
                userProfilePicture = (userResponse['images'] as List).first as String?;
              }
            }
          } catch (e) {
            print('Error loading user data: $e');
          }

          // Load venue data
          String? venueName;
          try {
            final venueResponse = await SupaFlow.client
                .from('venues')
                .select('venue_name')
                .eq('id', appJson['venue_id'])
                .maybeSingle();

            if (venueResponse != null) {
              venueName = venueResponse['venue_name'] as String?;
            }
          } catch (e) {
            print('Error loading venue data: $e');
          }

          // Merge data
          final mergedJson = Map<String, dynamic>.from(appJson);
          if (userName != null || userEmail != null || userProfilePicture != null) {
            mergedJson['user'] = {
              'first_name': userName,
              'email': userEmail,
              'profile_picture': userProfilePicture,
            };
          }
          if (venueName != null) {
            mergedJson['venue'] = {'venue_name': venueName};
          }

          loadedApplications.add(GameOrganizerModel.fromJson(mergedJson));
        } catch (e) {
          print('Error parsing application: $e');
          print('Application JSON: $appJson');
        }
      }

      setState(() {
        applications = loadedApplications;
        isLoading = false;
      });
    } catch (e, stackTrace) {
      print('Error loading applications: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading applications: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _updateApplicationStatus({
    required String applicationId,
    required String userId,
    required String newStatus,
    String? reason,
  }) async {
    try {
      final updates = <String, dynamic>{
        'status': newStatus,
      };

      String notificationTitle = '';
      String notificationText = '';

      if (newStatus == 'approved') {
        updates['approved_date'] = DateTime.now().toIso8601String();
        updates['approved_by'] = currentUserUid;
        notificationTitle = '🎉 Organizer Application Approved!';
        notificationText = 'Congratulations! Your application to become a FunCircle organizer has been approved. You can now start posting games!';
      } else if (newStatus == 'rejected') {
        updates['rejection_date'] = DateTime.now().toIso8601String();
        updates['rejected_by'] = currentUserUid;
        if (reason != null) {
          updates['rejection_reason'] = reason;
        }
        notificationTitle = 'Organizer Application Update';
        notificationText = reason != null
            ? 'Your organizer application was not approved. Reason: $reason'
            : 'Your organizer application was not approved. Please contact support for more information.';
      } else if (newStatus == 'suspended') {
        updates['suspended_date'] = DateTime.now().toIso8601String();
        updates['suspended_by'] = currentUserUid;
        if (reason != null) {
          updates['suspended_reason'] = reason;
        }
        notificationTitle = '⚠️ Organizer Account Suspended';
        notificationText = reason != null
            ? 'Your organizer account has been suspended. Reason: $reason'
            : 'Your organizer account has been suspended. Please contact support for details.';
      }

      await SupaFlow.client
          .schema('playnow')
          .from('game_organizers')
          .update(updates)
          .eq('id', applicationId);

      // Update is_organizer status in users table
      bool isOrganizer = false;
      if (newStatus == 'approved') {
        isOrganizer = true;
      } else if (newStatus == 'rejected' || newStatus == 'suspended') {
        isOrganizer = false;
      }

      try {
        await SupaFlow.client
            .from('users')
            .update({'is_organizer': isOrganizer})
            .eq('user_id', userId);
        print('Updated is_organizer to $isOrganizer for user: $userId');
      } catch (e) {
        print('Error updating is_organizer status: $e');
      }

      // Send push notification
      if (notificationTitle.isNotEmpty && notificationText.isNotEmpty) {
        try {
          final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
          triggerPushNotification(
            notificationTitle: notificationTitle,
            notificationText: notificationText,
            userRefs: [userRef],
            initialPageName: 'ProfileMenuScreen',
            parameterData: {},
          );
          print('Push notification sent to user: $userId');
        } catch (e) {
          print('Error sending push notification: $e');
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Application ${newStatus}!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      _loadApplications();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating application: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showApproveDialog(GameOrganizerModel application) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Approve Application',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Approve ${application.userName}\'s application to become an organizer for ${application.sportType} at ${application.venueName}?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              Navigator.pop(context);
              _updateApplicationStatus(
                applicationId: application.id,
                userId: application.userId,
                newStatus: 'approved',
              );
            },
            child: const Text(
              'Approve',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(GameOrganizerModel application) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Reject Application',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Reject ${application.userName}\'s application?',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Reason (optional)',
                labelStyle: const TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
              _updateApplicationStatus(
                applicationId: application.id,
                userId: application.userId,
                newStatus: 'rejected',
                reason: reasonController.text.trim().isNotEmpty
                    ? reasonController.text.trim()
                    : null,
              );
            },
            child: const Text(
              'Reject',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuspendDialog(GameOrganizerModel application) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Suspend Organizer',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Suspend ${application.userName}\'s organizer account?',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            const Text(
              'This will prevent them from creating new games.',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Reason (optional)',
                labelStyle: const TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.orange),
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            onPressed: () {
              Navigator.pop(context);
              _updateApplicationStatus(
                applicationId: application.id,
                userId: application.userId,
                newStatus: 'suspended',
                reason: reasonController.text.trim().isNotEmpty
                    ? reasonController.text.trim()
                    : null,
              );
            },
            child: const Text(
              'Suspend',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showApplicationDetails(GameOrganizerModel application) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  if (application.userProfilePicture != null)
                    CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          NetworkImage(application.userProfilePicture!),
                    )
                  else
                    const CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.person, size: 30),
                    ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          application.userName ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          application.userEmail ?? '',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: application.getStatusColor().withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: application.getStatusColor(),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      application.getStatusText(),
                      style: TextStyle(
                        color: application.getStatusColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Application Details
              _buildDetailSection(
                'Sport & Venue',
                '${application.getSportEmoji()} ${application.sportType.toUpperCase()} at ${application.venueName ?? "Unknown Venue"}',
              ),

              _buildDetailSection(
                'Skill Level',
                'Level ${application.skillLevel}',
              ),

              _buildDetailSection(
                'Mobile Number',
                application.mobileNumber,
              ),

              _buildDetailSection(
                'Available Days',
                application.getFormattedDays(),
              ),

              _buildDetailSection(
                'Time Slots',
                application.availableTimeSlots
                    .map((slot) => slot.format())
                    .join(', '),
              ),

              if (application.bio != null && application.bio!.isNotEmpty)
                _buildDetailSection('Bio', application.bio!),

              if (application.experience != null &&
                  application.experience!.isNotEmpty)
                _buildDetailSection('Experience', application.experience!),

              _buildDetailSection(
                'Application Date',
                dateTimeFormat('d MMM y, h:mm a', application.applicationDate),
              ),

              if (application.approvedDate != null)
                _buildDetailSection(
                  'Approved Date',
                  dateTimeFormat('d MMM y, h:mm a', application.approvedDate!),
                ),

              if (application.rejectionReason != null)
                _buildDetailSection(
                  'Rejection Reason',
                  application.rejectionReason!,
                ),

              if (application.suspendedReason != null)
                _buildDetailSection(
                  'Suspension Reason',
                  application.suspendedReason!,
                ),

              const SizedBox(height: 24),

              // Action Buttons
              if (application.status == 'pending')
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showRejectDialog(application);
                        },
                        icon: const Icon(Icons.close, color: Colors.white),
                        label: const Text(
                          'Reject',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showApproveDialog(application);
                        },
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: const Text(
                          'Approve',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),

              // Suspend button for approved organizers
              if (application.status == 'approved')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _showSuspendDialog(application);
                    },
                    icon: const Icon(Icons.block, color: Colors.white),
                    label: const Text(
                      'Suspend Organizer',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.greenAccent.shade400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isAdmin && !isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'Access Denied',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock,
                size: 80,
                color: Colors.red.shade400,
              ),
              const SizedBox(height: 16),
              const Text(
                'Admin Access Required',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You do not have permission to access this page',
                style: TextStyle(color: Colors.white60),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Organizer Applications',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadApplications,
          ),
        ],
      ),
      body: Column(
        children: [
          // Status filter tabs
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', 'all'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Pending', 'pending'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Approved', 'approved'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Rejected', 'rejected'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Suspended', 'suspended'),
                ],
              ),
            ),
          ),

          // Applications list
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                    ),
                  )
                : applications.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox,
                              size: 64,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No applications found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadApplications,
                        color: Colors.greenAccent,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: applications.length,
                          itemBuilder: (context, index) {
                            final application = applications[index];
                            return _buildApplicationCard(application);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String status) {
    final isSelected = selectedStatus == status;
    return InkWell(
      onTap: () {
        setState(() {
          selectedStatus = status;
        });
        _loadApplications();
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    Colors.greenAccent.shade400,
                    Colors.greenAccent.shade700,
                  ],
                )
              : null,
          color: isSelected ? null : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildApplicationCard(GameOrganizerModel application) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: application.getStatusColor().withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showApplicationDetails(application),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (application.userProfilePicture != null)
                    CircleAvatar(
                      radius: 24,
                      backgroundImage:
                          NetworkImage(application.userProfilePicture!),
                    )
                  else
                    const CircleAvatar(
                      radius: 24,
                      child: Icon(Icons.person),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          application.userName ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          application.userEmail ?? '',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: application.getStatusColor().withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: application.getStatusColor(),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      application.getStatusText(),
                      style: TextStyle(
                        color: application.getStatusColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.sports_tennis,
                    size: 16,
                    color: Colors.greenAccent.shade400,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${application.sportType.toUpperCase()} • ${application.venueName ?? "Unknown"}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.greenAccent.shade400,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    application.getFormattedDays(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.greenAccent.shade400,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Level ${application.skillLevel}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Applied: ${dateTimeFormat('d MMM y', application.applicationDate)}',
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),
              if (application.status == 'pending') ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        onPressed: () => _showRejectDialog(application),
                        child: const Text(
                          'Reject',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        onPressed: () => _showApproveDialog(application),
                        child: const Text(
                          'Approve',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (application.status == 'approved') ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.orange),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onPressed: () => _showSuspendDialog(application),
                    icon: const Icon(Icons.block, color: Colors.orange, size: 18),
                    label: const Text(
                      'Suspend',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

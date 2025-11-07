import 'package:flutter/material.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/services/profile_completion_service.dart';
import '/profile_setup/basic_info_screen.dart';

/// Widget that guards against incomplete profiles
/// Checks if the user's profile is complete and redirects to setup if needed
class ProfileCompletionGuard extends StatefulWidget {
  const ProfileCompletionGuard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ProfileCompletionGuard> createState() => _ProfileCompletionGuardState();
}

class _ProfileCompletionGuardState extends State<ProfileCompletionGuard> {
  bool _isChecking = true;
  bool _needsCompletion = false;

  @override
  void initState() {
    super.initState();
    _checkProfileCompletion();
  }

  Future<void> _checkProfileCompletion() async {
    if (!loggedIn || currentUserUid.isEmpty) {
      // Not logged in, show child (will go to welcome screen)
      setState(() {
        _isChecking = false;
        _needsCompletion = false;
      });
      return;
    }

    try {
      final service = ProfileCompletionService(SupaFlow.client);
      final needsCompletion = await service.needsProfileCompletion(currentUserUid);

      if (mounted) {
        setState(() {
          _isChecking = false;
          _needsCompletion = needsCompletion;
        });
      }
    } catch (e) {
      print('Error checking profile completion: $e');
      // On error, assume completion is needed
      if (mounted) {
        setState(() {
          _isChecking = false;
          _needsCompletion = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      // Show loading while checking
      return Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF0B60)),
          ),
        ),
      );
    }

    if (_needsCompletion) {
      // Profile incomplete, show profile setup
      return BasicInfoScreen();
    }

    // Profile complete, show child widget
    return widget.child;
  }
}

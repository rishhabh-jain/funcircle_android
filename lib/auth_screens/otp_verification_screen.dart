import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:async';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/services/profile_completion_service.dart';
import '/profile_setup/basic_info_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  static String routeName = 'OtpVerification';
  static String routePath = '/otpVerification';

  final String phoneNumber;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  bool _canResend = false;
  int _resendTimer = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendTimer = 30;
    });

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  Future<void> _verifyOTP() async {
    final otp = _otpControllers.map((c) => c.text).join();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter complete OTP'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await authManager.verifySmsCode(
        context: context,
        smsCode: otp,
      );

      setState(() => _isLoading = false);

      if (user != null && mounted) {
        // First check if account has been deleted
        try {
          final userProfile = await SupaFlow.client
              .from('users')
              .select('deleted_at')
              .eq('user_id', user.uid!)
              .maybeSingle();

          if (userProfile != null && userProfile['deleted_at'] != null) {
            // Account has been deleted
            await authManager.signOut();

            if (context.mounted) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF1E1E1E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Row(
                    children: [
                      Icon(Icons.cancel, color: Colors.red, size: 28),
                      SizedBox(width: 12),
                      Text(
                        'Account Deleted',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  content: Text(
                    'This account has been deleted and cannot be accessed. Please contact support if you believe this is an error.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Go back to welcome screen
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(
                          color: FlutterFlowTheme.of(context).primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return;
          }
        } catch (e) {
          print('Error checking deleted status: $e');
        }

        // Check if profile needs completion
        final service = ProfileCompletionService(SupaFlow.client);
        final needsCompletion = await service.needsProfileCompletion(user.uid);

        if (needsCompletion) {
          // Navigate to profile setup
          context.goNamed(BasicInfoScreen.routeName);
        } else {
          // Navigate to home
          context.goNamed('HomeNew');
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid OTP. Please try again.'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

  Future<void> _resendOTP() async {
    if (!_canResend) return;

    setState(() => _isLoading = true);

    try {
      // Use a flag to track if onCodeSent was called
      bool codeSentCalled = false;

      await authManager.beginPhoneAuth(
        context: context,
        phoneNumber: widget.phoneNumber,
        onCodeSent: (context) {
          codeSentCalled = true;
          if (mounted) {
            setState(() => _isLoading = false);
          }
          _startResendTimer();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('OTP sent successfully'),
                backgroundColor: FlutterFlowTheme.of(context).success,
              ),
            );
          }
        },
      );

      // Fallback: Stop loading after a delay if onCodeSent wasn't called
      await Future.delayed(Duration(milliseconds: 500));
      if (mounted && !codeSentCalled) {
        setState(() => _isLoading = false);
        _startResendTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP sent successfully'),
            backgroundColor: FlutterFlowTheme.of(context).success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending OTP: ${e.toString()}'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondary,
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient blobs
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFF6C63FF).withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Main content
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    IconButton(
                      onPressed: () => context.safePop(),
                      icon: Icon(
                        Icons.arrow_back,
                        color: FlutterFlowTheme.of(context).tertiary,
                        size: 24,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                    SizedBox(height: 40),

                    // Title
                    Text(
                      'Enter verification\ncode',
                      style: FlutterFlowTheme.of(context).displayMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).displayMediumFamily,
                            color: FlutterFlowTheme.of(context).tertiary,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                            useGoogleFonts:
                                !FlutterFlowTheme.of(context).displayMediumIsCustom,
                          ),
                    ),
                    SizedBox(height: 12),

                    // Subtitle with phone number
                    RichText(
                      text: TextSpan(
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyLargeFamily,
                              color: FlutterFlowTheme.of(context)
                                  .tertiary
                                  .withOpacity(0.6),
                              fontSize: 16,
                              letterSpacing: 0.2,
                              useGoogleFonts:
                                  !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                            ),
                        children: [
                          TextSpan(text: 'We sent a code to '),
                          TextSpan(
                            text: widget.phoneNumber,
                            style: TextStyle(
                              color: Color(0xFF6C63FF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 60),

                    // OTP Input boxes in glassy container
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.1),
                                Colors.white.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Verification Code',
                                style: TextStyle(
                                  color: FlutterFlowTheme.of(context)
                                      .tertiary
                                      .withOpacity(0.7),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  6,
                                  (index) => _buildOTPBox(index),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),

                    // Resend OTP section
                    Center(
                      child: _canResend
                          ? TextButton(
                              onPressed: _isLoading ? null : _resendOTP,
                              child: Text(
                                'Resend OTP',
                                style: TextStyle(
                                  color: Color(0xFF6C63FF),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            )
                          : Text(
                              'Resend OTP in $_resendTimer seconds',
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context)
                                    .tertiary
                                    .withOpacity(0.5),
                                fontSize: 14,
                                letterSpacing: 0.2,
                              ),
                            ),
                    ),
                    SizedBox(height: 40),

                    // Verify button - Glassy theme style
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              colors: [
                                FlutterFlowTheme.of(context)
                                    .primary
                                    .withValues(alpha: 0.3),
                                FlutterFlowTheme.of(context)
                                    .primary
                                    .withValues(alpha: 0.2),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context)
                                  .primary
                                  .withValues(alpha: 0.4),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: FlutterFlowTheme.of(context)
                                    .primary
                                    .withValues(alpha: 0.2),
                                blurRadius: 20,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _isLoading ? null : _verifyOTP,
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: _isLoading
                                      ? SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                          ),
                                        )
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Verify & Continue',
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildOTPBox(int index) {
    return Container(
      width: 48,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _otpFocusNodes[index].hasFocus
              ? Color(0xFF6C63FF)
              : Colors.white.withOpacity(0.2),
          width: _otpFocusNodes[index].hasFocus ? 2 : 1,
        ),
      ),
      child: TextFormField(
        controller: _otpControllers[index],
        focusNode: _otpFocusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(
          color: FlutterFlowTheme.of(context).tertiary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {
          if (value.length == 1) {
            // Move to next box
            if (index < 5) {
              _otpFocusNodes[index + 1].requestFocus();
            } else {
              // Last box - trigger verification
              _otpFocusNodes[index].unfocus();
              _verifyOTP();
            }
          } else if (value.isEmpty && index > 0) {
            // Move to previous box on backspace
            _otpFocusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}

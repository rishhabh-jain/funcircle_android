import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/auth_screens/otp_verification_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  static String routeName = 'PhoneAuth';
  static String routePath = '/phoneAuth';

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  bool _isLoading = false;
  String _countryCode = '+91';

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final phoneNumber = _countryCode + _phoneController.text.trim();

    setState(() => _isLoading = true);

    try {
      // Use a flag to track if we've navigated
      bool hasNavigated = false;

      await authManager.beginPhoneAuth(
        context: context,
        phoneNumber: phoneNumber,
        onCodeSent: (verificationContext) {
          if (hasNavigated) return;
          hasNavigated = true;

          // Stop loading immediately when code is sent
          if (mounted) {
            setState(() => _isLoading = false);
          }

          // Navigate immediately
          if (mounted) {
            context.pushNamed(
              OtpVerificationScreen.routeName,
              queryParameters: {
                'phoneNumber': serializeParam(phoneNumber, ParamType.String),
              }.withoutNulls,
            );
          }
        },
      );

      // Also stop loading after the method completes
      // (in case onCodeSent wasn't called)
      await Future.delayed(Duration(milliseconds: 500));
      if (mounted && !hasNavigated) {
        setState(() => _isLoading = false);
        // Try to navigate anyway if we received the OTP
        context.pushNamed(
          OtpVerificationScreen.routeName,
          queryParameters: {
            'phoneNumber': serializeParam(phoneNumber, ParamType.String),
          }.withoutNulls,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
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
                      'Enter your\nphone number',
                      style:
                          FlutterFlowTheme.of(context).displayMedium.override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .displayMediumFamily,
                                color: FlutterFlowTheme.of(context).tertiary,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .displayMediumIsCustom,
                              ),
                    ),
                    SizedBox(height: 12),

                    Text(
                      'We\'ll send you a verification code',
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
                    ),
                    SizedBox(height: 60),

                    // Phone number input in glassy container
                    Form(
                      key: _formKey,
                      child: ClipRRect(
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
                                  'Phone Number',
                                  style: TextStyle(
                                    color: FlutterFlowTheme.of(context)
                                        .tertiary
                                        .withOpacity(0.7),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    // Country code dropdown
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _countryCode,
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                          ),
                                          dropdownColor: Color(0xFF1D1D1D),
                                          style: TextStyle(
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                              value: '+91',
                                              child: Text('+91'),
                                            ),
                                            DropdownMenuItem(
                                              value: '+1',
                                              child: Text('+1'),
                                            ),
                                            DropdownMenuItem(
                                              value: '+44',
                                              child: Text('+44'),
                                            ),
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _countryCode = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),

                                    // Phone number input
                                    Expanded(
                                      child: TextFormField(
                                        controller: _phoneController,
                                        focusNode: _phoneFocusNode,
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(10),
                                        ],
                                        style: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .tertiary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.0,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: '9999999999',
                                          hintStyle: TextStyle(
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary
                                                .withOpacity(0.3),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          filled: true,
                                          fillColor:
                                              Colors.white.withOpacity(0.1),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color:
                                                  Colors.white.withOpacity(0.2),
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color:
                                                  Colors.white.withOpacity(0.2),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: Color(0xFF6C63FF),
                                              width: 2,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 16,
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter phone number';
                                          }
                                          if (value.length < 10) {
                                            return 'Enter valid 10-digit number';
                                          }
                                          return null;
                                        },
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
                    SizedBox(height: 40),

                    // Send OTP button - Glassy theme style
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
                              onTap: _isLoading ? null : _sendOTP,
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
                                              'Send OTP',
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
                    SizedBox(height: 24),

                    // Info text
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'You will receive a 6-digit verification code',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodySmallFamily,
                                color: FlutterFlowTheme.of(context)
                                    .tertiary
                                    .withOpacity(0.5),
                                fontSize: 13,
                                letterSpacing: 0.2,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodySmallIsCustom,
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
}

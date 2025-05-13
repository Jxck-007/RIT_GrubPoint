import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _codeSent = false;
  bool _codeVerified = false;
  String _verificationCode = '';
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  bool _validateEmail(String email) {
    // Email must end with @*.ritchennai.edu.in
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.ritchennai\.edu\.in$');
    return emailRegExp.hasMatch(email);
  }

  void _sendCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));
      
      // For demo purposes, generate a random 6-digit code
      _verificationCode = (100000 + (DateTime.now().millisecondsSinceEpoch % 900000)).toString();
      
      setState(() {
        _isLoading = false;
        _codeSent = true;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification code sent to ${_emailController.text}'),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _verifyCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // Simulate verification delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Check if code matches
      final isValid = _codeController.text == _verificationCode;
      
      setState(() {
        _isLoading = false;
        _codeVerified = isValid;
      });
      
      if (mounted) {
        if (isValid) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Code verified! Enter new password')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid code. Please try again')),
          );
        }
      }
    }
  }

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // Simulate password reset
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset successful!')),
        );
        
        // Return to login page after successful reset
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/RITcanteenimage.png'),
            fit: BoxFit.cover,
            opacity: 0.8,
            onError: (exception, stackTrace) {
              debugPrint('Error loading background image: $exception');
            },
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.2,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          'Reset Password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.95),
                            letterSpacing: 1.2,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Email field
                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'College Email',
                            labelStyle: const TextStyle(color: Colors.white70),
                            hintText: 'example@ritchennai.edu.in',
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                            prefixIcon: const Icon(Icons.email_outlined, color: Colors.white70),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(color: Colors.white24, width: 1.2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(color: Colors.white, width: 1.5),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.10),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                            enabled: !_codeSent,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (_codeSent) return null;
                            if (value == null || value.isEmpty) {
                              return 'Please enter your college email';
                            }
                            if (!_validateEmail(value)) {
                              return 'Please enter a valid email (example@ritchennai.edu.in)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        if (!_codeSent)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _sendCode,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : const Text(
                                      'Send Verification Code',
                                      style: TextStyle(fontSize: 16),
                                    ),
                            ),
                          ),
                        
                        if (_codeSent) ...[
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _codeController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Verification Code',
                              labelStyle: const TextStyle(color: Colors.white70),
                              hintText: 'Enter 6-digit code',
                              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                              prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(color: Colors.white24, width: 1.2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(color: Colors.white, width: 1.5),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.10),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the verification code';
                              }
                              if (value.length != 6) {
                                return 'Please enter the complete 6-digit code';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _verifyCode,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : const Text(
                                      'Verify Code',
                                      style: TextStyle(fontSize: 16),
                                    ),
                            ),
                          ),
                          TextButton(
                            onPressed: _isLoading ? null : _sendCode,
                            child: const Text(
                              'Resend Code',
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                        
                        if (_codeVerified) ...[
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _newPasswordController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'New Password',
                              labelStyle: const TextStyle(color: Colors.white70),
                              prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureNewPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.white70,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureNewPassword = !_obscureNewPassword;
                                  });
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(color: Colors.white24, width: 1.2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(color: Colors.white, width: 1.5),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.10),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                            ),
                            obscureText: _obscureNewPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a new password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _confirmPasswordController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: const TextStyle(color: Colors.white70),
                              prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.white70,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(color: Colors.white24, width: 1.2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(color: Colors.white, width: 1.5),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.10),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                            ),
                            obscureText: _obscureConfirmPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _newPasswordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _resetPassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : const Text(
                                      'Reset Password',
                                      style: TextStyle(fontSize: 16),
                                    ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 
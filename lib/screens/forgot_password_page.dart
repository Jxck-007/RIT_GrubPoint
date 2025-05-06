import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/RITcanteenimage.png'),
            fit: BoxFit.cover,
            opacity: 0.15, // Very light background
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Center(
                    child: Image.asset(
                      'assets/LOGO.png',
                      height: 120,
                      width: 120,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  const Text(
                    'Reset Your Password',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  
                  // Email field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'College Email',
                      hintText: 'example@cse.ritchennai.edu.in',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      enabled: !_codeSent,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (_codeSent) return null;
                      if (value == null || value.isEmpty) {
                        return 'Please enter your college email';
                      }
                      if (!_validateEmail(value)) {
                        return 'Please enter a valid email (example@dept.ritchennai.edu.in)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  if (!_codeSent)
                    ElevatedButton(
                      onPressed: _isLoading ? null : _sendCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
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
                          : const Text('Send Verification Code'),
                    ),
                  
                  if (_codeSent && !_codeVerified) ...[
                    // Verification code field
                    TextFormField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        labelText: 'Verification Code',
                        hintText: 'Enter 6-digit code sent to your email',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
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
                    
                    ElevatedButton(
                      onPressed: _isLoading ? null : _verifyCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
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
                          : const Text('Verify Code'),
                    ),
                    
                    TextButton(
                      onPressed: _isLoading ? null : _sendCode,
                      child: const Text('Resend Code'),
                    ),
                  ],
                  
                  if (_codeVerified) ...[
                    // New password field
                    TextFormField(
                      controller: _newPasswordController,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                      ),
                      obscureText: true,
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
                    
                    // Confirm password field
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock_outline),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                      ),
                      obscureText: true,
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
                    
                    ElevatedButton(
                      onPressed: _isLoading ? null : _resetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
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
                          : const Text('Reset Password'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 
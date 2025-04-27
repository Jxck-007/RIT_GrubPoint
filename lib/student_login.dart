import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/main_navigation.dart';
import 'screens/forgot_password_page.dart';

class StudentLoginPage extends StatefulWidget {
  const StudentLoginPage({super.key});

  @override
  State<StudentLoginPage> createState() => _StudentLoginPageState();
}

class _StudentLoginPageState extends State<StudentLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _regNoController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // Simulate login delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Simple placeholder login - no actual authentication
      if (_validateEmail(_emailController.text) && 
          _passwordController.text == 'password' &&
          _regNoController.text.isNotEmpty) {
        // Navigate to main navigation on successful login
        if (mounted) {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => const MainNavigation())
          );
        }
      } else {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid login credentials. Please check all fields.'))
          );
        }
      }
      
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  bool _validateEmail(String email) {
    // Email must end with @*.ritchennai.edu.in
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.ritchennai\.edu\.in$');
    return emailRegExp.hasMatch(email);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _regNoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/RITcanteenimage.png'),
            fit: BoxFit.cover,
            opacity: 0.3, // Semi-transparent background
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // Logo
                    Image.asset(
                      'assets/LOGO.png',
                      width: 180,
                      height: 180,
                    ),
                    const SizedBox(height: 20),
                    // Registration Number field
                    TextFormField(
                      controller: _regNoController,
                      decoration: const InputDecoration(
                        labelText: 'Registration Number',
                        hintText: 'Enter your 13-digit number',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.badge),
                        filled: true,
                        fillColor: Colors.white70,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(13),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your registration number';
                        }
                        if (value.length != 13) {
                          return 'Registration number must be 13 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // College Email field
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'College Email',
                        hintText: 'example@cse.ritchennai.edu.in',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                        filled: true,
                        fillColor: Colors.white70,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your college email';
                        }
                        if (!_validateEmail(value)) {
                          return 'Please enter a valid RIT Chennai email (example@dept.ritchennai.edu.in)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                        filled: true,
                        fillColor: Colors.white70,
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    // Login button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Login', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Forgot password link
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: const Text('Forgot Password?'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


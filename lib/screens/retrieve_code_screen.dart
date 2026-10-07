import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'reset_password_screen.dart';
import 'forgot_password_screen.dart';

class RetrieveCodeScreen extends StatefulWidget {
  final String email;
  final String generatedCode;

  const RetrieveCodeScreen({super.key, required this.email, required this.generatedCode});

  @override
  _RetrieveCodeScreenState createState() => _RetrieveCodeScreenState();
}

class _RetrieveCodeScreenState extends State<RetrieveCodeScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  Future<void> _validateCode() async {
    if (_formKey.currentState!.validate()) {
      final code = _codeController.text.trim();
      setState(() => _isLoading = true);

      try {
        if (code != widget.generatedCode) {
          throw Exception('invalid-code');
        }

        // Simulate validation delay
        await Future.delayed(const Duration(seconds: 1));

        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          _customSnackBar("Code validé avec succès", Colors.green),
        );

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ResetPasswordScreen(email: widget.email)),
          );
        }
      } catch (e) {
        String message;
        if (e.toString().contains('invalid-code')) {
          message = "Code invalide.";
        } else {
          message = "Erreur inattendue. Veuillez réessayer.";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          _customSnackBar(message, Colors.red),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendCode() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
      );
    }
    setState(() => _isLoading = false);
  }

  SnackBar _customSnackBar(String message, Color color) {
    return SnackBar(
      content: Text(message),
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      elevation: 5,
      showCloseIcon: true,
      closeIconColor: Colors.white,
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.3;

    return Scaffold(
      backgroundColor: Colors.transparent, // Ensure no white background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade300, Colors.pink.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          bottom: true, // Explicitly handle bottom inset
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                            onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Image.asset('assets/images/puzzle_logo.png', height: 80),
                        const SizedBox(height: 24),
                        Text(
                          "Enter Verification Code",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Check your email for the 6-digit code",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: iconSize,
                          height: iconSize,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Image.asset('assets/images/icon_retrieve.png'),
                        ),
                        const SizedBox(height: 24),
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _codeController,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              hintText: "Enter 6-digit code",
                              hintStyle: const TextStyle(color: Colors.white60),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              counterText: '',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return "Veuillez entrer le code";
                              if (!RegExp(r'^\d{6}$').hasMatch(value)) return "Code invalide";
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: _isLoading ? null : _resendCode,
                          child: const Text("Resend Code", style: TextStyle(color: Colors.white70)),
                        ),
                        const SizedBox(height: 24),
                        _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : ElevatedButton(
                                onPressed: _validateCode,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.purple,
                                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 5,
                                ),
                                child: const Text(
                                  "Validate Code",
                                  style: TextStyle(fontSize: 18, color: Colors.purple, fontWeight: FontWeight.bold),
                                ),
                              ),
                        const Spacer(), // Pushes content to fill available space
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
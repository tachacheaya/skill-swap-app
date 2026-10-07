import 'package:flutter/material.dart';
import 'login_screen.dart';

class PageDeGarde extends StatefulWidget {
  const PageDeGarde({Key? key}) : super(key: key);

  @override
  _PageDeGardeState createState() => _PageDeGardeState();
}

class _PageDeGardeState extends State<PageDeGarde> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade300, Colors.pink.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          // 🧩 Logo
                          Image.asset(
                            'assets/images/puzzle_logo.png',
                            height: 100,
                          ),
                          const SizedBox(height: 32),
                          // ✨ Slogan
                          const Text(
                            'The missing piece to your growth!',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          // 📬 Image centrale
                          Image.asset(
                            'assets/images/page_de_garde.png',
                            height: 240,
                          ),
                          const SizedBox(height: 32),
                          // 📝 Texte explicatif
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Text(
                              'Your skills have value,\nSwap them with people from all over the world.',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 40),
                          // 🔁 Bouton "on SkillSwap !"
                          GestureDetector(
                            onTapDown: (_) {
                              _controller.reverse();
                              Future.delayed(const Duration(milliseconds: 100), () {
                                _controller.forward();
                              });
                            },
                            child: ScaleTransition(
                              scale: Tween<double>(begin: 1.0, end: 0.95).animate(
                                CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
                              ),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => LoginScreen()),
                                  );
                                },
                                icon: const Icon(Icons.arrow_forward, color: Colors.purple),
                                label: const Text(
                                  'on SkillSwap!',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.purple,
                                  elevation: 5,
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
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
      ),
    );
  }
}
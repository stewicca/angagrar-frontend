import 'package:flutter/material.dart';
import '../../../common/session_manager.dart';
import '../auth/welcome_page.dart';
import '../conversation/chat_page.dart';

class SplashPage extends StatefulWidget {
  static const String ROUTE_NAME = '/';

  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Minimal delay - hanya untuk smooth transition
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Check authentication status
    final token = await SessionManager.getToken();

    if (token == null || token.isEmpty) {
      // No auth - navigate to welcome page
      Navigator.pushReplacementNamed(context, WelcomePage.ROUTE_NAME);
      return;
    }

    // Has token - check conversation status
    final isConversationCompleted =
        await SessionManager.isConversationCompleted();

    if (isConversationCompleted) {
      // Conversation completed - go to dashboard
      Navigator.pushReplacementNamed(context, '/home_page');
    } else {
      // Conversation not completed - go to chat
      Navigator.pushReplacementNamed(context, ChatPage.ROUTE_NAME);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Robot logo
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(20),
              child: Image.asset('assets/robot.png', fit: BoxFit.contain),
            ),
            const SizedBox(height: 24),
            const Text(
              'Angagrar',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'yang Ngerti Gaya Hidup Lo',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 48),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

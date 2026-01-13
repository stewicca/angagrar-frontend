import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/guest_auth/guest_auth_bloc.dart';
import '../conversation/chat_page.dart';

class WelcomePage extends StatelessWidget {
  static const String ROUTE_NAME = '/welcome_page';

  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      body: BlocListener<GuestAuthBloc, GuestAuthState>(
        listener: (context, state) {
          if (state is GuestAuthSuccess) {
            Navigator.pushReplacementNamed(context, ChatPage.ROUTE_NAME);
          }

          if (state is GuestAuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Authentication failed: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Text(
                    'Angagrar yang Ngerti\nGaya Hidup Lo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 48),
                  Container(
                    width: 200,
                    height: 200,
                    child: const Image(image: AssetImage('assets/robot.png')),
                  ),
                  const SizedBox(height: 48),
                  const Text(
                    'Atur uang, tetep bisa healing.\nCobain sekarang!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),
                  BlocBuilder<GuestAuthBloc, GuestAuthState>(
                    builder: (context, state) {
                      final isLoading = state is GuestAuthLoading;

                      return InkWell(
                        onTap: isLoading
                            ? null
                            : () {
                                context.read<GuestAuthBloc>().add(
                                  const AuthenticateAsGuest(),
                                );
                              },
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          alignment: Alignment.center,
                          child: isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white54,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: double.infinity,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Explore as Guest',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF4A4A4A),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      );
                    },
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:driver_app/apiservice/OtpApiService.dart'; 
import 'package:driver_app/otpLogin/OtpVerificationScreen.dart'; 
import 'package:driver_app/home/HomeScreen.dart';
import 'package:driver_app/oAuth2login/GoogleAuthProvider.dart'; // Import Google Sign-In service

class PhoneEmailScreen extends ConsumerStatefulWidget {
  const PhoneEmailScreen({super.key});

  @override
  ConsumerState<PhoneEmailScreen> createState() => _PhoneEmailScreenState();
}

class _PhoneEmailScreenState extends ConsumerState<PhoneEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }


  Future<void> _handleSendCode() async {
    final String email = _emailController.text.trim();
    final String phone = _phoneController.text.trim();

    if (email.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in both fields.")),
      );
      return;
    }

    setState(() => _isLoading = true);
    bool isSent = await OtpApiService.sendOtp(email: email, phone: phone);
    setState(() => _isLoading = false);

    if (isSent) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(email: email, phone: phone),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to send verification code. Please try again.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    
    ref.listen<GoogleAuthState>(googleAuthProvider, (previous, next) {
      if (next is GoogleAuthSuccess) {
        if (next.isRegistered) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        } else {
          
          Navigator.pushNamedAndRemoveUntil(
            context, 
            '/signup', 
            (route) => false,
            arguments: {
              'email': next.email,
              'googleId': next.googleId,
              'firstName': next.firstName, // New field
              'lastName': next.lastName,   // New field
              'phone': null,
            },
          );
        }
      } else if (next is GoogleAuthFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    });
    
    final googleAuthState = ref.watch(googleAuthProvider);
    final bool isGoogleLoading = googleAuthState is GoogleAuthLoading;
    final bool isInteractionBlocked = _isLoading || isGoogleLoading;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Stack(
            children: [
              
              Container(
                width: double.infinity,
                height: screenHeight * 0.40,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E3C72),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: const SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(32.0, 40.0, 32.0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Driver Portal",
                          style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Verify your details to get started",
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Email Address",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          enabled: !isInteractionBlocked,
                          decoration: InputDecoration(
                            hintText: "driver@example.com",
                            fillColor: Colors.grey[100],
                            filled: true,
                            prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.black, width: 1.2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF1E3C72), width: 2),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),

                        const Text(
                          "Phone Number",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          enabled: !isInteractionBlocked,
                          decoration: InputDecoration(
                            hintText: "+91 23456 78900",
                            fillColor: Colors.grey[100],
                            filled: true,
                            prefixIcon: const Icon(Icons.phone_outlined, color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.black, width: 1.2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF1E3C72), width: 2),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 28),

                        
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: isInteractionBlocked ? null : _handleSendCode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E3C72),
                              disabledBackgroundColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text(
                                    "Send Verification Code",
                                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                         
                        const Row(
                          children: [
                            Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("OR", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                            ),
                            Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                          ],
                        ),

                        const SizedBox(height: 20),

                        
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton(
                            onPressed: isInteractionBlocked
                                ? null
                                : () => ref.read(googleAuthProvider.notifier).signInWithGoogle(),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.grey, width: 1.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isGoogleLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF1E3C72),
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Native Material design social icon representation
                                      const Icon(Icons.g_mobiledata, color: Colors.red, size: 32),
                                      const SizedBox(width: 8),
                                      const Text(
                                        "Sign in with Google",
                                        style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
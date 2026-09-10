import 'package:driver_app/controller/DriverController.dart';
import 'package:driver_app/otpLogin/OtpVerificationResponseDto.dart';
import 'package:driver_app/provider/AppProvider.dart';
import 'package:driver_app/service/SessionService.dart';
import 'package:driver_app/service/SharedPreferenceService.dart';
import 'package:flutter/material.dart';
import 'package:driver_app/apiservice/OtpApiService.dart';
import 'package:driver_app/home/HomeScreen.dart';


class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final String phone;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.phone,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }


  Future<void> _handleVerifyOtp() async {
    final String otpCode = _otpController.text.trim();

    if (otpCode.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the complete 4-digit code.")),
      );
      return;
    }

    setState(() => _isLoading = true);


    OtpVerificationResponseDto response = await OtpApiService.verifyOtp(
      targetPhone: widget.phone,
      otp: otpCode,
    );
  
    setState(() => _isLoading = false);

    if (response.isOtpVerified) {
      final bool isRegistered = response.isRegistered;

      if (mounted) {
        if (isRegistered) {
          
          await SharedPreferenceService.saveDriverId(response.driver!.driverId!);
          appProviderContainer.read(driverControllerProvider.notifier).setDriver(response.driver!);
          await SessionService.restoreDriverTrip(response.driver!.driverId!);
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
              'email': widget.email,
              'phone': widget.phone,
            },
          );
        }
      }
    } else {
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid or expired verification code.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

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
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 32.0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(height: 12),
                        const Padding(
                          padding: EdgeInsets.only(left: 12.0),
                          child: Text(
                            "Verification",
                            style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
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
                        Text(
                          "We sent a 4-digit code to ${widget.email}",
                          style: const TextStyle(fontSize: 15, color: Colors.black54),
                        ),
                        const SizedBox(height: 24),

                        const Text(
                          "Enter Security Code",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          enabled: !_isLoading,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 22, letterSpacing: 14, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "0000",
                            hintStyle: const TextStyle(color: Colors.grey, letterSpacing: 14),
                            fillColor: Colors.grey[100],
                            filled: true,
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
                            onPressed: _isLoading ? null : _handleVerifyOtp,
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
                                    "Verify Code",
                                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
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
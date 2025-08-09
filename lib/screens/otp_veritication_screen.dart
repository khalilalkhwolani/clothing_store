// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/widgets/gradint_bottom.dart';

class OtpVeriticationScreen extends StatefulWidget {
  const OtpVeriticationScreen({super.key});

  @override
  State<OtpVeriticationScreen> createState() => _OtpVeriticationScreenState();
}

class _OtpVeriticationScreenState extends State<OtpVeriticationScreen> {
  final int otpLength = 6;
  final List<TextEditingController> _otpControllers = [];
  final List<FocusNode> _focusNode = []; // تم تعريفها بشكل صحيح
  bool _isVerifying = false;
  int _resendTimer = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < otpLength; i++) {
      _otpControllers.add(TextEditingController());
      _focusNode.add(FocusNode()); // تم تهيئته هنا
    }
    _startResendTimer();
  }

  void _startResendTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
        _startResendTimer();
      } else {
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  void _verifyOtp() {
    String otp = _otpControllers.map((controller) => controller.text).join();
    if (otp.length == otpLength) {
      setState(() => _isVerifying = true);
      Future.delayed(Duration(seconds: 2), () {
        if (!mounted) return;
        // Navigate to the next screen
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNode) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Verify Phone",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(height: 8),
              Text(
                "Enter 6-digit code sent to +78632957",
                style: TextStyle(fontSize: 16, color: AppTheme.textsecandery),
              ),
              SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  otpLength,
                  (index) => SizedBox(
                    width: 50,
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNode[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: TextStyle(fontSize: 24),
                      decoration: InputDecoration(
                        counterText: "",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppTheme.textsecandery.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppTheme.textsecandery.withOpacity(0.3),
                          ),
                        ),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          if (index < otpLength - 1) {
                            _focusNode[index + 1].requestFocus();
                            _verifyOtp();
                          } else {
                            _focusNode[index].unfocus();
                            _verifyOtp();
                          }
                        } else if (index > 0) {
                          _focusNode[index - 1].requestFocus();
                        }
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),
              GradintBottom(
                text: _isVerifying ? "Verifing ..." : "verify",
                onPressed: () {
                  if (!_isVerifying) {
                    _verifyOtp();
                  }
                },
              ),
              SizedBox(height: 24,),
              Center(
                child: Column(
                  children: [
                    Text("Dind't receive code !",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textsecandery,
                    ),
                    ),
                    SizedBox(height: 8,),
                    TextButton(onPressed: _canResend?(){
                      setState(() {
                        _canResend=false;
                        _resendTimer=30;

                      } 
                      );
                      _startResendTimer();
                    }:null ,
                    child: Text(
                      _canResend?"Recened code ":"Recend code in ${_resendTimer}s",
                      style: TextStyle(
                        color: _canResend
                        ?AppTheme.primaryColor
                        :AppTheme.textsecandery,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

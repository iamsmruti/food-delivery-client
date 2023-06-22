import 'package:admin/constants.dart';
import 'package:admin/screens/new_outlet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isLoading = StateProvider<bool>((ref) => false);

class OtpScreen extends ConsumerStatefulWidget {
  final String verificationId;
  final String phoneNumber;
  const OtpScreen(
      {super.key, required this.verificationId, required this.phoneNumber});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  String? _verificationCode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 115.0, horizontal: 24.0),
            child: Column(
              children: [
                SvgPicture.asset(
                  "assets/images/otp.svg",
                  fit: BoxFit.cover,
                  width: 250,
                ),
                const SizedBox(height: 50),
                const Text(
                  "Verify Yourself",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: secondaryColor),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Enter the OTP sent to your mobile number",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: secondaryColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Pinput(
                  length: 6,
                  showCursor: true,
                  defaultPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                  onCompleted: (value) => {
                    setState(() => _verificationCode = value),
                  },
                ),
                const SizedBox(height: 30),
                MaterialButton(
                  minWidth: double.infinity,
                  color: secondaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  onPressed: () async {
                    ref.read(isLoading.notifier).state = true;
                    try {
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: widget.verificationId,
                              smsCode: _verificationCode!);
                      await FirebaseAuth.instance
                          .signInWithCredential(credential)
                          .then((value) {
                        if (value.user != null) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const NewOutlet()),
                              (route) => false);
                        }
                      });
                    } on FirebaseAuthException catch (e) {
                      ref.read(isLoading.notifier).state = false;
                      Fluttertoast.showToast(msg: e.toString());
                    }
                  },
                  child: ref.watch(isLoading)
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Submit",
                          style: TextStyle(color: primaryColor),
                        ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Didn't receive any Code?",
                  style: TextStyle(fontSize: 12, color: secondaryColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Resend New Code",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: tertiaryColor),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

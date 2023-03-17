import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FirebsePhoneAuth {
  FirebaseAuth auth = FirebaseAuth.instance;
  int? forceResendToken;
  verifyphone(String phoneNum, BuildContext context) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNum,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          if (value.user != null) {
            if (kDebugMode) {
              print("User Signed In SucessFully");
            }
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        if (kDebugMode) {
          print(e.message);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        forceResendToken = resendToken;
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => Verification(
        //               phoneNumber: phoneNum,
        //               verificationId: verificationId,
        //             )));
      },
      forceResendingToken: forceResendToken,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}

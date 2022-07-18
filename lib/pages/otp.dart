import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitalinea/pages/homepage.dart';

class OtpPage extends StatefulWidget {
  final String countrycode;
  final String phonenumber;
  final String name;
  const OtpPage({Key? key, required this.countrycode, required this.phonenumber, required this.name}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  int stime = 60;
  bool _allowOTP = false;
  String _otp = '';
  User? user;
  FocusNode f1 = FocusNode();
  TextEditingController t1 = TextEditingController();
  FocusNode f2 = FocusNode();
  TextEditingController t2 = TextEditingController();
  FocusNode f3 = FocusNode();
  TextEditingController t3 = TextEditingController();
  FocusNode f4 = FocusNode();
  TextEditingController t4 = TextEditingController();
  FocusNode f5 = FocusNode();
  TextEditingController t5 = TextEditingController();
  FocusNode f6 = FocusNode();
  TextEditingController t6 = TextEditingController();
  late Timer timer;

  Widget otpfield(ctrl, fcs, margin) {
    return Flexible(
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        margin: margin,
        color: Theme.of(context).canvasColor,
        child: TextField(
          onChanged: (value) {
            if (fcs != f6) {
              FocusScope.of(context).nextFocus();
            } else {
              FocusScope.of(context).unfocus();
            }
          },
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          controller: ctrl,
          maxLength: 1,
          cursorColor: Theme.of(context).primaryColor,
          decoration: const InputDecoration(
            hintText: "",
            counterText: '',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '${widget.countrycode}${widget.phonenumber}',
      verificationCompleted: (userCreds) async {
        await FirebaseAuth.instance.signInWithCredential(userCreds);
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('signed', true);
      },
      verificationFailed: (FirebaseAuthException e) => print(e),
      codeSent: (String verificationID, int? resendToken) => _otp = verificationID,
      codeAutoRetrievalTimeout: (verificationID) => print('Timeout'),
      timeout: const Duration(seconds: 60),
    );
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _otp, smsCode: '${t1.text}${t2.text}${t3.text}${t4.text}${t5.text}${t6.text}');

    await FirebaseAuth.instance.signInWithCredential(credential).then(
      (value) {
        setState(() {
          user = FirebaseAuth.instance.currentUser;
        });
      },
    ).whenComplete(
      () async {
        if (user != null) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('signed', true);
          prefs.setString('phonenumber', '${widget.countrycode}${widget.phonenumber}');
          CollectionReference users = FirebaseFirestore.instance.collection('users');
          var userData = {
            'name': widget.name,
            'phone': '${widget.countrycode}${widget.phonenumber}',
            'city': 'N.A',
            'pin': 'N.A',
            'donor': false,
            'donations': 0,
            'lat': 0,
            'lng': 0,
            'blood': 'N.A'
          };

          users.doc('${widget.countrycode}${widget.phonenumber}').get().then((doc) async {
            if (!(doc.exists)) {
              users.doc('${widget.countrycode}${widget.phonenumber}').set(userData);
            }
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const Homepage(),
              ),
            );
          });
        } else {
          print('failed');
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    verifyPhoneNumber();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        if (t.tick == 60) {
          timer.cancel();
          _allowOTP = true;
        } else {
          stime--;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter OTP',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                otpfield(t1, f1, const EdgeInsets.fromLTRB(8, 15, 8, 15)),
                otpfield(t2, f2, const EdgeInsets.fromLTRB(8, 15, 8, 15)),
                otpfield(t3, f3, const EdgeInsets.fromLTRB(8, 15, 8, 15)),
                otpfield(t4, f4, const EdgeInsets.fromLTRB(8, 15, 8, 15)),
                otpfield(t5, f5, const EdgeInsets.fromLTRB(8, 15, 8, 15)),
                otpfield(t6, f6, const EdgeInsets.fromLTRB(8, 15, 8, 15)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                onPressed: () {
                  verifyOTP();
                },
                child: Text(
                  'Verify',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: !_allowOTP
                  ? Text(
                      'Get another OTP in $stime seconds.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall,
                    )
                  : GestureDetector(
                      onTap: () async {
                        verifyPhoneNumber();
                        setState(() {
                          _allowOTP = false;
                          stime = 60;
                          timer = Timer.periodic(const Duration(seconds: 1), (t) {
                            setState(() {
                              if (t.tick == 60) {
                                timer.cancel();
                                _allowOTP = true;
                              } else {
                                stime--;
                              }
                            });
                          });
                        });
                      },
                      child: Text(
                        'Get another OTP',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Change phone number',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
}

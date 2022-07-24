import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitalinea/main.dart';
import 'package:vitalinea/pages/homepage.dart';
import 'package:vitalinea/program/config.dart';

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
  late Timer timer;

  verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '${widget.countrycode}${widget.phonenumber}',
      verificationCompleted: (userCreds) async {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationID, int? resendToken) => _otp = verificationID,
      codeAutoRetrievalTimeout: (verificationID) {},
      timeout: const Duration(seconds: 60),
    );
  }

  void verifyOTP() async {
    Alert(
      style: Config.alertConfig,
      context: context,
      title: 'Verifying OTP',
      content: const Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Center(child: CircularProgressIndicator()),
      ),
      buttons: [],
    ).show();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: _otp, smsCode: t1.text);

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
          CollectionReference users = FirebaseFirestore.instance.collection('users');
          var userData = {
            'name': widget.name,
            'phone': '${widget.countrycode}${widget.phonenumber}',
            'city': 'N.A',
            'pin': 'N.A',
            'donor': false,
            'donations': 0,
            'lat': 'N.A',
            'lng': 'N.A',
            'blood': 'N.A'
          };
          prefs.setBool('signed', true);
          prefs.setString('phonenumber', '${widget.countrycode}${widget.phonenumber}');
          users.doc('${widget.countrycode}${widget.phonenumber}').get().then((doc) async {
            if (!(doc.exists)) {
              users.doc('${widget.countrycode}${widget.phonenumber}').set(userData);
            } else {
              users.doc('${widget.countrycode}${widget.phonenumber}').update(userData);
            }
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const Homepage(),
              ),
            );
          });
        } else {
          Navigator.pop(context);
          Alert(
            style: Config.alertConfig,
            context: context,
            title: 'Error!',
            desc: 'An Unexpected error occured. Please try again.',
            buttons: [
              DialogButton(
                highlightColor: const Color.fromRGBO(0, 0, 0, 0),
                splashColor: const Color.fromRGBO(0, 0, 0, 0),
                radius: const BorderRadius.all(Radius.circular(20)),
                color: MyApp.myColor,
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                width: 120,
                child: const Text(
                  "OK",
                  style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
                ),
              )
            ],
          ).show();
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
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 24, right: 8),
              height: 64,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              child: TextField(
                onChanged: (value) {
                  if (value.length == 6) {
                    FocusScope.of(context).unfocus();
                  }
                },
                style: const TextStyle(letterSpacing: 16),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                controller: t1,
                cursorColor: Theme.of(context).primaryColor,
                decoration: const InputDecoration(
                  hintText: "",
                  counterText: '',
                  border: InputBorder.none,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                onPressed: () {
                  timer.cancel();
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

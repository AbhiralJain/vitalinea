import 'package:flutter/material.dart';
import 'package:vitalinea/pages/otp.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _countrycode = TextEditingController(text: "+91");
  final TextEditingController _phonenumber = TextEditingController();
  final TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Vita Linea',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Text(
              'A line for healthy\nlife.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                'Your name',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 8, 24),
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 24, right: 8),
              height: 64,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: TextField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                controller: _name,
                style: Theme.of(context).textTheme.titleMedium,
                decoration: const InputDecoration.collapsed(
                  hintText: '',
                  border: InputBorder.none,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                'Your phone number',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 8,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 24, right: 8),
                    height: 64,
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      controller: _countrycode,
                      style: Theme.of(context).textTheme.titleMedium,
                      decoration: const InputDecoration.collapsed(
                        hintText: '',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 20,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 24, right: 10),
                    height: 64,
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      controller: _phonenumber,
                      style: Theme.of(context).textTheme.titleMedium,
                      decoration: const InputDecoration.collapsed(
                        hintText: '',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtpPage(
                        countrycode: _countrycode.text,
                        phonenumber: _phonenumber.text,
                        name: _name.text,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Get OTP',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Support', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(flex: 5),
              Text('Contact us on:', style: Theme.of(context).textTheme.titleMedium),
              const Spacer(flex: 1),
              const Text('Abhiral Jain: '),
              GestureDetector(
                onTap: () async {
                  final Uri url = Uri.parse("tel:+918830693895");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: const Text('+91 8830693895'),
              ),
              const Spacer(flex: 1),
              const Text('Aditya Jogwar: '),
              GestureDetector(
                onTap: () async {
                  final Uri url = Uri.parse("tel:+919552827698");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: const Text('+91 9552827698'),
              ),
              const Spacer(flex: 1),
              const Text('Aishwarya Bawankule: '),
              GestureDetector(
                onTap: () async {
                  final Uri url = Uri.parse("tel:+919373806684");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: const Text('+91 9373806684'),
              ),
              const Spacer(flex: 1),
              const Text('Anushree Madne: '),
              GestureDetector(
                onTap: () async {
                  final Uri url = Uri.parse("tel:+919834503601");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: const Text('+91 9834503601'),
              ),
              const Spacer(flex: 3),
              Text('Mail us at:', style: Theme.of(context).textTheme.titleMedium),
              const Spacer(flex: 1),
              const Text('a12021920@gmail.com'),
              const Spacer(flex: 5),
            ],
          ),
        ),
      ),
    );
  }
}

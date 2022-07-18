import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Text('About', style: Theme.of(context).textTheme.titleLarge),
              const Text(
                  'This Blood donation system helps the blood seeker to easily  requests blood and track donor. It provides a platform to improve the efficiency of blood donation and help the blood seekers as well.\n\nThe application uses donors registered phone number to verify the request so as to proceed with the blood donation process. The seeker just needs to provide their blood group and it will automatically show the donor nearby and send an alert message to the donor. The donor’s history of donating the blood to the seekers will also be displayed in the application along with some filter options as well.'),
            ],
          ),
        ),
      ),
    );
  }
}

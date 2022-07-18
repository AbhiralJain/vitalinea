import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final Map udata;
  const ProfilePage({Key? key, required this.udata}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 10),
              Text(udata['name'], style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
              const Spacer(),
              Text(udata['phone'], textAlign: TextAlign.center),
              const Spacer(),
              if (!(udata['city'] == 'N.A')) Text('${udata['city']} - ${udata['pin']}', textAlign: TextAlign.center),
              if (!(udata['city'] == 'N.A')) const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Blood group: ', textAlign: TextAlign.center),
                  Text(udata['blood'], style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Total donations: ', textAlign: TextAlign.center),
                  Text(udata['td'].toString(),
                      style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
                ],
              ),
              const Spacer(flex: 10),
            ],
          ),
        ),
      ),
    );
  }
}

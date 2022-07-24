import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestsPage extends StatefulWidget {
  final String pin;
  const RequestsPage({Key? key, required this.pin}) : super(key: key);

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  CollectionReference requests = FirebaseFirestore.instance.collection('requests');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Requests',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(flex: 1),
              Expanded(
                flex: 20,
                child: StreamBuilder(
                  stream: requests.snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          'Fetching Requests...',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      );
                    } else {
                      return ListView(
                        children: snapshot.data!.docs.map((document) {
                          if (document['pin'] == widget.pin) {
                            return Container(
                              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                              margin: const EdgeInsets.only(top: 5),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 5,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          document['name'],
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                        Text(
                                          document['phone'],
                                          style: Theme.of(context).textTheme.labelSmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: Text(
                                      document['bloodtype'],
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

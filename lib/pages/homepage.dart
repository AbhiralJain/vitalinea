import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vitalinea/main.dart';
import 'package:vitalinea/pages/about.dart';
import 'package:vitalinea/pages/donate.dart';
import 'package:vitalinea/pages/profile.dart';
import 'package:vitalinea/pages/request.dart';
import 'package:vitalinea/pages/requests.dart';
import 'package:vitalinea/pages/support.dart';
import 'package:vitalinea/program/config.dart';
import 'package:vitalinea/program/menubar.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late BitmapDescriptor my;
  late BitmapDescriptor abp;
  late BitmapDescriptor abn;
  late BitmapDescriptor ap;
  late BitmapDescriptor an;
  late BitmapDescriptor bp;
  late BitmapDescriptor bn;
  late BitmapDescriptor op;
  late BitmapDescriptor on;
  bool _menubar = false;
  bool _request = false;
  int totaldonors = 0;
  final Completer _controller = Completer();
  final Set<Marker> markers = {};
  Map udata = {
    'name': '',
    'phone': '',
    'city': '',
    'blood': '',
    'pin': '',
    'td': '',
    'donor': false,
  };

  getUserData() async {
    CollectionReference user = FirebaseFirestore.instance.collection('users');
    final prefs = await SharedPreferences.getInstance();
    final String myphonenumber = prefs.getString('phonenumber')!;
    DocumentSnapshot<Object?> obj = await user.doc(myphonenumber).get();
    setState(() {
      udata = {
        'name': obj.get('name'),
        'phone': obj.get('phone'),
        'city': obj.get('city'),
        'blood': obj.get('blood'),
        'pin': obj.get('pin'),
        'td': obj.get('donations'),
        'donor': obj.get('donor'),
      };
    });
  }

  initmarker() async {
    my = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(6, 6)), 'assets/markers/my.bmp');
    abp = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(10, 10)), 'assets/markers/abp.bmp');
    abn = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(10, 10)), 'assets/markers/abn.bmp');
    ap = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(10, 10)), 'assets/markers/ap.bmp');
    an = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(10, 10)), 'assets/markers/an.bmp');
    bp = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(10, 10)), 'assets/markers/bp.bmp');
    bn = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(10, 10)), 'assets/markers/bn.bmp');
    op = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(10, 10)), 'assets/markers/op.bmp');
    on = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(10, 10)), 'assets/markers/on.bmp');
    setState(() {
      markers.add(Marker(
        icon: my,
        markerId: MarkerId(udata['name']),
        position: LatLng(Config.position!.latitude, Config.position!.longitude),
      ));
    });
  }

  List<Map> donorlist = [];
  getdonors() async {
    donorlist = [];
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    QuerySnapshot<Object?> list = await users.get();
    final prefs = await SharedPreferences.getInstance();
    final String myphonenumber = prefs.getString('phonenumber')!;
    DocumentSnapshot<Object?> myobj = await users.doc(myphonenumber).get();
    final String mypin = myobj.get('pin');

    for (int i = 0; i < list.docs.length; i++) {
      if (list.docs[i].get('donor') == true &&
          list.docs[i].get('phone') != myphonenumber &&
          list.docs[i].get('pin') == mypin) {
        donorlist.add({
          'name': list.docs[i].get('name'),
          'phone': list.docs[i].get('phone'),
          'city': list.docs[i].get('city'),
          'pin': list.docs[i].get('pin'),
          'donor': list.docs[i].get('donor'),
          'donations': list.docs[i].get('donations'),
          'lat': list.docs[i].get('lat'),
          'lng': list.docs[i].get('lng'),
          'blood': list.docs[i].get('blood'),
        });
      }
    }
    setState(() {
      totaldonors = donorlist.length;
    });
    for (int i = 0; i < donorlist.length; i++) {
      final BitmapDescriptor myicon;
      switch (donorlist[i]['blood']) {
        case 'A+':
          myicon = ap;
          break;
        case 'A-':
          myicon = an;
          break;
        case 'B+':
          myicon = bp;
          break;
        case 'B-':
          myicon = bn;
          break;
        case 'AB+':
          myicon = abp;
          break;
        case 'AB-':
          myicon = abn;
          break;
        case 'O+':
          myicon = op;
          break;
        case 'O-':
          myicon = on;
          break;
        default:
          myicon = my;
      }
      setState(() {
        markers.add(Marker(
            icon: myicon,
            markerId: MarkerId(donorlist[i]['phone']),
            position: LatLng(double.parse(donorlist[i]['lat']), double.parse(donorlist[i]['lng'])),
            onTap: () {
              Alert(
                style: Config.alertConfig,
                context: context,
                title: '${donorlist[i]['name']} - ${donorlist[i]['blood']}',
                desc: donorlist[i]['phone'],
                buttons: [
                  DialogButton(
                    highlightColor: const Color.fromRGBO(0, 0, 0, 0),
                    splashColor: const Color.fromRGBO(0, 0, 0, 0),
                    radius: const BorderRadius.all(Radius.circular(20)),
                    color: MyApp.myColor,
                    onPressed: () async {
                      final Uri url = Uri.parse("tel:${donorlist[i]['phone']}");
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    width: 120,
                    child: const Text(
                      "Contact",
                      style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
                    ),
                  )
                ],
              ).show();
            }));
      });
    }
  }

  menubuttons(text, page) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: TextButton(
        style: TextButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.all(15),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
        onPressed: () {
          setState(() {
            _menubar = !_menubar;
          });
          if (page != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => page,
              ),
            );
          }
        },
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Alert(
        style: Config.alertConfig,
        context: context,
        title: 'Getting things ready',
        content: const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Center(child: CircularProgressIndicator()),
        ),
        buttons: [],
      ).show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              onTap: (ltlng) {
                setState(() {
                  if (_menubar) _menubar = false;
                });
              },
              markers: markers,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(Config.position!.latitude, Config.position!.longitude),
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) async {
                controller.setMapStyle(Config.mapStyle);
                setState(() {
                  _controller.complete(controller);
                });
                await initmarker();
                await getUserData();
              },
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: MyApp.myColor.shade50,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 10),
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 5,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _menubar = !_menubar;
                          });
                        },
                        icon: const Icon(
                          Icons.menu,
                        ),
                      ),
                      const Spacer(flex: 2),
                      Text(
                        !_request ? 'Hello ${udata['name'].split(' ').first}!' : "$totaldonors donors around you",
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: MyApp.myColor,
                        ),
                      ),
                      const Spacer(flex: 3),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    onPressed: () async {
                      _request = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RequestPage(
                            lat: Config.position!.latitude,
                            lng: Config.position!.longitude,
                          ),
                        ),
                      );

                      if (_request) {
                        await getdonors();
                      }
                    },
                    child: const Text(
                      'Request Blood',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            MyWidget(
              controller: _menubar,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _menubar = !_menubar;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                    ),
                  ),
                  Text(
                    udata['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                  ),
                  Text(udata['phone']),
                  const Spacer(),
                  menubuttons('Home', null),
                  menubuttons(
                      'Profile',
                      ProfilePage(
                        udata: udata,
                      )),
                  menubuttons('About', const AboutPage()),
                  menubuttons('Support', const SupportPage()),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 0, 64),
                    child: udata['donor']
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              primary: MyApp.myColor.shade100,
                              padding: const EdgeInsets.all(15),
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => RequestsPage(
                                    pin: udata['pin'],
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Requests',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              primary: MyApp.myColor.shade100,
                              padding: const EdgeInsets.all(15),
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                            ),
                            onPressed: () async {
                              bool donate = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DonatePage(
                                    lat: Config.position!.latitude,
                                    lng: Config.position!.longitude,
                                  ),
                                ),
                              );

                              if (donate) {
                                await getUserData();
                              }
                            },
                            child: Text(
                              'Donate Blood',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

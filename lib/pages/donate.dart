import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitalinea/main.dart';
import 'package:vitalinea/program/config.dart';

class DonatePage extends StatefulWidget {
  final double lat;
  final double lng;
  const DonatePage({Key? key, required this.lat, required this.lng}) : super(key: key);

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  TextEditingController _city = TextEditingController();
  TextEditingController _pincode = TextEditingController();
  final Completer _controller = Completer();
  String _bloodgroup = 'A+';
  late Position position;
  Set<Marker> markers = {};
  bool _agr = false;
  getlocation() async {
    bool status = await Config.requestpermission(Permission.location);
    if (status) {
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print(position);
    } else {
      print('error p');
    }
  }

  late BitmapDescriptor my;
  initmarker() async {
    my = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(8, 8)), 'assets/markers/my.bmp');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Become a Donor!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Row(
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                      ),
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.next,
                        controller: _city,
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                        style: Theme.of(context).textTheme.titleMedium,
                        decoration: InputDecoration.collapsed(
                          hintText: 'City',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: MyApp.myColor.shade200,
                            fontSize: 24,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                      ),
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        controller: _pincode,
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                        style: Theme.of(context).textTheme.titleMedium,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Pincode',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: MyApp.myColor.shade200,
                            fontSize: 24,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Blood Group:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  Container(
                    margin: const EdgeInsets.all(16),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: DropdownButton<String>(
                      value: _bloodgroup,
                      iconSize: 0,
                      elevation: 8,
                      style: Theme.of(context).textTheme.titleMedium,
                      underline: const SizedBox(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _bloodgroup = newValue!;
                          print(_bloodgroup);
                        });
                      },
                      items: <String>['A+', 'A-', 'AB+', 'AB-', 'B+', 'B-', 'O+', 'O-']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: SizedBox(
                            width: 70,
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 1),
              Text(
                'Locate yourslef ',
                style: TextStyle(
                  color: MyApp.myColor.shade700,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.normal,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: SizedBox(
                  height: 200,
                  child: GoogleMap(
                    markers: markers,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(widget.lat, widget.lng),
                      zoom: 16,
                    ),
                    onMapCreated: (GoogleMapController controller) async {
                      controller.setMapStyle(Config.mapStyle);
                      setState(() {
                        _controller.complete(controller);
                      });
                      await initmarker();
                      await getlocation();
                    },
                    onTap: (latlng) async {
                      print(latlng);

                      setState(() {
                        markers = {};
                        markers.add(
                          Marker(
                            icon: my,
                            markerId: const MarkerId('mylocation'),
                            position: latlng,
                          ),
                        );
                      });
                    },
                  ),
                ),
              ),
              const Spacer(flex: 1),
              Row(
                children: [
                  Checkbox(
                    fillColor: MaterialStateProperty.all(
                      MyApp.myColor,
                    ),
                    checkColor: MyApp.myColor,
                    shape: const CircleBorder(),
                    value: _agr,
                    onChanged: (value) {
                      setState(() {
                        _agr = value!;
                      });
                    },
                  ),
                  Flexible(
                    child: Text(
                      'I have read all the rules set by National Blood Transfusion Council and I am eligible to donate blood.',
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: MyApp.myColor.shade700,
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                  onPressed: !_agr
                      ? null
                      : () async {
                          CollectionReference users = FirebaseFirestore.instance.collection('users');
                          var userData = {
                            'city': _city.text,
                            'pin': _pincode.text,
                            'donor': true,
                            'donations': 0,
                            'lat': position.latitude,
                            'lng': position.longitude,
                            'blood': _bloodgroup
                          };
                          final prefs = await SharedPreferences.getInstance();
                          final String phonenumber = prefs.getString('phonenumber')!;
                          await users.doc(phonenumber).update(userData);
                          Alert(
                            style: Config.alertConfig,
                            context: context,
                            title: 'You are a noble person',
                            desc: 'Thank you for being a blood donor and for your contributions to the society.',
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
                        },
                  child: Text(
                    'Register',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

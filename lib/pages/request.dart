import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitalinea/main.dart';
import 'package:vitalinea/program/config.dart';
import 'dart:async';

class RequestPage extends StatefulWidget {
  final double lat;
  final double lng;

  const RequestPage({Key? key, required this.lat, required this.lng}) : super(key: key);

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  TextEditingController _name = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _pincode = TextEditingController();
  String _bloodgroup = 'A+';
  bool _pointed = false;
  late Position position;
  final Completer _controller = Completer();
  bool _tc = false;
  Set<Marker> markers = {};
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
              Text('Request', style: Theme.of(context).textTheme.titleLarge),
              Container(
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
                  controller: _name,
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                  style: Theme.of(context).textTheme.titleMedium,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Enter patient\'s name',
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
              Text(
                'Locate your hospital',
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
                    value: _tc,
                    onChanged: (value) {
                      setState(() {
                        _tc = value!;
                      });
                    },
                  ),
                  Flexible(
                    child: Text(
                      'I am willing to pay the transportation charges of the donor.',
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
                  onPressed: () async {
                    CollectionReference requests = FirebaseFirestore.instance.collection('requests');
                    CollectionReference users = FirebaseFirestore.instance.collection('users');
                    final prefs = await SharedPreferences.getInstance();
                    String phonenumber = prefs.getString('phonenumber')!;
                    var rData = {
                      'name': _name.text,
                      'phone': phonenumber,
                      'bloodtype': _bloodgroup,
                      'city': _city.text,
                      'pin': _pincode.text,
                      'lat': 0,
                      'lng': 0,
                      'tcost': _tc,
                    };
                    var uData = {
                      'blood': _bloodgroup,
                      'city': _city.text,
                      'pin': _pincode.text,
                      'lat': 0,
                      'lng': 0,
                    };
                    users.doc(phonenumber).update(uData);
                    requests.doc(phonenumber).get().then((doc) {
                      if (doc.exists) {
                        doc.reference.update(rData);
                      } else {
                        requests.doc(phonenumber).set(rData);
                      }
                    });
                    Alert(
                      style: Config.alertConfig,
                      context: context,
                      title: 'Note',
                      desc: 'Your request for $_bloodgroup blood has been sent to donors in your area.',
                      buttons: [
                        DialogButton(
                          highlightColor: const Color.fromRGBO(0, 0, 0, 0),
                          splashColor: const Color.fromRGBO(0, 0, 0, 0),
                          radius: const BorderRadius.all(Radius.circular(20)),
                          color: MyApp.myColor,
                          onPressed: () async {
                            Navigator.pop(context);
                            Navigator.pop(context, true);
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
                    'Request Blood',
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

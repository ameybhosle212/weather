import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: My(),
    );
  }
}

class My extends StatefulWidget {
  @override
  _MyState createState() => _MyState();
}

class _MyState extends State<My> {
  final _formKey = GlobalKey<FormState>();
  var temp = 1;
  String placeCity = '' , ownCity = '' , Temperature1 = '' , Temperature2 = '';
  double latitude = 0.0, longitude=0.0 ;
  // ignore: non_constant_identifier_names
  bool Mylat = false , myCity = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const SizedBox(
                height: 30,
              ),
              myCity ? Container(
                child: Column(
                  children: [
                    Text(
                      placeCity,
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(Temperature1)
                  ],
                )
              ) :Container(),
              const SizedBox(
                width: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0 , 10 , 0),
                child: TextFormField(
                  validator: (String? value){
                    if(value!.isEmpty){
                        return 'Please Enter Value';
                      }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter City'
                  ),
                  onChanged: (value)=> placeCity = value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async{
                    if(_formKey.currentState!.validate()){
                      print(placeCity);
                      var url = Uri.parse('http://localhost:1001/getPlace');
                      var response = await http.post(url,headers: <String, String>{
                          "Accept": "application/json",
                          "Content-Type": "application/x-www-form-urlencoded"
                        },
                        body: {
                          'place': placeCity,
                        },
                      );
                      if(response.statusCode == 200 ){
                        var d = jsonDecode(response.body);
                        var name = d["data"]["name"];
                        var temp = d["data"]["main"]["temp"];
                        Temperature1 = 'Temperature is '+ temp.toString();
                        print(d);
                        setState(() {
                          placeCity = name;
                          myCity = true;
                        });
                      }
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Mylat ? Container(
                child: Column(
                  children: [
                    Text(Temperature2),
                    Text('In Your City')
                  ],
                ),
              ) : Container(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0 , 100,10,0),
                child: ElevatedButton(
                  onPressed: () async {
                    Position position = await _determinePosition();
                    print(position);
                    latitude = position.latitude;
                    longitude = position.longitude;
                    print(latitude);
                    var url = Uri.parse('http://localhost:1001/getLatLong');
                    print(longitude);
                    var response = await http.post(url,
                      headers: <String, String>{
                          "Accept": "application/json",
                          "Content-Type": "application/x-www-form-urlencoded"
                      },
                      body: {
                        'latitude': latitude.toString(),
                        'longitude':longitude.toString(),
                      },
                    );
                    print(jsonDecode(response.body));
                    if(response.statusCode == 200){
                      var vl = jsonDecode(response.body);
                      vl = vl["data"]["main"]["temp"];
                      Temperature2 = 'Temperature is ' + vl.toString();
                    }else{
                      print(response.body);
                    }
                    setState(() {
                      Mylat = true;
                    });
                  }, 
                  child: Text('Get My Location'),
                ),
              ),
            ],
          )
        )
      ),
    );
  }
}


Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 
  return await Geolocator.getCurrentPosition();
}

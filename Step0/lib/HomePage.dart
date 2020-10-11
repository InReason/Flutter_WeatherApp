import 'dart:convert';
import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool gps;

  var weatherData;

  String url = 'http://api.openweathermap.org/data/2.5/weather?';
  String lat = '';
  String lon = '';
  String appId = 'appid=dc7514bb200db951267803dac9903224&';
  String units = 'units=metric';

  void permission()async{
    await requestPermission();
    var value = await checkPermission();
    setState(() {
      if(value == LocationPermission.always || value == LocationPermission.whileInUse) gps = true;
      else gps = false;
    });
  }

  Future getData() async{
    Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
    lat = 'lat=' + position.latitude.toString() + '&';
    lon = 'lon=' + position.longitude.toString() + '&';

    http.Response response = await http.get(
      Uri.encodeFull(url + lat + lon + appId + units),
      headers: {"Accept": "application/json"},
    );
    print('Response body: ${response.body}');
    weatherData = jsonDecode(response.body);
    return weatherData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          getData();
        },
      ),
    );
  }
}

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool gps;

  var weatherData;
  var background = Color(0xFFB1D1CF);

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

    /// Background
    if(weatherData['main']['temp'] < 22){
      background = Color(0xFFB1D1CF);
      print('cold');
    }else{
      background = Color(0xFFF5CE8B);
      print('hot');
    }
    return weatherData;
  }

  Future<Null> _onRefresh()async{
    setState(() {
    });
  }

  @override
  void initState() {
    permission();
    super.initState();
  }

  /// Step 1
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10),
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Row(
                children: [
                  Text(
                    'Weather Apps',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.share, color: Colors.black),
                    onPressed: (){
                    },
                  )
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                              'https://reasley.com/wp-content/uploads/2020/02/%EB%B0%B0%EA%B2%BD.png'
                            ),
                          )
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('reasley',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text('reasley.com@gmail.com', style: TextStyle(color: Colors.black,),),
                  ],
                )
            ),

            Divider(color: Colors.black,),

            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(icon: Icon(Icons.menu), onPressed: (){
                        _scaffoldKey.currentState.openDrawer();
                      }),
                      Spacer(),
                      Text('Weather Apps'),
                      Spacer(),
                      gps == true
                      ? IconButton(icon: Icon(Icons.gps_fixed), onPressed: (){
                        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('위치 정보를 정상적으로 받아오고 있습니다.')));
                      })
                      : IconButton(icon: Icon(Icons.gps_not_fixed), onPressed: (){
                        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('위치 정보가 정상적이지 못합니다.')));
                      }),
                    ],
                  ),

                  FutureBuilder(
                    future: getData(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(!snapshot.hasData) return CircularProgressIndicator();
                      return Container(
                        color: background,
                        child: Column(
                          children: [
                            /// Step 2
                            SizedBox(height: 40,),
                            Text('${snapshot.data['weather'][0]['main']}',
                                style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.location_on, color: Colors.white, size: 16,),
                                Text(' ${snapshot.data['name']}',
                                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                              ],
                            ),

                            /// Step 3
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${snapshot.data['main']['temp'].toStringAsFixed(0)}',
                                  style: TextStyle(fontSize: 65, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                Column(
                                  children: [
                                    Text('°C',
                                      style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    Row(children: [
                                      Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 15,),
                                      Text('${snapshot.data['main']['temp_max'].toStringAsFixed(0)}°C',
                                        style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ],),
                                    Row(children: [
                                      Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 15,),
                                      Text('${snapshot.data['main']['temp_min'].toStringAsFixed(0)}°C',
                                        style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ],),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }
}

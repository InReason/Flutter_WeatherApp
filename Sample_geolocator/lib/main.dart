import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage()
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Geolocator Test'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center ,
          children: [
            RaisedButton(
              child: Text('Permission Check'),
              onPressed: ()async{
                LocationPermission permission = await checkPermission();
                print(permission);
                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('$permission')));
              },
            ),
            RaisedButton(
              child: Text('Permission Request'),
              onPressed: ()async{
                LocationPermission permission = await requestPermission();
                print(permission);
                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('$permission')));
              },
            ),
            RaisedButton(
              child: Text('Location'),
              onPressed: ()async{
                Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                print(position);
                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('$position')));
              },
            ),
            RaisedButton(
              child: Text('Last Location'),
              onPressed: ()async{
                Position position = await getLastKnownPosition();
                print(position);
                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('$position')));
              },
            ),
          ],
        ),
      )
    );
  }
}

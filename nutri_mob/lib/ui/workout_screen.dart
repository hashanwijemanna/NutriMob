import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkoutScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();



    return Scaffold(
      backgroundColor: const Color(0xFF200087),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16,
            ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 40,),
              onPressed: () {
                    Navigator.of(context).pop();
              },
              ),
            ),
            SizedBox(
              height: 20,
            ),
        ListTile(
          title: Text(
            "${DateFormat("EEEE").format(today)}, ${DateFormat("d MMMM").format(today)}",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18,
              color: Colors.white,
            ),
              ),

          subtitle: Text(
              "Upper Body",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 24,
                color: Colors.white,
              ),
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
              Icons.access_time,
              color: Colors.white30,
              ),
              SizedBox(
              width: 5,
              ),
              Text(
            "60 mins",
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),

              ),
                  SizedBox(
                   height: 4,
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                    Icon(
                    Icons.shutter_speed,
                    color: Colors.white30,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Easy",
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
          ),
          ],
        ),



  ],
      ),
    ),
    ),
    );
  }
}
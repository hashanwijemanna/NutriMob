import 'package:flutter/material.dart';
import 'package:nutri_mob/model/meal.dart';
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   final height = MediaQuery.of(context).size.height;

   return Scaffold(
     backgroundColor: const Color(0xFFE9E9E9),
     bottomNavigationBar:  ClipRect(
       borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
     child: BottomNavigationBar(
       iconSize: 40,
         selectedIconTheme: IconThemeData(
           color: const Color(0xff200087),
         ),
         unselectedIconTheme: IconThemeData(
           color: const Colors.black12,
         ),


         items: [
           BottomNavigationBarItem(
     icon: Padding(
     padding: const EdgeInsets.only(top: 8.0),
             child: Icon(Icon.home),
     ),
             title: Text(
               "Home",
               style: const TextStyle(color: Colors.white),
             ),
           ),


           BottomNavigationBarItem(
             icon: Padding(
           child: Icon(Icons.search),
    padding: const EdgeInsets.only(top: 8.0),
    ),
             title: Text(
               "Search",
               style: const TextStyle(color: Colors.white),
             ),
           ),


           BottomNavigationBarItem(
             icon: Padding(
    child: Icon(Icon.person),
    padding: const EdgeInsets.only(top: 8.0),
    ),
             title: Text(
               "Profile",
               style: const TextStyle(color: Colors.white),
             ),
           ),

         ],
     ),
     body: Stack(
       children: <Widget>[
         Positioned(
           top: 0,
           height: height * 0.35,
           left: 0,
           right: 0,
           child: ClipRect(
             borderRadius: const BorderRadius.vertical(
               bottom: const Radius.circular(40),
             ),
             child: Container(
               color: Colors.white,
             ),
           ),
         ),
    Positioned(
    top: height * 0.38,
    left: 0,
    right: 0,
    child: Container(

    height: height,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
    padding: const EdgeInsets.only(
        bottom: 8,
    left: 32,
    right: 16,
    ),

    child: Text(
    "MEALS FOR TODAY",
    style: const TextStyle(
    color: Colors.blueGrey,
    fontSize: 16,
    fontWeight: FontWeight.w700
    ),
    ),
    ),
    Expanded(
    child: SingleChildScrollView(
    child: Row(
    children: <Widget>[
      for

    ],
    ),
    ),
    ),

    Expanded(
    child: Container(
    color: Colors.redAccent,
    child: ,
    ),
    ),

    Expanded(
    child: Container(
    color: Colors.blueAccent,

    ),
    ),



    ],
    ),
    ),
    ),
       ]
     ),
   );
  }
}

class _MealCard extends StatelessWidget {

  final Meal meal;
  const _MealCard({ Key key,  @required this.meal}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container (
      margin: const EdgeInsets.only(right: 20,bottom: 10),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        elevation: 4,
        child: Column(
          children: <Widget>[
            Expanded(
                child: Image.asset),
      ),
      Expanded(child: Column()),

          ],
        ),
      ),
    );

  }
}
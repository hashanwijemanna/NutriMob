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

    height: height * 0.50,
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
    scrollDirection: Axis.horizontal,
    child: Row(
    children: <Widget>[
      SizedBox(
    width: 32,
    ),
      for (int i = 0; i< meals.length; i++)
        _MealCard
    (meal: meals[i]),


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

    SizedBox(height: 20,
    ),
    Expanded(
    child: Container(
      margin: const EdgeInsets.only(bottom: 10, left: 32,
      right: 32),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(30)) ,
    gradient: LinearGradient(
      begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      const Color(0XFF20008B),
      const Color(0XFF200087),
    ],
    ),
    ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        SizedBox(width: 20,),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16),
            child: Text("YOUR NEXT WORKOUT",
              style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,

                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0,left: 16),
            child: Text(
              "Upper Body",
              style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,

            ),
            ),
          ),
          Expanded(
              child: Row(
            children: <Widget>[
              SizedBox(width: 20,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  color:  const Color(0xFF5B4D9D),
                ),
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                "assets/imagesCHEST.png ",
                width: 50,
                height: 50,
                color: Colors.white,
              ),
              ),
              SizedBox(
                width: 10,),

              Container(
                decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color:  const Color(0xFF5B4D9D),
                ),
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  " assets/back.webp",
                  width: 50,
                  height: 50,
                  color: Colors.white,
                ),),
              SizedBox(width: 10,),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                color:  const Color(0xFF5B4D9D),
                ),
                padding: const EdgeInsets.all(10),
                  child: Image.asset(
                " assets/Wide-grip-lat-pull-down-1.gif",
                    width: 50,
                    height: 50,
                    color: Colors.white,
                  ),),
              SizedBox(
                width: 10,),
            ],
          )
        ],
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
      margin: const EdgeInsets.only(
          right: 20,
          bottom: 10),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.max,
          children: <Widget>[
            Flexible(
              fit: FlexFit.tight,
                child: clipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20) ),
                child: Image.asset(
                  meal.imagePath,
                  width: 150,
                  fit: BoxFit.fill,
                ),
      ),
            ),
      Flexible(
        fit: FlexFit.tight,
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 5),


            Text(meal.mealTime,
              style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.blueGrey,
            ),
            ),


            Text(meal.name,  style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.black,
            ),),



            Text("${meal.kiloCaloriesBurnt} kcal", style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.blueGrey,
            ),),
            Row(
              children:<Widget>[
                Icon(Icons.access_time,
                  size: 15 ,
                  color: Colors.black12,),


SizedBox( width: 4,),
            Text("${meal.timeTaken} min", style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.blueGrey,
                ),),
              ],
            ),
            SizedBox(height: 16) ,
              ],



                  ),
          )),

          ],
        ),
      ),
    );

  }
}
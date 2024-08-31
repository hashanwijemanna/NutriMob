import 'package:flutter/material.dart';

class BMICalculater extends StatefulWidget {
  const BMICalculater({Key? key}) : super (key: key);

  @override
  State<BMICalculater> createState() => _BMICalculaterState();
}

class _BMICalculaterState extends State<BMICalculater> {

  var wtController = TextEditingController();
  var ftController = TextEditingController();
  var agController = TextEditingController();


  var result = "";
  var bgColor = Colors.indigo.shade200;





  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('your BMI value'),
        ),
        body: Container(
          color: bgColor,
          child: Center(
            child: Container(
              width: 300,
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text('BMI', style: TextStyle(
                    fontSize: 34, fontWeight: FontWeight.w700
                  ),),

                    SizedBox(height: 21,),


                    TextField(
                          controller: wtController,
                          decoration: InputDecoration(
                            label: Text('Enter your Weight(in Kgs)'),
                            prefixIcon: Icon(Icons.line_weight)
                          ),
                    keyboardType: TextInputType.number,
                        ),

                  TextField(
                  controller: ftController,
                  decoration: InputDecoration(
                  label: Text('Enter your Height(in Feet)'),
                  prefixIcon: Icon(Icons.height)
                  ),
                  keyboardType: TextInputType.number,
                  ),

                  SizedBox(height: 11,),

                  TextField(
                  controller: agController,
                  decoration: InputDecoration(
                  label: Text('Enter your Age'),
                  prefixIcon: Icon(Icons.height)
                  ),
                  keyboardType: TextInputType.number,
                  ),
              SizedBox(height: 16,),

              ElevatedButton(onPressed: (){
                var wt = wtController.text.toString();
                var ft = ftController.text.toString();
                var age = agController.text.toString();

                if(wt!="" && ft!="" && age!=""){

              // BMI CALCULATION


          var iWt = int.parse(wt);
          var iFt = int.parse(ft);
          var iAge = int.parse(age);

          var tInch = (iFt*12) + iAge;

          var tCm = tInch*2.54;

          var tM = tCm/100;

          var bmi = iWt/(tM*tM);

          var msg = "";

          if(bmi>25){
            msg = "You are OverWeight!!";
            bgColor = Colors.orange.shade200;

          }
          else if(bmi<18){
            msg = "You are UnderWeight!!";
            bgColor = Colors.red.shade200;

          } else {
            msg = "You are Healthy!!";
            bgColor = Colors.green.shade200;


          }

          setState(() {
            result = " $msg \n Your BMI is: ${bmi.toStringAsFixed(4)}";

          });

              } else {
          setState(() {
            result = "Please fill all the required blanks!! ";


          });

              }

              }, child: Text('Calculate')),

              SizedBox(height: 11,),

              Text(result, style: TextStyle(fontSize: 19),)


                    ],
                  ),
            ),
          ),
        )
            );

  }
  }

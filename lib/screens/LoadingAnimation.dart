import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopping_app_ui/colors/Colors.dart';

AnimatedContainer loadingAnimation(){

  return AnimatedContainer(
    duration: const Duration (milliseconds: 800),
    curve: Curves.fastLinearToSlowEaseIn,
    child: Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular (20),
    ),
    
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children:[
          Center(
            
            child: GestureDetector(
              /*onTap: (){
              Navigator.pop(context);
              },
              */
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow:[
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 10)
                    )
                  ]
                ),
                child: Center(
                  child: SpinKitCubeGrid(
                    color: primaryColor,
                    size: 80,
                  )
    
                ),
              ),
            )
          )
        ]
      )
    )
  );
 
}
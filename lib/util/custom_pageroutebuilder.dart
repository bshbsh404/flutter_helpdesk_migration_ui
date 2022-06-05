import'package:flutter/material.dart';

class BouncyPageRoute extends PageRouteBuilder{
  final Widget widget;
 BouncyPageRoute({this.widget})
      :super(
            transitionDuration:Duration(seconds:2),
            transitionsBuilder:(BuildContext context,
                Animation<double>animation,
                Animation<double>secAnimation,
                Widget child){
                  animation = CurvedAnimation(
                  parent:animation,curve:Curves.elasticInOut);
                  return ScaleTransition(
                    alignment:Alignment.center,
                    scale:animation,
                    child:child,  
                  );
                },
                pageBuilder:(BuildContext context,Animation<double>animation,
                    Animation<double>secAnimation){
                  return widget;
                });
}


class OpenUpwardsPageRoute extends PageRouteBuilder{
  final Widget child;
  final AxisDirection direction;

  OpenUpwardsPageRoute({
    this.child, this.direction})

      :super(
            transitionDuration:Duration(milliseconds:300),
            reverseTransitionDuration: Duration(milliseconds: 300),
            pageBuilder:(BuildContext context,Animation<double>animation,
                    Animation<double>secAnimation) => child);
      
  //side note refer to johan mike in YT for this one
  @override
  Widget buildTransitions(BuildContext context,Animation<double> animation, 
    Animation<double> secondaryAnimation, Widget child) => 
      SlideTransition(
        position: Tween<Offset>(
          begin: getBeginOffset(),
          end: Offset.zero,
        )
        .animate(animation),
        child: child,
      );
          
  
  Offset getBeginOffset(){
   switch(direction){
     case AxisDirection.up:
        return Offset(0,1);
     case AxisDirection.down:
        return Offset(0,-1);
     case AxisDirection.right:
        return Offset(-1,0);
     case AxisDirection.left:
        return Offset(1,0);
   }
  }
  
}


import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app_ui/colors/Colors.dart';
import 'package:shopping_app_ui/screens/products/MyTicketScreen.dart';
import 'package:shopping_app_ui/screens/products/MyToCheckInScreen.dart';
import 'package:shopping_app_ui/screens/products/tabCheckIn.dart';
import 'package:shopping_app_ui/screens/products/tabCheckOut.dart';
import 'package:shopping_app_ui/screens/products/tabSubmitForm.dart';
import 'package:shopping_app_ui/util/Util.dart';
import 'package:shopping_app_ui/util/size_config.dart';
import 'package:shopping_app_ui/widgets/Styles.dart';


class MyTicketMainScreen extends ConsumerStatefulWidget {


  @override
  _MyTicketMainScreenState createState() => _MyTicketMainScreenState();

}


class _MyTicketMainScreenState extends ConsumerState with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this );
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: DefaultTabController(

        length: 4,
        child: Scaffold(
          backgroundColor: isDarkMode(context)
          ? darkBackgroundColor
          : Theme.of(context).backgroundColor,
          appBar:  AppBar(
            backgroundColor: isDarkMode(context) ? darkGreyColor : Colors.white,
            title: Text(
              'My Tickets',
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                  fontWeight: Theme.of(context).textTheme.subtitle2.fontWeight),
            ),
            leading: InkWell(
              child: Icon(
                Icons.keyboard_backspace,
                color: isDarkMode(context)
                    ? Colors.white70
                    : Colors.black.withOpacity(0.8),
                size: getProportionateScreenWidth(18),
              ),
              onTap: () {
                final CurvedNavigationBarState navState = getNavState();
                navState.setPage(0);
              },
            ),
            centerTitle: true,
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.4),
            bottom: TabBar(    
              controller: _controller,     
              isScrollable: true,
              indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50), // Creates border
              color: Colors.greenAccent),
              tabs: [
                Tab(text: 'All '),
                Tab(text: 'Check In'),
                Tab(text: 'Check Out'),
                Tab(text: 'Submit Form'),
                
                
              ],
            ),
          ),
          
          body: TabBarView( 
            controller: _controller,  
            children: [
              MyTicketScreen(),
              CheckInTab(),
              CheckOutTab(),
              SubmitFormTab()

              //MyCheckInScreen(),
              //Icon(Icons.flight, size: 350),
              //Icon(Icons.flight, size: 350)
            ]
          ),     

        ),         
      ),  
    );   
  }
}




import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';  
import 'package:shopping_app_ui/OdooApiCall_DataMapping/ToCheckIn_ToCheckOut_SupportTicket.dart';
import 'package:shopping_app_ui/colors/Colors.dart';
import 'package:shopping_app_ui/constant/Constants.dart';
import 'package:shopping_app_ui/riverpod_class/checkin_notifier_api.dart';
import 'package:shopping_app_ui/riverpod_class/checkout_notifier_api.dart';
import 'package:shopping_app_ui/screens/authentication/LoginScreen.dart';
import 'package:shopping_app_ui/screens/products/MyAttendanceScreen.dart';
import 'package:shopping_app_ui/screens/products/TicketDetailScreen.dart';
import 'package:shopping_app_ui/util/RemoveGlowEffect.dart';
import 'package:shopping_app_ui/util/Util.dart';
import 'package:shopping_app_ui/util/size_config.dart';
import 'package:shopping_app_ui/widgets/Styles.dart';
import 'package:shopping_app_ui/widgets/TicketsListViewWidget.dart';

//final PagingController<int, ToCheckInOutSupportTicket> _pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: 10,);
    
    class CheckOutTab extends StatelessWidget {
      const CheckOutTab({Key key}) : super(key: key);      

      @override
      Widget build(BuildContext  context){
        return Scaffold(
          //appBar: AppBar(),
          body: SafeArea(
            child: RiverPagedBuilder<int, ToCheckInOutSupportTicket>(
            limit: 20,
            firstPageKey: 0,
            provider: checkOutProvider,
            pullToRefresh: true,    
            enableInfiniteScroll: true, 
            
            itemBuilder: (context, item, index){
              return buildTicketList(item, globalClient, context,index );                                    
            /*return ListTile(
              //leading: Image.network(item.image),
              title: Text(item.ticket_id+"\nmyindex:" +index.toString())
            );*/        
            },

            
            
            pagedBuilder:(_pagingController,builder){
              //controller = PagingController(firstPageKey: , invisibleItemsThreshold: 5); //an attempt to change the threshold @hafizalwi ogos3     
              return PagedListView (
              
                pagingController: _pagingController, 
                builderDelegate: builder,             
                dragStartBehavior: DragStartBehavior.down,
                physics: ClampingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                
                
              );
            }
              
            ),
          ),
        );
      }
    }

    


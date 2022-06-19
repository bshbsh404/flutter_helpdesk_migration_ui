import 'package:flutter/widgets.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:shopping_app_ui/OdooApiCall_DataMapping/ResPartner.dart';
import 'package:shopping_app_ui/OdooApiCall_DataMapping/SupportTicketandResPartner.dart';
import '../OdooApiCall_DataMapping/SupportTicket.dart';
import '../screens/authentication/LoginScreen.dart';

  
//might need to import session id here, to get user id, to get to filter.
class AllTicketsApi {
  
    static Future <List<SupportTicketResPartner>> getAllSupportTickets() async{
    try{
      var fetchTicketData = await globalClient.callKw({ //might need to be changed to widget.client.callkw later because of passing user id session.
        'model': 'website.supportzayd.ticket',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {}, //because by default odoo fields.char return False when its null, therefore we change the default return '' rather than false
          'domain': [['state.name','!=','Staff Closed']],
          'fields':[],
        },
      });
      List listTicket = [];
      listTicket = fetchTicketData; //fetchticketdata(var dynamic) is assigned to List, 
      print ('Get All Support Ticket: '+ fetchTicketData.toString());
      return listTicket.map((json) => SupportTicketResPartner.fromJson(json)).toList();  
      } catch(e){
          
        return Future.error(e.toString());
      }
    }

    static Future<int> countOpenSupportTickets(OdooClient client) async {
    var fetchTicketData = await client.callKw({ //might need to be changed to widget.client.callkw later because of passing user id session.
      'model': 'website.supportzayd.ticket',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {}, //because by default odoo fields.char return False when its null, therefore we change the default return '' rather than false
        'domain': [['state.name','=','Staff Closed']],
        'fields': [
          'ticket_number',
          'state'
        ],
      },
    });
    List listTicket = [];
    listTicket = fetchTicketData; //fetchticketdata(var dynamic) is assigned to List, 
    
    //listTicket =  fetchTicketData.map((json) => ClosedClosedSupportTicket.fromJson(json)).toList(); //convert our json data from odoo to list.
    return listTicket.map((json) => SupportTicket.fromJson(json)).toList().length;
  }

  /*
      static Future<List<SupportTicketResPartner>> getAllSupportTicketsResPartner () async {
        //List combineddata = [];  //create an empty list to add them all later
        var dataSupportTicket = await getAllSupportTickets(); //get value of list1
        var mappingResPartner;

        //now we will find respartner using the value of partner_id from dataSupportTicket
        for(var i=0; i<dataSupportTicket.length; i++){
          var fetchResPartner;

    
          fetchResPartner= await globalClient.callKw({

            'model': 'res.partner',
            'method': 'search_read',
            'args': [],
            'kwargs': {
              'context': {'bin_size': true},
              'domain': [['id','=',int.parse(dataSupportTicket[i].partner_id != null ? dataSupportTicket[i].partner_id : '0')],['id','!=','0']], //if the value is false (because we set that if it will return 'false' in SupportTicket call), then we will return the id as 0. we are taking 0 because in res.partner 0 belongs to no one. Administrator (first id) starts at 1. :) :) :)

              'fields': ['__last_update','partner_longitude', 'partner_latitude'],

            },
          });      
          List listResPartner = [];
          listResPartner = fetchResPartner; 
          print ("our so called res partner"+ fetchResPartner.toString());
          mappingResPartner = listResPartner.map((json) => SupportTicketResPartner.fromJson(json)).toList();
          //dataSupportTicket.addAll(mappingResPartner);      
          
        }
        
        //dataSupportTicket.removeWhere((_, ) => value == null);
        //mappingResPartner.removeWhere((_, value) => value == null);
      

        dataSupportTicket.addAll(mappingResPartner);
        return dataSupportTicket; //now after we added all the datasupportticket mapping hehehehe! we return it      
        //return listpartnerimage.map((json) => SupportTicketResPartner.fromJson(json)).toList(); 
      }*/

    static Future<List<ResPartner>> getResPartner (String respartner_id) async {
    var fetchTicketData = await globalClient.callKw({ //might need to be changed to widget.client.callkw later because of passing user id session.
      'model': 'res.partner',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {}, //because by default odoo fields.char return False when its null, therefore we change the default return '' rather than false
        'domain': [['id','=',respartner_id]],
        'fields': [
          'partner_latitude',
          'partner_longitude'
        ],
      },
    });
    List listTicket = [];
    listTicket = fetchTicketData; //fetchticketdata(var dynamic) is assigned to List, 
    print("lets find out the truth of respartner : "+ fetchTicketData.toString());
    //listTicket =  fetchTicketData.map((json) => ClosedClosedSupportTicket.fromJson(json)).toList(); //convert our json data from odoo to list.
    return listTicket.map((json) => ResPartner.fromJson(json)).toList();
  }
}


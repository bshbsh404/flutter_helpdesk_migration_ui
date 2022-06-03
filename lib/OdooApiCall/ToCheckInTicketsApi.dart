// TODO Implement this library.import 'dart:convert';
import 'package:odoo_rpc/odoo_rpc.dart';
import '../OdooApiCall_DataMapping/ToCheckIn_ToCheckOut_SupportTicket.dart';

  
//might need to import session id here, to get user id, to get to filter.
class ToCheckInTicketsApi {
    static Future <List<ToCheckInOutSupportTicket>> getAllSupportTickets(OdooClient client) async{
    var fetchTicketData = await client.callKw({ //might need to be changed to widget.client.callkw later because of passing user id session.
      'model': 'website.supportzayd.ticket',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {}, //because by default odoo fields.char return False when its null, therefore we change the default return '' rather than false
        'domain': [ ['check_in','=','']],
        'fields': [
          'ticket_number',
          'state'
        ],
      },
    });


    List listTicket = [];
    listTicket = fetchTicketData; //fetchticketdata(var dynamic) is assigned to List, 
    print('\nUser info: \n' +
      fetchTicketData.toString()); //TODO this is for testing only, delete later

    //listTicket =  fetchTicketData.map((json) => UnassignedUnassignedSupportTicket.fromJson(json)).toList(); //convert our json data from odoo to list.
    return listTicket.map((json) => ToCheckInOutSupportTicket.fromJson(json)).toList();
  }

}
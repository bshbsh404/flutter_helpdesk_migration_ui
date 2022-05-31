import 'package:odoo_rpc/odoo_rpc.dart';
import '../OdooApiCall_DataMapping//SupportTicket.dart';

  
//might need to import session id here, to get user id, to get to filter.
class AllTicketsApi {
    static Future <List<SupportTicket>> getSupportTickets(OdooClient client) async{

    await Future.delayed(Duration(milliseconds:400 ));
    var fetchTicketData = await client.callKw({ //might need to be changed to widget.client.callkw later because of passing user id session.
      'model': 'website.supportzayd.ticket',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {}, //because by default odoo fields.char return False when its null, therefore we change the default return '' rather than false
        'domain': [['state.name','!=','Staff Closed']],
        'fields':[],
      },
    });
    //setState(() {
    //  SupportTicketList =
    //      fetchTicketData; //test is a json data too //is equivalent to final List users = json.decode(response.body);
    //  //c 

    List listTicket = [];
    listTicket = fetchTicketData; //fetchticketdata(var dynamic) is assigned to List, 

    //listTicket =  fetchTicketData.map((json) => SupportTicket.fromJson(json)).toList(); //convert our json data from odoo to list.    
    return listTicket.map((json) => SupportTicket.fromJson(json)).toList();
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



}
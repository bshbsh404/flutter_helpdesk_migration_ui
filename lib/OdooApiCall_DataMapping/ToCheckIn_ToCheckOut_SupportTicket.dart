//we call the class name tocheckinout because this is the base for api call including checkin and checkout call.

class ToCheckInOutSupportTicket {
  final String ticket_number;
  final String status;
  final String check_in;
  final String check_out;

  const ToCheckInOutSupportTicket({this.ticket_number, this.status, this.check_in, this.check_out});

  static ToCheckInOutSupportTicket fromJson(Map<String, dynamic> json) => ToCheckInOutSupportTicket(
    // if it returns false, because idontknow, odoo return false for null in JSON, 
    //then set it as ' ', otherwise, set it as its normal value, which is usually String

      //status: json['status'][1] == 'Staff Unassigned' ?
      status :json['state'][1].toString(),    
      ticket_number : json['ticket_number'] == false ? json['ticket_number'] = '' : json['ticket_number'].toString(),
      check_in : json['check_in'] == false ? json['check_in'] = '' : json['check_in'].toString(),
      check_out : json['check_out'] == false ? json['check_out'] = '' : json['check_out'].toString(),
  );   
}
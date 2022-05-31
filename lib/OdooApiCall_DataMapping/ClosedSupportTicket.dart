class ClosedSupportTicket {
  final String ticket_number;
  final String status;

  const ClosedSupportTicket({required this.ticket_number, required this.status});

  static ClosedSupportTicket fromJson(Map<String, dynamic> json) => ClosedSupportTicket(
    // if it returns false, because idontknow, odoo return false for null in JSON, 
    //then set it as ' ', otherwise, set it as its normal value, which is usually String

      //status: json['status'][1] == 'Staff Closed' ?
      status :json['state'][1].toString(),    
      ticket_number : json['ticket_number'] == false ? json['ticket_number'] = '' : json['ticket_number'].toString(),
  );   
}
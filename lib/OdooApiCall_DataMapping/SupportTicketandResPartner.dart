class SupportTicketResPartner{
  final String ticket_number;
  final String ticket_id;
  final String assigned_user;
  final String check_in;
  final String check_out;
  final String check_in_address;
  final String check_out_address;
  final String subject;
  final String created_date;
  final String rating;
  final String customer_name;
  final String customer_id;
  final String equipment_location;
  final String last_update;
  final String image_small;
  final String equipment_user;

  
  const SupportTicketResPartner({
  
    this.ticket_number, this.ticket_id, this.assigned_user, 
    this.check_in, this.check_out, this.check_in_address, this.check_out_address,
    this.subject, this.created_date, this.rating, this.customer_name, this.customer_id,
    this.equipment_location, this.last_update,this.image_small,this.equipment_user

  });
  static SupportTicketResPartner fromJson(Map<String, dynamic> json) => SupportTicketResPartner(
    // if it returns false, because idontknow, odoo return false for null in JSON, 
    //then set it as ' ', otherwise, set it as its normal value, which is usually String  

    ticket_number : json['ticket_number'] == false ? json['ticket_number'] = '' : json['ticket_number'].toString(), 
    ticket_id : json['id'].toString(),
    assigned_user: json['user_id'] == false ? json['user_id'] = 'false' : json['user_id'].toString(),
    check_in: json['check_in'].toString(),
    check_out: json['check_out'].toString(),
    check_in_address: json['check_in_address'].toString(),
    check_out_address: json['check_out_address'].toString(),
    created_date: json['create_date'] == false ? json['create_date'] = '' : json['create_date'].toString(),
    subject: json['subject'] == false ? json['subject'] = '' : json['subject'].toString(),
    rating: json['rating'] == null ? json['rating'] = '0' : json['rating'].toString(),
    customer_id: json['partner_id'] == false || json['partner_id'] == 'false' || json['partner_id'] == null  ? json['partner_id'] = 'false' : json['partner_id'][0].toString(),
    customer_name: json['partner_id'] == false || json['partner_id'] == 'false' || json['partner_id'] == 'false' ? json['partner_id'] = 'false' : json['partner_id'][1].toString(),    
    equipment_location: json['equipment_location'] == null ? json['equipment_location'] = 'Not Defined' : json['equipment_location'].toString(),
    last_update: json['__last_update'] == false ? json['__last_update'] = '' : json['__last_update'].toString(),
    image_small: json['image_small'] == false ? json['image_small'] = '' : json ['image_small'].toString(),
    equipment_user: json['user'] == false ? json['user'] = 'no data' : json['user'].toString(),
  );
}
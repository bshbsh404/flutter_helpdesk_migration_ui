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
  final String partner_name;
  final String partner_id;
  final String equipment_location;
  final String equipment_user;
  final String reported_by;
  final String contact_num;
  final String email;
  final String department;
  final String address;
  final String category_name;
  final String subcategory_name;
  final String problem_name;
  final String open_case;
  final String itemname;
  
  const SupportTicketResPartner({
  
    this.ticket_number, this.ticket_id, this.assigned_user, 
    this.check_in, this.check_out, this.check_in_address, this.check_out_address,
    this.subject, this.created_date, this.rating, this.partner_name, this.partner_id,
    this.equipment_location, this.equipment_user, this.reported_by,this.contact_num,
    this.email, this.department,this.address,
    this.category_name, this.subcategory_name, this.problem_name,
    this.open_case, this.itemname

  });
  static SupportTicketResPartner fromJson(Map<String, dynamic> json) => SupportTicketResPartner(
    // if it returns false, because odoo is weird in handling json, odoo return false for null in JSON, 
    //then set it as ' ', otherwise, set it as its normal value, which is usually String  
    ticket_number : json['ticket_number'] == false ? json['ticket_number'] = '' : json['ticket_number'].toString(), 
    ticket_id : json['id'].toString(),
    assigned_user: json['user_id'] == false ? json['user_id'] = 'false' : json['user_id'].toString(),
    check_in: json['check_in'] == false ? json['check_in'] = '' : json['check_in'],
    check_out: json['check_out'] == false ? json['check_out'] = '' : json['check_out'],
    check_in_address: json['check_in_address'] == false ? json ['check_in_address'] = '' : json['check_in_address'].toString(),
    check_out_address: json['check_out_address'] == false ? json ['check_out_address'] = '' : json['check_out_address'].toString(),
    created_date: json['create_date'] == false ? json['create_date'] = '' : json['create_date'].toString(),
    subject: json['subject'] == false ? json['subject'] = '' : json['subject'].toString(),
    rating: json['rating'] == null ? json['rating'] = '0' : json['rating'].toString(),
    partner_id: json['partner_id'] == false || json['partner_id'] == null  ? json['partner_id'] = null : json['partner_id'][0].toString(),
    partner_name: json['partner_id'] == false || json['partner_id'] == null ? json['partner_id'] = null : json['partner_id'][1].toString(),    
    equipment_location: json['equipment_location'] == false ? json['equipment_location'] = '' : json['equipment_location'].toString(),
    equipment_user: json['user'] == false ? json['user'] = '' : json['user'].toString(),
    reported_by: json['person_name'] == false ? json['person_name'] = '' : json['person_name'].toString(),
    contact_num: json['contact_num'] == false ? json['contact_num'] = '' : json['contact_num'].toString(),
    email: json['email'] == false ? json['email'] = '' : json['email'].toString(),
    department: json['department'] == false ? json['department'] = '' : json['department'].toString(),
    address: json['address'] == false ? json['address'] = '' : json['address'].toString(),
    category_name: json['category'] == false || json['category'] == null? json['category'] = '' : json['category'][1].toString(),
    subcategory_name: json['sub_category_id'] == false || json['sub_category_id'] == null? json['sub_category_id'] = '' : json['sub_category_id'][1].toString(),
    problem_name: json['problem'] == false || json['problem'] == null? json['problem'] = '' : json['problem'][1].toString(),
    open_case : json['open_case'] == false || json ['open_case'] == null ? json ['open_case'] = '' : json ['open_case'].toString(),
    itemname : json['item'] == false || json ['item'] == null ? json ['item'] = null : json ['item'][1].toString(),
  );
}
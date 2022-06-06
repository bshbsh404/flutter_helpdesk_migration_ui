class ResPartner {
  final String last_update;
  final num partner_latitude;
  final num partner_longitude;
  
  const ResPartner({
    this.last_update,this.partner_latitude, this.partner_longitude
  });
  static ResPartner fromJson(Map<String, dynamic> json) => ResPartner(
    // if it returns false, because idontknow, odoo return false for null in JSON, 
    //then set it as ' ', otherwise, set it as its normal value, which is usually String  
    last_update: json['__last_update'] == false ? json['__last_update'] = '' : json['__last_update'].toString(),
    partner_latitude: json['partner_latitude'] == null ? json ['partner_latitude'] = null : json['partner_latitude'], 
    partner_longitude: json['partner_longitude'] == null ? json ['partner_longitude'] = null : json['partner_longitude'],
  );
}
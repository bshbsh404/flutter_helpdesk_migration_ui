class ResPartner {

  final String last_update;
  final String image_small;
  
  const ResPartner({
    this.last_update, this.image_small
  });
  static ResPartner fromJson(Map<String, dynamic> json) => ResPartner(
    // if it returns false, because idontknow, odoo return false for null in JSON, 
    //then set it as ' ', otherwise, set it as its normal value, which is usually String  
    last_update: json['__last_update'] == false ? json['__last_update'] = '' : json['__last_update'].toString(),
    image_small: json['image_small'] == false ? json['image_small'] = '' : json ['image_small'].toString(),
  );
}
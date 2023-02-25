import 'package:cloud_firestore/cloud_firestore.dart';
class Vendor {
 Vendor({
  this.NIFnumber,
  this.approved,
  this.businessName,
  this.city,
  this.country,
  this.email,
  this.landmark,
  this.mobile,
  this.pinCode,
  this.shopImage,
  this.state,
  this.taxResigtered,
  this.time,
  this.uid
 });

  Vendor.fromJson(Map<String, Object?> json)
    : this(
        NIFnumber: json['NIFnumber']!as String,
        approved: json['approved']! as bool,
        businessName: json['businessName']! as String,
        city: json['city']! as String,
        country: json['country']! as String,
        email: json['email']! as String,
        landmark: json['landmark']! as String,
        
        mobile: json['mobile']! as String,
        pinCode: json['pinCode']! as String,
        shopImage: json['shopImage']! as String,
        state: json['state']! as String,
        taxResigtered: json['taxResigtered']! as String,
        uid: json['uid']! as String,
        time: json['time']! as Timestamp,
      );

  final bool? approved;
  final String? businessName;
  final String? city;
  final String? country;
  final String? email;
  final String? landmark;
  
  final String? mobile;
  final String? pinCode;
  final String? shopImage;
  final String? state;
  final String? uid;
  final String? taxResigtered;
  final Timestamp? time;
  final String? NIFnumber;


  Map<String, Object?> toJson() {
    return {
      'NIFnumber':NIFnumber,
      'approved':approved,
      'businessName':businessName,
      'city':city,
      'country':country,
      'email':email,
      'landmark':landmark,
      
      'mobile':mobile,
      'pinCode':pinCode,
      'shopImage':shopImage,
      'state':state,
      'taxResigtered':taxResigtered,
      'time':time,
      'uid':uid
    };
  }
}
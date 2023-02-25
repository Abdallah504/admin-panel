import 'package:flutter/material.dart';
import 'package:talabya_admin_panel/widgets/Vendors_List.dart';

class VendorsScreen extends StatelessWidget {
  static const String id = 'Vendors';
  const VendorsScreen({Key? key}) : super(key: key);

  @override
  Widget _rowHeader( {required int flex, required String text}){
    return Expanded(flex: flex,child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade700),
        color: Colors.grey.shade500
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text,style: TextStyle(fontWeight: FontWeight.bold),),
      ),
    ));
  }
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           const Text(
            'Registered Vendors',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
          Row(
            children: [
              _rowHeader(
                flex:1,
                 text:'LOGO'
                 ),
                 _rowHeader(
                flex:3,
                 text:'BUSINESS NAME'
                 ),
                 _rowHeader(
                flex:2,
                 text:'CITY'
                 ),
                 _rowHeader(
                flex:1,
                 text:'ACTION'
                 ),
                 _rowHeader(
                flex:1,
                 text:'VIEW MORE'
                 ),
            ],
          ),
          VendorsList()
        ],
      ),
    );
  }
}
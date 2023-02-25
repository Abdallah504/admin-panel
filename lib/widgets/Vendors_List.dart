import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:talabya_admin_panel/firebase_services.dart';
import 'package:talabya_admin_panel/model/vendor_model.dart';

class VendorsList extends StatelessWidget {
  const VendorsList({Key? key}) : super(key: key);

  @override
  Widget _vendorData( { int? flex,  String? text,  Widget? widget}){
    return  Expanded(
      flex: flex!,
      child: Container(
        height: 66,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          
        ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:widget??Text(text!),
          ),
        
      ),
    );
    
  }
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return StreamBuilder<QuerySnapshot>(
      stream: _services.vendor.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator();
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.size,
          itemBuilder: (context, index) {
            Vendor vendor = Vendor.fromJson(snapshot.data!.docs[index].data() as Map<String,dynamic>);
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _vendorData(flex: 1, widget: Container(
                  height: 50,
                  width: 50,
                  child: Image.network(vendor.shopImage!)),
                  ),
                  _vendorData(flex: 3, text: vendor.businessName
                  ),
                  _vendorData(flex: 2, text: vendor.city
                  ),
                  _vendorData(flex: 2, text: vendor.state
                  ),
                  _vendorData(flex: 2, widget: vendor.approved==true ? ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                    onPressed:(){
                      EasyLoading.show();
                      _services.updateData(
                          data: {
                            'approved': false
                          },
                          docName: vendor.uid,
                          reference: _services.vendor
                        ).then((value) {
                          EasyLoading.dismiss();
                        });
                    } , child: Text('Reject',)
                    ):ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                      onPressed:(){
                        EasyLoading.show();
                        _services.updateData(
                          data: {
                            'approved': true
                          },
                          docName: vendor.uid,
                          reference: _services.vendor
                        ).then((value) {
                          EasyLoading.dismiss();
                        });
                      } ,
                       child: Text('Approve'))
                  ),
                  _vendorData(flex: 2, widget: ElevatedButton(
                    onPressed: (){

                    },
                     child: Text('View More'))
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
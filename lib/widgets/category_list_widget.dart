import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talabya_admin_panel/firebase_services.dart';

class CategoriesListWidget extends StatelessWidget {
  final CollectionReference? reference;
  CategoriesListWidget({this.reference,Key? key}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    FirebaseServices _service = FirebaseServices();
    Widget CategoryList(data){
    return Card(
              color: Colors.grey.shade400,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 20,),
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.network(data['image'])),
                    Text(reference == _service.categories ? data['catName']:data['SubCatName']
                    
                    ,style: TextStyle(color: Colors.black),)
                  ]),
              ),
            );
  }
    return StreamBuilder<QuerySnapshot>(
      stream: reference!.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator();
        }

        if(snapshot.data!.size ==0){
          return const Text('No Categories Added');
        }

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6, crossAxisSpacing: 3,mainAxisSpacing:3 ),
          itemCount: snapshot.data!.size,
           itemBuilder:(context,index){
            var data = snapshot.data!.docs[index];
            return  CategoryList(data);
           } );
      },
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talabya_admin_panel/firebase_services.dart';

class MainCategoriesListWidget extends StatefulWidget {
  MainCategoriesListWidget({Key? key}) : super(key: key);

  @override
  State<MainCategoriesListWidget> createState() => _MainCategoriesListWidgetState();
}

class _MainCategoriesListWidgetState extends State<MainCategoriesListWidget> {
  FirebaseServices _services = FirebaseServices();
   QuerySnapshot? snapshot;
   Object? _selectedValue;
  Widget CategoryList(data){
    return Card(
              color: Colors.grey.shade400,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text(data['mainCategory'],style: TextStyle(color: Colors.black),)),
              ),
            );
  }

    Widget _dropDownButton(){
    return DropdownButton(
      
          value: _selectedValue,
          hint: const Text('Select Category') ,
          items: snapshot!.docs.map((e) {
            return DropdownMenuItem(
              value: e['catName'],
              child: Text(e['catName']),
              );
          }).toList(),
           onChanged: (selectedCat){
            _selectedValue = selectedCat;
            
           }
           );
  }
  @override
  void initState(){
    getCatList();
    super.initState();
  }
  getCatList(){
   return _services.categories
    .get()
    .then((QuerySnapshot querySnapshot) {
        setState(() {
          snapshot = querySnapshot;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        snapshot == null?Text('Loading.....'):
        _dropDownButton(),
        const SizedBox(height: 10,),
        StreamBuilder<QuerySnapshot>(
          stream: _services.mainCat.where('category',isEqualTo: _selectedValue).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return LinearProgressIndicator();
            }

            if(snapshot.data!.size ==0){
              return const Text('No Main Categories Added');
            }

            return GridView.builder(

              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6, crossAxisSpacing: 3,mainAxisSpacing:3,childAspectRatio: 6/2 ),
              itemCount: snapshot.data!.size,
               itemBuilder:(context,index){
                var data = snapshot.data!.docs[index];
                return  CategoryList(data);
               } );
          },
        ),
      ],
    );
  }
}
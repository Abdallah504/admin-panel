
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:talabya_admin_panel/firebase_services.dart';
import 'package:talabya_admin_panel/widgets/main_categories_list_widget.dart';

class MainCategoryScreen extends StatefulWidget {
  static const String id = 'main-category';
  const MainCategoryScreen({Key? key}) : super(key: key);

  @override
  State<MainCategoryScreen> createState() => _MainCategoryScreenState();
}

class _MainCategoryScreenState extends State<MainCategoryScreen> {
  final FirebaseServices _services = FirebaseServices();
  final TextEditingController _mainCat= TextEditingController();
  bool _noCategorySelected = false;
  QuerySnapshot? snapshot;
  final _formKey =GlobalKey<FormState>();
  Object? _selectedValue;
  Widget _dropDownButton(){
    return FutureBuilder<QuerySnapshot>(
      future: _services.categories.get(),
      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
        if(snapshot.hasError){
          return Text('Something went wrong');
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return Text('Loading...');
        }
        return DropdownButton(
          value: _selectedValue,
          hint: Text('Select Category'),
          items: snapshot.data!.docs.map((e)  {
          return DropdownMenuItem<String>(
            value: e['catName'],
            child: Text(e['catName']),
          );
          }).toList(),
           onChanged: (selectedCat){
            setState(() {
              _selectedValue = selectedCat;
            });
           }
           
           );
      }
      );
  }
  clear(){
    setState(() {
      _selectedValue = null;
      _mainCat.clear();
    });
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
    return  Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30,8,8,8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Main Category',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
            ),
            const Divider(color: Colors.grey,),
            snapshot==null ?const Text('Loading...'):
            _dropDownButton(),
            const SizedBox(height: 8,),
            if(_noCategorySelected == true)
            Text('NO Category Selected', style: TextStyle(color: Colors.red),),
    
            SizedBox(
              width: 200,
              child: TextField(
                controller: _mainCat,
                decoration: const InputDecoration(
                  label: Text("Enter Category Name"),
                  contentPadding: EdgeInsets.zero
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Row(
              children: [
                TextButton(
              onPressed: clear,
               child: Text("Cancel",style: TextStyle(color: Theme.of(context).primaryColor),),
               style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                side: MaterialStateProperty.all( BorderSide(color: Theme.of(context).primaryColor))
    
               ),
               ),
               const SizedBox(width: 10,),
               ElevatedButton(
              onPressed: (){
                if(_selectedValue == null){
                  setState(() {
                  _noCategorySelected == true;
                  });
                  return;
                }
                if(_formKey.currentState!.validate()){
                  EasyLoading.show();
                  _services.saveCategory(
                    data: {
                      'category':_selectedValue,
                      'mainCategory':_mainCat.text,
                      'approved':true
                    },
                    reference: _services.mainCat,
                    docName: _mainCat.text
                  ).then((value) {
                    clear();
                    EasyLoading.dismiss();
                  });
                }
              },
               child: const Text(" Save "),
               
               )
              ],
            ),
            const Divider(color: Colors.grey,),
            Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        child: const Text("Main Category List", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
      ),
      const SizedBox(height: 10,),
      MainCategoriesListWidget()
          ],
        ),
      ),
    );
  }
}
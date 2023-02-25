
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:talabya_admin_panel/firebase_services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:talabya_admin_panel/widgets/category_list_widget.dart';

class SubCategoryScreen extends StatefulWidget {
  static const String id = 'sub-category';
  const SubCategoryScreen({Key? key}) : super(key: key);

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  final FirebaseServices _service = FirebaseServices();
  final TextEditingController _subCatName = TextEditingController();
  dynamic image;
  String? fileName;
  bool _noCategorySelected = false;
  Object? _selectedValue;
  final _formKey =GlobalKey<FormState>();
  QuerySnapshot? snapshot;
  Widget _dropDownButton(){
    
      
        return DropdownButton(
          value: _selectedValue,
          hint: const Text('Select Main Category'),
          items: snapshot!.docs.map((e)  {
          return DropdownMenuItem<String>(
            value: e['mainCategory'],
            child: Text(e['mainCategory']),
          );
          }).toList(),
           onChanged: (selectedCat){
            setState(() {
              _selectedValue = selectedCat;
            });
           }
           
           );
      
  }
  pickImage() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false
    );
    if(result !=null){
      setState(() {
        image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }else{
      print("cancelled or failed");
    }

  }
  saveImageToDB() async{
    EasyLoading.show();
    var ref =  firebase_storage.FirebaseStorage.instance.ref('SubCategoryImage/$fileName');
    try{
      await ref.putData(image); // now image will upload to firebase
      // now we have to get the download link of that image to save it in firebase
      String downloadURL = await ref.getDownloadURL().then((value) {
        if(value.isNotEmpty){
          
          _service.saveCategory(
            data: {
            'SubCatName':_subCatName.text,
            'mainCategory':_selectedValue,
            'image':value,
            'active':true
          },
          docName: _subCatName.text,
          reference: _service.subCat
          ).then((value) {
            clear();
            EasyLoading.dismiss();
          });
        }
        return value;
      });
      

    } on FirebaseException catch(e){
      clear();
      EasyLoading.dismiss();
      print(e.toString());
    }
  }
  clear(){
    setState(() {
      _subCatName.clear();
      image = null;
    });
  }
  @override
  void initState(){
    getMainCatList();
    super.initState();
  }
  getMainCatList(){
   return _service.mainCat
    .get()
    .then((QuerySnapshot querySnapshot) {
        setState(() {
          snapshot = querySnapshot;
        });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Sub Category',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
          ),
          Divider(color: Colors.grey,),
          Row(
            children: [
              const SizedBox(width: 10,),
            Column(
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade500,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade800)
                  ),
                  child:  Center(child:image==null ?const Text("Sub Category image"):Image.memory(image)),
                ),
                const SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: pickImage,
                   child: const Text("Upload image")),
            ],
            ),
            const SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                snapshot==null ?const Text('Loading...'):
              _dropDownButton(),
              const SizedBox(height: 8,),
              if(_noCategorySelected == true)
              Text('NO Main Category Selected', style: TextStyle(color: Colors.red),),
      
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _subCatName,
                  decoration: const InputDecoration(
                    label: Text("Enter Sub Category Name"),
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
                 if(image!= null)
                 ElevatedButton(
                onPressed: (){
                  if(_selectedValue == null){
                    setState(() {
                    _noCategorySelected == true;
                    });
                    return;
                  }
                  if(_formKey.currentState!.validate()){
                    saveImageToDB();
                    
                  }
                },
                 child: const Text(" Save "),
                 
                 )
                ],
              ),
              ],
            )
          
        ],
      ),
      const Divider(color: Colors.grey,),
      Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        child: const Text("Sub Category List", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
      ),
      const SizedBox(height: 10,),
        CategoriesListWidget(
          reference: _service.subCat,
        ),
      ]
      ),
    );
  }
}
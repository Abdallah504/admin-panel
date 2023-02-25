
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:talabya_admin_panel/firebase_services.dart';
import 'package:talabya_admin_panel/widgets/category_list_widget.dart';
import 'package:talabya_admin_panel/widgets/main_categories_list_widget.dart';

class CategoryScreen extends StatefulWidget {
  static const String id = 'category';
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final FirebaseServices _service = FirebaseServices();
  final TextEditingController _catName = TextEditingController();
  dynamic image;
  String? fileName;
  
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
    var ref =  firebase_storage.FirebaseStorage.instance.ref('categoryImage/$fileName');
    try{
      await ref.putData(image); // now image will upload to firebase
      // now we have to get the download link of that image to save it in firebase
      String downloadURL = await ref.getDownloadURL().then((value) {
        if(value.isNotEmpty){
          
          _service.saveCategory(
            data: {
            'catName':_catName.text,
            'image':value,
            'active':true
          },
          docName: _catName.text,
          reference: _service.categories
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
      _catName.clear();
      image = null;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: const Text(
            'Category List',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 26,
            ),
          ),
        ),
      const Divider(
        color: Colors.grey,
      ),
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
                child:  Center(child:image==null ?const Text("Category image"):Image.memory(image)),
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                onPressed: pickImage,
                 child: const Text("Upload image")),
            ],
          ),
          const SizedBox(width: 20,),
          Container(
            width: 200,
            child: TextField(
              controller: _catName,
              decoration: const InputDecoration(
                label: Text("Enter Category Name"),
                contentPadding: EdgeInsets.zero
              ),
            ),
          ),
          const SizedBox(width: 10,),
          TextButton(
            onPressed: clear,
             child: Text("Cancel",style: TextStyle(color: Theme.of(context).primaryColor),),
             style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              side: MaterialStateProperty.all( BorderSide(color: Theme.of(context).primaryColor))

             ),
             ),
             const SizedBox(width: 10,),
            image == null ? Container() : ElevatedButton(
            onPressed: saveImageToDB,
             child: const Text(" Save "),
             
             )
        ],
      ),
      const Divider(
        color: Colors.grey,
      ),
      Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        child: const Text("Category List", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
      ),
      const SizedBox(height: 10,),
      CategoriesListWidget(
        reference: _service.categories,
        
      ),
      ],
    );
  }
}
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:talabya_admin_panel/firebase_configurations.dart';
import 'package:talabya_admin_panel/screens/category_screen.dart';
import 'package:talabya_admin_panel/screens/dashboard_screen.dart';
import 'package:talabya_admin_panel/screens/main_category_screen.dart';
import 'package:talabya_admin_panel/screens/sub_category_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:talabya_admin_panel/vendors_screen.dart';
final FirebaseConfigurations _configurations = FirebaseConfigurations();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: _configurations.apiKey,
       appId: _configurations.appId, 
       messagingSenderId: _configurations.messagingSenderId,
        projectId: _configurations.projectId,
        storageBucket: "storageBuckett")
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'talabya admin panel',
      theme: ThemeData(
        
        primarySwatch: Colors.indigo,
      ),
      home:  const SideMenu(),
      builder: EasyLoading.init(),
    );
  }
}
class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  Widget _selectedScreen = DashBoardScreen();
  screenSelector(item){
    switch(item.route){
      case DashBoardScreen.id:
      setState(() {
        _selectedScreen = const DashBoardScreen();
      });
      break;
      case CategoryScreen.id:
      setState(() {
        _selectedScreen = const CategoryScreen();
      });
      break;
      case MainCategoryScreen.id:
      setState(() {
        _selectedScreen = const MainCategoryScreen();
      });
      break;
      case SubCategoryScreen.id:
      setState(() {
        _selectedScreen = const SubCategoryScreen();
      });
      break;
      case VendorsScreen.id:
      setState(() {
        _selectedScreen = const VendorsScreen();
      });
      break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('talabya admin panel'),
      ),
      sideBar: SideBar(
        items: const [
          AdminMenuItem(
            title: 'Dashboard',
            route: DashBoardScreen.id,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Categories',
            icon: Icons.category,
            children: [
              AdminMenuItem(
                title: 'category',
                route: CategoryScreen.id,
              ),
              AdminMenuItem(
                title: 'main category', 
                route: MainCategoryScreen.id,
              ),
             AdminMenuItem(
                title: 'sub category', 
                route: SubCategoryScreen.id,
              ),
            ],
          ),
          AdminMenuItem(
            title: 'Vendors',
            route: VendorsScreen.id,
            icon: Icons.business,
          ),
        ],
        selectedRoute: '/',
        onSelected: (item) {
          screenSelector(item);
        },
        header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child:  Center(
            child: Text(
              DateTimeFormat.format(DateTime.now(), format: AmericanDateFormats.dayOfWeek),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body:  SingleChildScrollView(
        child: _selectedScreen,
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kisanseva/other.dart';
import 'package:kisanseva/screen/loginPage.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LangProvider(),
      builder: (context, _) {
        return MaterialApp(
          home: const Login(),
          theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: Colors.green,
          appBarTheme: AppBarTheme(
            color: Colors.white,
            elevation: 0.0,
            iconTheme: const IconThemeData(color: Colors.black), 
            toolbarTextStyle: Theme.of(context).textTheme.bodyText2, 
            titleTextStyle: Theme.of(context).textTheme.headline6,
          ),
          drawerTheme: const DrawerThemeData(
            backgroundColor: Colors.green,
          ), 
          textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.black),
          textTheme: const TextTheme(
            bodyText1: TextStyle(),
            bodyText2: TextStyle(),
          ).apply(
            bodyColor: Colors.black,
            displayColor: Colors.white
          ),
          scaffoldBackgroundColor: Colors.white,
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: MaterialStateProperty.all(Colors.greenAccent),
          ),
          
        ),
        );
      }
    );
  }
}
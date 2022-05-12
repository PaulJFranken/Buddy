import 'package:buddy/screens/home.dart';
import 'package:buddy/screens/sign_in.dart';
import 'package:buddy/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: AuthMethods().getCurrentUseres(),
        builder: (context, AsyncSnapshot<dynamic> snapshot){
        if(snapshot.hasData){
          return Home();
        }else {
          return SignIn();
        }
      },
      ),
    );
  }
}

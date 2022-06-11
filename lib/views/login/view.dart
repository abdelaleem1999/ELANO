import 'package:bonus/views/login/components/header.dart';
import 'package:bonus/views/login/components/loginBlock.dart';
import 'package:bonus/views/login/widgets/loginNavigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bonus/views/login/cubits/LoginController.dart';
class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  bool isPasswordShow = false;


  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) =>LoginController() ,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [


            LoginHeader(),
            LoginBlock(),
            LoginNavigator(),

          ],
        ),
      ),
    );
  }
}


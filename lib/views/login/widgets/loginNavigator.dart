import 'package:bonus/views/login/widgets/signButton.dart';
import 'package:bonus/views/signup/view.dart';
import 'package:flutter/material.dart';

class LoginNavigator extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpView()));
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0, left: 10, top: 10),
        child: SignButton(name: "New User",
          c: Color(0xffbf6475),),
      ),
    );

  }
}

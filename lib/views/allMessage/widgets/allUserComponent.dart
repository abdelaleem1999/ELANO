import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../const/shared_helper.dart';

class AllUserComponent extends StatefulWidget {
  AllUserComponent({
    this.name,
    this.message,
    this.Navigator,
    this.owner


  });
final String? name;
final String? message;
final Widget? Navigator;
final num? owner;

  @override
  _AllUserComponentState createState() => _AllUserComponentState();
}

class _AllUserComponentState extends State<AllUserComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: (){
            if(widget.message==SharedHelper.getEmail){
              Fluttertoast.showToast(

                  msg: "This your accaunt ^__^",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.indigo,
                  textColor: Colors.white,
                  fontSize: 17.0
              );

              return  ;


            }else{
              Navigator.push(context, MaterialPageRoute(builder: (context)=>widget.Navigator!));

            }
          },
          child: Container(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child:ClipRRect(
                          borderRadius: BorderRadius.circular(29), // Image border
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(40), // Image radius
                            child: Image.asset(
                                'assets/istockphoto-1214841186-1024x1024.jpg'
                                , fit: BoxFit.cover),
                          ),
                        )

                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name!,
                        style: TextStyle(
                            color: Color(0xF8010811),
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                      ),
                      widget.owner== null?
                          Text('')
                     : widget.owner==1 ?
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(FontAwesomeIcons.solidCheckCircle,
                        color: Colors.indigo,
                        size: 17,),
                      )
                          :Text('')
                    ],
                  ),
                  Spacer(),
                ],
              )),
        ),
        Divider(),
      ],
    );

  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bonus/const/shared_helper.dart';
import 'package:bonus/views/login/view.dart';
import 'package:bonus/views/messageUnread/cubits/Cubits.dart';
import 'package:bonus/views/tapBar/cubit.dart';
import 'package:bonus/views/tapBar/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  num m = 0;

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      updateUser("online");
      print('888888888888888888888888888888');
    } else {
      updateUser("offline");
      print('777777777777777777777777777777');
    }
  }

  updateUser(status) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(SharedHelper.getEmail)
        .update({'status': status});
  }

  void initState() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(SharedHelper.getEmail)
        .update({'status': 'online'});
    // TODO: implement initState
    WidgetsBinding.instance!.addObserver(this);
    print('6666666666666666666666666666666666666666666666666');
  }

  void dispose() {
    scaffoldKey.currentState!.dispose();

    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeLayoutCubit(),
      child: BlocBuilder<HomeLayoutCubit, HomeLayoutStates>(
        builder: (context, state) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
                key: scaffoldKey,
                backgroundColor: Colors.white,
                appBar: AppBar(
                  leadingWidth: 14,
                  title: Text(
                    "ELANO",
                    style: TextStyle(
                      fontSize: 25,
                      color: Color(0xff2472e8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {},
                        child: InkWell(
                          onTap: () async {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(SharedHelper.getEmail)
                                .update({'status': 'offline', 'token': ''});
                            SharedHelper.setEmail('');
                            SharedHelper.setName('');
                            SharedHelper.setTokenOFNot('null');
                            SharedHelper.setConter(0);
                            ConterController.of(context)..conterMethod(0);

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginView()));
                          },
                          child: Column(
                            children: [
                              Icon(
                                FontAwesomeIcons.signOutAlt,
                                color: Color(0xff2472e8),
                              ),
                              Text(
                                'LogOut',
                                style: TextStyle(
                                    color: Color(0xff2472e8), fontSize: 10),
                              ),
                            ],
                          ),
                        )),
                    //signOutAlt    alignJustify
                  ],
                  bottom: PreferredSize(
                    preferredSize: Size(200, 70),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: TabBar(
                            onTap: HomeLayoutCubit.of(context).changeIndex,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorColor: Colors.transparent,
                            labelColor: Colors.white,
                            isScrollable: true,
                            unselectedLabelColor: Colors.black,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Color(0xff1354ba),
                            ),
                            tabs: [
                              Container(
                                width: MediaQuery.of(context).size.width / 2.5,
                                child: Center(
                                  child: Text(
                                    "All People",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              // Text("Important",
                              //   style: TextStyle(
                              //     fontSize: 17,
                              //     fontWeight: FontWeight.bold,
                              //   ),),
                              Container(
                                width: MediaQuery.of(context).size.width / 2.5,
                                // اعمل كيوبت عشان يخزن عدد الرساي عشان كل امام تتغير تسمع ع طول
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Message",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(SharedHelper.getEmail)
                                                .collection('messages')
                                                .snapshots(),
                                            builder: (context,
                                                AsyncSnapshot snapshot) {
                                              if (snapshot.hasData) {
                                                if (snapshot.data.docs.length <
                                                    1) {
                                                  return Text('');
                                                } else {
                                                  m = 0;
                                                  for (int i = 0;
                                                      i <=
                                                          snapshot.data.docs
                                                                  .length -
                                                              1;
                                                      i++) {
                                                    var AllMessageUnread =
                                                        snapshot.data.docs[i]
                                                            ['seen'];
                                                    print(
                                                        'zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz');

                                                    m = m + AllMessageUnread;
                                                    print(m.toString());
                                                    print(
                                                        'zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz');
                                                  }

                                                  return m == 0
                                                      ? Text('')
                                                      : Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: HomeLayoutCubit.of(context).currentIndex ==
                                                                          0
                                                                      ? Color(
                                                                          0xffbf6475)
                                                                      : Color(
                                                                          0xFFDFE2E8),
                                                                  border: Border
                                                                      .all(
                                                                    width: 5,
                                                                    color: HomeLayoutCubit.of(context).currentIndex ==
                                                                            0
                                                                        ? Color(
                                                                            0xffbf6475)
                                                                        : Color(
                                                                            0xFFDFE2E8),
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15)),
                                                          child: Text(
                                                            m.toString(),
                                                            style: TextStyle(
                                                                color: HomeLayoutCubit.of(context)
                                                                            .currentIndex ==
                                                                        0
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black),
                                                          ),
                                                        );
                                                }
                                              }
                                              return Text('');
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Text("Read",
                              //   style: TextStyle(
                              //     fontSize: 17,
                              //     fontWeight: FontWeight.bold,
                              //   ),),
                            ],
                          ),
                        ),
                        SizedBox(height: 10)
                      ],
                    ),
                  ),
                  elevation: 0.0,
                  backgroundColor: Colors.white,
                ),
                body: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 0, top: 10),
                  child: HomeLayoutCubit.of(context).getCurrentView,
                )),
          );
        },
      ),
    );
  }
}

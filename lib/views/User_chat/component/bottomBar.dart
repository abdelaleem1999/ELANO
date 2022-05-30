import 'dart:convert';

import 'package:http/http.dart' as http;

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:bonus/views/User_chat/component/locationMaps.dart';
import 'package:bonus/views/User_chat/cubits/bottomBarCubit.dart';
import 'package:bonus/views/permission_location.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:touch_indicator/touch_indicator.dart';

import 'package:bonus/const/shared_helper.dart';
import 'package:bonus/views/User_chat/cubits/cubits.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BottomBarView extends StatefulWidget {
  BottomBarView({
    this.message,
    this.nameRecive,
    this.friendName,
    this.testName,
    this.Token,
  });
  final String? Token;
  late final String? testName;
  late final String hintname;
  late final String? friendName;
  late final String? nameRecive;
  final TextEditingController? message;
  late final String? selectedContacts;
  int x = 1;

  @override
  _BottomBarViewState createState() => _BottomBarViewState();
}
// Location location = new Location();
// PermissionStatus? permissions;

class _BottomBarViewState extends State<BottomBarView> {
  // late AndroidNotificationChannel channel;
  //
  // /// Initialize the [FlutterLocalNotificationsPlugin] package.
  // late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String? tokens;
  // void LoadFCM() async {
  //   if (!kIsWeb) {
  //     channel = const AndroidNotificationChannel(
  //       'high_importance_channel', // id
  //       'High Importance Notifications', // title
  //       importance: Importance.high,
  //       enableVibration: true,
  //     );
  //
  //     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //
  //     /// Create an Android Notification Channel.
  //     ///
  //     /// We use this channel in the `AndroidManifest.xml` file to override the
  //     /// default FCM channel to enable heads up notifications.
  //     await flutterLocalNotificationsPlugin
  //         .resolvePlatformSpecificImplementation<
  //             AndroidFlutterLocalNotificationsPlugin>()
  //         ?.createNotificationChannel(channel);
  //
  //     /// Update the iOS foreground notification presentation options to allow
  //     /// heads up notifications.
  //     await FirebaseMessaging.instance
  //         .setForegroundNotificationPresentationOptions(
  //       alert: true,
  //       badge: true,
  //       sound: true,
  //     );
  //   }
  // }
  //
  // void ListenFCM() async {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     RemoteNotification? notification = message.notification;
  //     AndroidNotification? android = message.notification?.android;
  //     if (notification != null && android != null && !kIsWeb) {
  //       flutterLocalNotificationsPlugin.show(
  //         notification.hashCode,
  //         notification.title,
  //         notification.body,
  //         NotificationDetails(
  //           android: AndroidNotificationDetails(
  //             channel.id,
  //             channel.name,
  //             // TODO add a proper drawable resource to android, for now using
  //             //      one that already exists in example app.
  //             icon: 'launch_background',
  //           ),
  //         ),
  //       );
  //     }
  //   });
  // }
  //
  // void Requestpermission() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     print('user permisssion notifications');
  //   } else if (settings.authorizationStatus ==
  //       AuthorizationStatus.provisional) {
  //     print('user provisional permission');
  //   } else {
  //     print('user not accepted permission');
  //   }
  // }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        tokens = token;
        print(widget.Token!);
      });
      ;
    });
  }

   Push_Notifications(String mess, String tokens) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAA_rKuB0c:APA91bHgvw7YJiX0uQhZxnbzCQiIsbwUylZDFKmvrw96Budgk5EPDwcYPFKPqRasOnStCENrDcNWVuJuv5h0p2LNvnA4wokp-8SFOnGVcc_HSeSHh3gOdrcQai3bsIK9Zy1XiA2cP-jS',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'sound': 'default',
              'body': mess,
              'title': SharedHelper.getName
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": tokens,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
      print("error push notification");
      print("error push notification");
    }
  }

  FToast? fToast;

  @override
  void initState() {
    // var permissions =  location.hasPermission();
    fToast = FToast();
    fToast?.init(context);
    // Requestpermission();
    getToken();
    // LoadFCM();
    // ListenFCM();
    FirebaseMessaging.instance.subscribeToTopic('Animal');

    super.initState();
  }
  void dispose() {


    super.dispose();
  }


  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Color(0xFF0E3589),
    ),
    child: Text(
      "Please wait a momment ",
      style: TextStyle(fontSize: 18, color: Colors.white),
    ),
  );

  late File file;
  late File fileCamera;
  late Fluttertoast tf;
  var zzzz;
  var token_of_user;
  var token_of_user1;
  var token_of_user2;
  var token_of_user3;
  num m = 0;

  // List<Contact>? contacts;
  // // final FlutterContactPicker _flutterContactPicker=FlutterContactPicker();
  // Contact selectedContact = Contact();

  void pickContactFromNativeApp() async {
    fToast!.showToast(
      child: Material(
        color: Color(0xFFB8C1CB),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 9,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Opening Contacts ...'),
                CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ],
            ),
          ),
        ),
      ),
      gravity: ToastGravity.CENTER,
      fadeDuration: 2,
      toastDuration: Duration(seconds: 20),
    );
    await checkAppPermissionsToContacts();

    if (await checkAppPermissionsToContacts() == PermissionStatus.granted) {
      // if permissions are granted
      try {
        var contacts = (await ContactsService.getContacts()).toList();
        var selectedContact = await ContactsService.openDeviceContactPicker();
        print("named0");
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.nameRecive)
            .collection('messages')
            .doc(SharedHelper.getEmail)
            .collection('chats')
            .add({
          "sender": SharedHelper.getEmail,
          "receiver": widget.nameRecive,
          "message": selectedContact!.phones![0].value,
          "l": GeoPoint(0.0, 0.0),
          "type": "phone",
          "date": DateTime.now(),
          "seen": 1,
        }).then((value) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(widget.nameRecive)
              .collection('messages')
              .doc(SharedHelper.getEmail)
              .set({
            "last_msg": selectedContact.phones![0].value,
            "date": DateTime.now(),
            'name': SharedHelper.getName!,
            'sender': SharedHelper.getEmail,
            "type": "phone",
            "seen": 0,
            // مفروض هنا ببعت التوكين عشان اعرف اكسس عليه بعدين وانا فاتح المسدجات
            'token': widget.Token,
          });
        });
        m = 0;
        var z = await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.nameRecive)
            .collection('messages')
            .doc(SharedHelper.getEmail)
            .collection('chats')
            .where('seen',isEqualTo: 1).get();
        for (var doc in z.docs) {
          zzzz = await doc['seen'];
          m = m + zzzz;

        };
        var z2 = await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.nameRecive!)
            .get();
        token_of_user1 = await z2['token'];


        await FirebaseFirestore.instance
            .collection('users')
            .doc(SharedHelper.getEmail)
            .collection('messages')
            .doc(widget.nameRecive)
            .collection('chats')
            .add({
          "sender": SharedHelper.getEmail,
          "receiver": widget.nameRecive,
          "message": selectedContact.phones![0].value,
          "l": GeoPoint(0.0, 0.0),
          "type": "phone",
          "date": DateTime.now(),
          "seen": 0,
        }).then((value) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(SharedHelper.getEmail)
              .collection('messages')
              .doc(widget.nameRecive)
              .set({
            'last_msg': selectedContact.phones![0].value,
            'date': DateTime.now(),
            'name': widget.friendName!,
            'sender': SharedHelper.getEmail,
            "type": "phone",
            "seen": 0,
            'token': widget.Token,
          });
        });
       await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.nameRecive)
            .collection('messages')
            .doc(SharedHelper.getEmail)
            .update({'seen': m});
        await FirebaseFirestore.instance
            .collection('users')
            .doc(SharedHelper.getEmail)
            .collection('messages')
            .doc(widget.nameRecive)
            .update({
          'token': token_of_user1.toString()
        });

        Push_Notifications(selectedContact.phones![0].value.toString(),token_of_user1);


        // ابعت الرقم من هنا
        print(selectedContact.phones![0].value);
        print("named11");

        for (int i = 0; i < contacts.length; i++) {
          print("11111111111111111111111111");
          // print(contacts);
          // print(contacts[i].displayName);

        }
        // selectedContact = (await ContactsService
        //     .openDeviceContactPicker())!; // Open Device Contacts app and return selected contact
        setState(() {}); //Call set state to update UI with the contact details.
      } catch (e) {
        //User cancelled operation
        //Contacts app could not be opened
        //An UnkownError occured
      }
    }
    fToast!.removeCustomToast();
  }

  Future<PermissionStatus> checkAppPermissionsToContacts() async {
    final PermissionStatus permission =
        await Permission.contacts.status; //Check status of Contacts Permission.
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.restricted) {
      //If permission has not been granted or denied.
      final Map<Permission, PermissionStatus> permissionStatus = await [
        Permission.contacts
      ].request(); //Request for Permission to access contacts
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.restricted;
    } else {
      return permission; //Return Contacts Permission status
    }
  }

  @override
  final formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: WillPopScope(
        onWillPop: () async {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          return true;
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0x61DCDCE0),
                    borderRadius: BorderRadius.circular(29),
                  ),

                  // width: MediaQuery.of(context).size.width/1.2,
                  child: TextFormField(
                    maxLengthEnforced: false,
                    minLines: 1,
                    controller: widget.message!,
                    validator: (value) {
                      if (value!.isEmpty || value.trim().isEmpty) {
                        return "message is empty";
                      } else {
                        return null;
                      }
                    },
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      border: InputBorder.none,

                      hintStyle: TextStyle(color: Colors.black26),
                      hintText: ("Your Message"),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;

                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.nameRecive)
                            .collection('messages')
                            .doc(SharedHelper.getEmail)
                            .collection('chats')
                            .add({
                          "sender": SharedHelper.getEmail,
                          "receiver": widget.nameRecive,
                          "message": widget.message!.text,
                          "l": GeoPoint(0.0, 0.0),
                          "type": "text",
                          "date": DateTime.now(),
                          "seen": 1,
                        }).then((value) {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.nameRecive)
                              .collection('messages')
                              .doc(SharedHelper.getEmail)
                              .set({
                            "last_msg": widget.message!.text,
                            "date": DateTime.now(),
                            'name': SharedHelper.getName!,
                            'sender': SharedHelper.getEmail,
                            "type": "text",
                            "seen": 0,
                            'token': SharedHelper.getTokenOfNot,
                          });
                        });

                        m = 0;
                        var z = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.nameRecive)
                            .collection('messages')
                            .doc(SharedHelper.getEmail)
                            .collection('chats')
                            .where('seen',isEqualTo: 1).get();
                          for (var doc in z.docs) {
                            zzzz = await doc['seen'];
                            m = m + zzzz;

                        };
                        var z2 = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.nameRecive!)
                            .get();
                        token_of_user = await z2['token'];

                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(SharedHelper.getEmail)
                            .collection('messages')
                            .doc(widget.nameRecive)
                            .collection('chats')
                            .add({
                          "sender": SharedHelper.getEmail,
                          "receiver": widget.nameRecive,
                          "message": widget.message!.text,
                          "l": GeoPoint(0.0, 0.0),
                          "type": "text",
                          "date": DateTime.now(),
                          'seen': 0,
                        }).then((value) {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(SharedHelper.getEmail)
                              .collection('messages')
                              .doc(widget.nameRecive)
                              .set({
                            'last_msg': widget.message!.text,
                            'date': DateTime.now(),
                            'name': widget.friendName!,
                            'sender': SharedHelper.getEmail,
                            "type": "text",
                            'seen': 0,
                            'token': token_of_user,
                          });
                        });
                    await    Push_Notifications(widget.message!.text, token_of_user);

                        widget.message!.clear();


                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.nameRecive)
                            .collection('messages')
                            .doc(SharedHelper.getEmail)
                            .update({
                          'seen': m,
                        });
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(SharedHelper.getEmail)
                            .collection('messages')
                            .doc(widget.nameRecive)
                            .update({
                          'token': token_of_user.toString()
                        });

                        // FocusScope.of(context).unfocus();

                      },
                      icon: Icon(CommunityMaterialIcons.send),
                      color: Color(0xFF0E3589)),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        // onVisible:   ScaffoldMessenger.of(context)?.(),
                        duration: const Duration(minutes: 5),
                        content: Container(
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () async {
                                  final pickedFile = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  final messagess =
                                      await BottomBarController.of(context)
                                          .isInternet();
                                  if (messagess != 'true') {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text(messagess.toString())));
                                  } else {
                                    if (pickedFile == null) return;
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();

                                    fToast!.showToast(
                                      child: Row(
                                        children: [
                                          Text('Sending image ...'),
                                          CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ],
                                      ),
                                      gravity: ToastGravity.BOTTOM_RIGHT,
                                      fadeDuration: 1,
                                      toastDuration: Duration(seconds: 25),
                                    );

                                    try {
                                      file = await File(pickedFile.path);
                                      print(file.path);
                                      // متغير عشان اعرفه ان النت وحش

                                      // شوف ازاي تخزن صوره ف الفايربيز ستوردج
                                      final x = await FirebaseStorage.instance
                                          .ref('phots')
                                          .child(
                                              SharedHelper.getEmail.toString())
                                          .child(widget.nameRecive!)
                                          .child(file.hashCode.toString())
                                          .putFile(file)
                                          .then((p0) => {
                                                FirebaseStorage.instance
                                                    .ref('phots')
                                                    .child(SharedHelper.getEmail
                                                        .toString())
                                                    .child(widget.nameRecive!)
                                                    .child(file.hashCode
                                                        .toString())
                                                    .putFile(file)
                                              })
                                          .catchError((error) {
                                      });

                                      final zzz = await FirebaseStorage.instance
                                          .ref('phots')
                                          .child(
                                              SharedHelper.getEmail.toString())
                                          .child(widget.nameRecive!)
                                          .child(file.hashCode.toString())
                                          .putFile(file);


                                      var qq = await FirebaseStorage.instance
                                          .ref('phots')
                                          .child(
                                              SharedHelper.getEmail.toString())
                                          .child(widget.nameRecive!)
                                          .child(file.hashCode.toString())
                                          .getDownloadURL();

                                      print('111111111111111111111221');
                                      print(widget.nameRecive);
                                      print(widget.message);

                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(widget.nameRecive)
                                          .collection('messages')
                                          .doc(SharedHelper.getEmail)
                                          .collection('chats')
                                          .add({
                                        "sender": SharedHelper.getEmail,
                                        "receiver": widget.nameRecive,
                                        "message": qq,
                                        "l": GeoPoint(0.0, 0.0),
                                        "type": "image",
                                        "date": DateTime.now(),
                                        "seen": 1,
                                      }).then((value) {
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(widget.nameRecive)
                                            .collection('messages')
                                            .doc(SharedHelper.getEmail)
                                            .set({
                                          "last_msg": qq,
                                          "date": DateTime.now(),
                                          'name': SharedHelper.getName!,
                                          'sender': SharedHelper.getEmail,
                                          "type": "image",
                                          "seen": 0,
                                          'token': SharedHelper.getTokenOfNot,
                                        });
                                      });

                                      m = 0;
                                      var z = await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(widget.nameRecive)
                                          .collection('messages')
                                          .doc(SharedHelper.getEmail)
                                          .collection('chats')
                                          .where('seen',isEqualTo: 1).get();
                                      for (var doc in z.docs) {
                                        zzzz = await doc['seen'];
                                        m = m + zzzz;

                                      };
                                      var z2 = await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(widget.nameRecive!)
                                          .get();
                                      token_of_user2 = await z2['token'];


                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(SharedHelper.getEmail)
                                          .collection('messages')
                                          .doc(widget.nameRecive)
                                          .collection('chats')
                                          .add({
                                        "sender": SharedHelper.getEmail,
                                        "receiver": widget.nameRecive,
                                        "message": qq,
                                        "l": GeoPoint(0.0, 0.0),
                                        "type": "image",
                                        "date": DateTime.now(),
                                        "seen": 0,
                                      }).then((value) {
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(SharedHelper.getEmail)
                                            .collection('messages')
                                            .doc(widget.nameRecive)
                                            .set({
                                          'last_msg': qq,
                                          'date': DateTime.now(),
                                          'name': widget.friendName!,
                                          'sender': SharedHelper.getEmail,
                                          "type": "image",
                                          "seen": 0,
                                          'token': widget.Token,
                                        });
                                      });


                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(widget.nameRecive)
                                          .collection('messages')
                                          .doc(SharedHelper.getEmail)
                                          .update({
                                        'seen': m,
                                      });
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(SharedHelper.getEmail)
                                          .collection('messages')
                                          .doc(widget.nameRecive)
                                          .update({
                                        'token': token_of_user2.toString()
                                      });
                                      Push_Notifications('photo', token_of_user2);


                                    } catch (e) {}

                                    fToast!.removeCustomToast();
                                    // await Fluttertoast.cancel();

                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0,
                                      bottom: 20.0,
                                      right: 10,
                                      left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        CommunityMaterialIcons
                                            .picture_in_picture_bottom_right,
                                        color: Color(0xFF0E3589),
                                      ),
                                      Text(
                                        "image",
                                        style:
                                            TextStyle(color: Color(0xFF0E3589)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  // await  Fluttertoast.showToast(
                                  //
                                  //       msg: "Please wait a momment ",
                                  //       toastLength: Toast.LENGTH_LONG,
                                  //       gravity: ToastGravity.CENTER,
                                  //       timeInSecForIosWeb: 12,
                                  //       backgroundColor: Color(0xFF2556BF),
                                  //       textColor: Colors.white,
                                  //       fontSize: 18.0
                                  //   );

                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();

                                  pickContactFromNativeApp();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0,
                                      bottom: 20.0,
                                      right: 10,
                                      left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        CommunityMaterialIcons.account,
                                        color: Color(0xFF0E3589),
                                      ),
                                      Text(
                                        "Contacts",
                                        style:
                                            TextStyle(color: Color(0xFF0E3589)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: ()  {
                                  fToast!.showToast(
                                    child: Material(
                                      color: Color(0xFFB8C1CB),
                                      borderRadius: BorderRadius.circular(18),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width / 1.25,
                                        height: MediaQuery.of(context).size.height / 9,
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Location not Active From playstore '),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    gravity: ToastGravity.CENTER,
                                    fadeDuration: 2,
                                    toastDuration: Duration(seconds: 4),
                                  );

                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0,
                                      bottom: 20.0,
                                      right: 10,
                                      left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        CommunityMaterialIcons.map_marker,
                                        color: Color(0xFF0E3589),
                                      ),
                                      Text(
                                        "Location",
                                        style:
                                            TextStyle(color: Color(0xFF0E3589)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        backgroundColor: Colors.white,
                      ));
                    },
                    icon: Icon(CommunityMaterialIcons.attachment,
                        color: Color(0xFF14357F)),
                    iconSize: 30,
                    color: Color(0xFF0E3589),
                  ),
                  IconButton(
                    onPressed: () async {
                      final pickedFile = await ImagePicker()
                          .pickImage(source: ImageSource.camera);
                      final messagess =
                          await BottomBarController.of(context).isInternet();
                      if (messagess != 'true') {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(messagess.toString())));
                      } else {
                        if (pickedFile == null) return;
                        fToast!.showToast(
                          child: Row(
                            children: [
                              Text('Sending photo ...'),
                              CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ],
                          ),
                          gravity: ToastGravity.BOTTOM_RIGHT,
                          fadeDuration: 1,
                          toastDuration: Duration(seconds: 25),
                        );

                        fileCamera = await File(pickedFile.path);
                        await FirebaseStorage.instance
                            .ref('phots')
                            .child(SharedHelper.getEmail.toString())
                            .child(widget.nameRecive!)
                            .child(fileCamera.hashCode.toString())
                            .putFile(fileCamera);

                        var qqCamera = await FirebaseStorage.instance
                            .ref('phots')
                            .child(SharedHelper.getEmail.toString())
                            .child(widget.nameRecive!)
                            .child(fileCamera.hashCode.toString())
                            .getDownloadURL();
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.nameRecive)
                            .collection('messages')
                            .doc(SharedHelper.getEmail)
                            .collection('chats')
                            .add({
                          "sender": SharedHelper.getEmail,
                          "receiver": widget.nameRecive,
                          "message": qqCamera,
                          "l": GeoPoint(0.0, 0.0),
                          "type": "image",
                          "date": DateTime.now(),
                          "seen": 1,
                        }).then((value) {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.nameRecive)
                              .collection('messages')
                              .doc(SharedHelper.getEmail)
                              .set({
                            "last_msg": qqCamera,
                            "date": DateTime.now(),
                            'name': SharedHelper.getName!,
                            'sender': SharedHelper.getEmail,
                            "type": "image",
                            "seen": 1,
                            'token': SharedHelper.getTokenOfNot,
                          });
                        });

                        m = 0;
                        var z = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.nameRecive)
                            .collection('messages')
                            .doc(SharedHelper.getEmail)
                            .collection('chats')
                            .where('seen',isEqualTo: 1).get();
                        for (var doc in z.docs) {
                          zzzz = await doc['seen'];
                          m = m + zzzz;

                        };
                        var z2 = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.nameRecive!)
                            .get();
                        token_of_user3 = await z2['token'];
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(SharedHelper.getEmail)
                            .collection('messages')
                            .doc(widget.nameRecive)
                            .collection('chats')
                            .add({
                          "sender": SharedHelper.getEmail,
                          "receiver": widget.nameRecive,
                          "message": qqCamera,
                          "l": GeoPoint(0.0, 0.0),
                          "type": "image",
                          "seen":0,
                          "date": DateTime.now(),
                        }).then((value) {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(SharedHelper.getEmail)
                              .collection('messages')
                              .doc(widget.nameRecive)
                              .set({
                            'last_msg': qqCamera,
                            'date': DateTime.now(),
                            'name': widget.friendName!,
                            'sender': SharedHelper.getEmail,
                            "type": "image",
                            "seen":0,
                            'token': widget.Token,
                          });
                        });



                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.nameRecive)
                            .collection('messages')
                            .doc(SharedHelper.getEmail)
                            .update({
                          'seen': m,
                        });
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(SharedHelper.getEmail)
                            .collection('messages')
                            .doc(widget.nameRecive)
                            .update({
                          'token': token_of_user3.toString()
                        });


                        fToast!.removeCustomToast();


                        Push_Notifications('photo', token_of_user3);

                      }
                    },
                    icon: Icon(CommunityMaterialIcons.camera),
                    color: Color(0xFF0E3589),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

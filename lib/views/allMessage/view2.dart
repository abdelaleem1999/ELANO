import 'package:bonus/views/User_chat/cubits/cubits.dart';
import 'package:bonus/views/allMessage/widgets/allUserComponent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import '../../const/shared_helper.dart';
import '../../widgets/userComponent.dart';
import '../User_chat/view.dart';

class AllUsers extends StatefulWidget {

  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  late AndroidNotificationChannel channel;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String? tokens;
  void LoadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void ListenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void Requestpermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user permisssion notifications');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('user provisional permission');
    } else {
      print('user not accepted permission');
    }
  }
@override
  void initState() {
  Requestpermission();
  LoadFCM();
  ListenFCM();
  FirebaseMessaging.instance.subscribeToTopic('Animal');


}
  @override

  void dispose() {

    super.dispose();
  }

  Widget build(BuildContext context) {

          return StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),

            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.docs.length < 1) {
                  return Center(child: const Text('No Users Sign'));
                } else {
                  return ListView.builder(

                      itemCount: snapshot.data.docs.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      // scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return AllUserComponent(
                          name: snapshot.data.docs[index]['name'],
                          message: snapshot.data.docs[index]['email'],
                          owner: snapshot.data.docs[index]['owner']==null ?0
                          :snapshot.data.docs[index]['owner'],


                          Navigator: UserChat(
                            Token: snapshot.data.docs[index]['token'],
                            friendRecive: snapshot.data.docs[index].id,
                            friendName: snapshot.data.docs[index]['name'],
                            status: index,

                          ),
                        );
                      }


                  );
                }
              }
              return const Center(child: CircularProgressIndicator(),);
            },);

  }
}

// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:pusher_client/pusher_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NotificationPage(),
    );
  }
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late PusherClient pusher;
  late Channel channel;

  @override
  void initState() {
    super.initState();

    pusher = PusherClient(
      '0b050023c56c52c1fd9f',
      PusherOptions(
        cluster: 'ap2',
        encrypted: true,
      ),
    );

    channel = pusher.subscribe('notifications');
    channel.bind('App\\Events\\NotificationEvent', (event) {
      if (event != null && event.data != null) {
        final data = event.data as Map<String, dynamic>;
        if (data.containsKey('message')) {
          print(data['message']);
        } else {
          print('Message key not found in the data.');
        }
      } else {
        print('Event or Event data is null.');
      }
    });

    pusher.connect();
  }

  @override
  void dispose() {
    pusher.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: const Center(
        child: Text('Waiting for notifications...'),
      ),
    );
  }
}

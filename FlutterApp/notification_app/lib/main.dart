// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NotificationPage(),
    );
  }
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    initPusher();
  }

  void initPusher() async {
    await pusher.init(
      apiKey: "0b050023c56c52c1fd9f",
      cluster: "ap2",
      onConnectionStateChange: onConnectionStateChange,
      onError: (String message, int? code, dynamic e) {
        onError(message, code, e);
        return null;
      },
    );

    pusher.subscribe(
      channelName: "notifications",
      onEvent: (dynamic event) {
        onEvent(event as PusherEvent);
      },
    );

    pusher.connect();
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    print("Connection state changed: $currentState");
  }

  dynamic onError(String message, int? code, dynamic e) {
    print("Error: $message");
    return null;
  }

  void onEvent(PusherEvent event) {
    print("Received event: ${event.data}");
    final eventData = json.decode(event.data);
    setState(() {
      messages.add(eventData['message']);
    });
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: messages.isEmpty
            ? const Center(child: Text('Waiting for notifications...'))
            : ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.notifications, color: Colors.blue),
                      title: Text(
                        messages[index],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

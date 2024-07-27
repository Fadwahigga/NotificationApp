import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotificationPage(),
    );
  }
}

class NotificationPage extends StatefulWidget {
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
        return null; // Return type should be dynamic
      },
    );

    pusher.subscribe(
      channelName: "notifications",
      onEvent: (dynamic event) {
        onEvent(event as PusherEvent); // Cast to PusherEvent
      },
    );

    pusher.connect();
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    print("Connection state changed: $currentState");
  }

  dynamic onError(String message, int? code, dynamic e) {
    print("Error: $message");
    return null; // Return type should be dynamic
  }

  void onEvent(PusherEvent event) {
    print("Received event: ${event.data}");

    // Decode the event data
    final eventData = json.decode(event.data);

    // Extract the message and add it to the list
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
        title: Text('Notifications'),
      ),
      body: messages.isEmpty
          ? Center(child: Text('Waiting for notifications...'))
          : ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]),
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:simple_messenger/components/message_textfield.dart';
import 'package:simple_messenger/services/connection_service.dart';
import 'package:simple_messenger/models/friend.dart';
import 'package:simple_messenger/models/message.dart';
import 'package:simple_messenger/singleton/user_data.dart';
// import 'dart:core';

class MessagePage extends StatefulWidget {
  // In the constructor, require a Friend
  const MessagePage({super.key, required this.friend});

  // Declare a field that holds the Friend
  final Friend friend;

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Message> messages = [];

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    void onSend() {
      if (textController.text.isNotEmpty) {
        ConnectionService().sendMessage(textController.text, widget.friend.id);
        Message msg = Message(userData.email, textController.text, DateTime.now().toString());
        messages.add(msg);
        textController.clear();
        setState(() {});
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.friend.email),
        shadowColor: Theme.of(context).colorScheme.shadow,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () { 
                // Navigate back to Friends page
                Navigator.pop(context);
              },
            );
          }
        )
      ),
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder(
              stream: ConnectionService().stream,
              builder: (context, snapshot) {  
                // Check if user receives a message
                if (snapshot.hasData) {
                  List<String> received = snapshot.data.toString().split(" ");
                  // Check that the message received is from the current friend they are viewing
                  if (received[0] == widget.friend.id) {
                    // Build the message
                    Message msg = Message(widget.friend.email, received[2], received[3] + received[4]);

                    if (messages.isEmpty) {
                      messages.add(msg);
                    } else {
                      // Check for duplicate messages from server
                      if (!messages.contains(msg)) {
                        messages.add(msg);
                      }
                    }
                    
                  }
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      // User's message, else is friend's message
                      if (messages[index].user == widget.friend.email) {
                        return ListTile(
                          title: Text(
                            "${messages[index].user}: ${messages[index].msg}",
                            style: TextStyle(
                              background: Paint()
                                ..color = Colors.grey
                                ..strokeWidth = 25
                                ..strokeJoin = StrokeJoin.round
                                ..strokeCap = StrokeCap.round
                                ..style = PaintingStyle.stroke,
                              color: Colors.white,
                            )
                          ),
                        );
                      } else {
                        return ListTile(
                          contentPadding: EdgeInsets.only(right: 16.0),
                          title: Text(
                            "${messages[index].user}: ${messages[index].msg}",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              background: Paint()
                                ..color = Colors.blue
                                ..strokeWidth = 25
                                ..strokeJoin = StrokeJoin.round
                                ..strokeCap = StrokeCap.round
                                ..style = PaintingStyle.stroke,
                              color: Colors.white,
                            )
                          ),
                        );
                      }
                      
                    },
                  )
                );
              },
            ),
            MessageTextField(
              controller: textController,
              hintText: 'Message',
              onIconTap: onSend,
            ),
            const SizedBox(height: 20),
          ]
        )
      )
    );
  }
}
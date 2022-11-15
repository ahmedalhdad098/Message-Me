import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

final _fireStore = FirebaseFirestore.instance;
late User signInUser;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static String routeScreen = 'ChatScreen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? massageText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      // print("user email = ${signInUser.email}");
      if (user != null) {
        signInUser = user;
        print("user email = ${signInUser.email}");
      }
    } catch (e) {
      print("exception $e");
    }
  }

  //  void getMessages()async{
  //  final message = await _fireStore.collection('messages').get();
  //  for(var message in  message.docs){
  //     print(message.data());
  //  }
  //  }

  void messagesStreams() async {
    await for (var snapshot in _fireStore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Row(children: [
          Image.asset(
            'images/logo.png',
            height: 25,
          ),
          SizedBox(
            width: 10,
          ),
          Text('MessageMe'),
        ]),
        actions: [
          IconButton(
            onPressed: () {
              // _auth.signOut();
              // Navigator.pop(context);
              // getMessages();
              messagesStreams();
            },
            icon: Icon(Icons.close),
          ),
        ],
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MessagesStreamBuilder(),
          Container(
            decoration: BoxDecoration(
                border: Border(
              top: BorderSide(color: Colors.orange, width: 2),
            )),
            child: Row(children: [
              Expanded(
                  child: TextField(
                controller: messageTextController,
                onChanged: (value) {
                  massageText = value;
                },
                decoration: InputDecoration(
                    hintText: 'Write your massege here',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    border: InputBorder.none),
              )),
              TextButton(
                  onPressed: () {
                    messageTextController.clear();

                    _fireStore.collection('messages').add({
                      'text': massageText,
                      'sender': signInUser.email,
                      'time': FieldValue.serverTimestamp(),
                    });
                  },
                  child: const Text('Send'))
            ]),
          )
        ],
      )),
    );
  }
}

class MessagesStreamBuilder extends StatelessWidget {
  const MessagesStreamBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _fireStore.collection('messages').orderBy('time').snapshots(),
        builder: (context, snapshot) {
          List<MessageLine> messsageWidgets = [];
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final messages = snapshot.data!.docs.reversed;
          for (var message in messages) {
            final messageText = message.get('text');
            final messageSender = message.get('sender');
            final currentUser = signInUser.email;
            if (currentUser == messageSender) {}
            final messageWidget = MessageLine(
              text: messageText,
              sender: messageSender,
              isMe: currentUser == messageSender,
            );
            messsageWidgets.add(messageWidget);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messsageWidgets,
            ),
          );
        });
  }
}

class MessageLine extends StatelessWidget {
  const MessageLine({this.text, this.sender, required this.isMe, Key? key})
      : super(key: key);
  final String? sender;
  final String? text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$sender',
            style: TextStyle(fontSize: 12, color: Colors.yellow[900]),
          ),
          Material(
              borderRadius: isMe
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    )
                  : const BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
              elevation: 5,
              color: isMe ? Colors.blue[800] : Colors.yellow[800],
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  "$text ",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              )),
        ],
      ),
    );
  }
}

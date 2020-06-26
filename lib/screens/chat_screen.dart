import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseUser _loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String screenID = 'Chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;

  String messageText;
  final messageController = TextEditingController();

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        _loggedInUser = user;
        print('Check ${_loggedInUser.email}');
        //return user;
      }
    } catch (e) {
      print(e);
    }
  }

  void getMessages() async {
    final messages = await _firestore.collection('messages').getDocuments();
    for (var message in messages.documents) {
      print(message.data);
    }
  }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.documents) {
        print(message.data);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    //print(loggedInUser);

    if (_loggedInUser != null) {
      print('loggedInUser = ${_loggedInUser}');
    }
    //super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
                //messagesStream();
                //getMessages();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(
              firestore: _firestore,
              //loggedInUser: loggedInUser,
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      //message = collection name on Firebase console.
                      // add method required the map type.
                      print('--------------------------------------------------');
                      messageController.clear();
                      if (messageText != null) {
                        _firestore.collection('messages').add({
                          'sender': _loggedInUser.email, 'text': messageText,
                          'timestamp': DateTime.now().millisecondsSinceEpoch,
                          //firebase.firestore.FieldValue.serverTimestamp()
                        });
                      }
                      messageText = null; // clear message after sent.
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({
    Key key,
    @required Firestore firestore,
    //@required FirebaseUser loggedInUser,
  })  : _firestore = firestore,
        //_loggedInUser = loggedInUser,
        super(key: key);

  final Firestore _firestore;
  //final FirebaseUser _loggedInUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        // Stream builder that listening for querysnapshot.

        stream: _firestore.collection('messages').orderBy('timestamp').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // if no data return progress.
            print('No Data');
            print(_loggedInUser);
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ),
            );
          }
          final messages = snapshot.data.documents.reversed;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            print('****${message.data}');
            //print('${_loggedInUser.email} and ${message.data['sender']}');
            print('${_loggedInUser.email} and ${message.data['sender']}');
            messageBubbles.add(
              MessageBubble(
                sender: message.data['sender'], message: message.data['text'],
                isMe: _loggedInUser.email == message.data['sender'],
                // ,
                // '${message.data['sender']} : ${message.data['text']} ',
                // style: TextStyle(fontSize: 40),
              ),
            );
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messageBubbles,
            ),
          );
        });
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String message;
  final bool isMe;

  MessageBubble({this.sender, this.message, this.isMe});

  @override
  Widget build(BuildContext context) {
    print(isMe);
    return Padding(
      padding: EdgeInsets.all(7),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text('$sender'),
          Material(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
                topLeft: isMe ? Radius.circular(0) : Radius.circular(30),
                topRight: isMe ? Radius.circular(30) : Radius.circular(0)),

            elevation: 3,
            //color: Colors.pink[100],
            color: isMe ? Colors.pink[100] : Colors.green[100],
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                '$message',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

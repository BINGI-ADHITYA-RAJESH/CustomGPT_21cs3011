import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
// ignore: unused_import
import 'package:speech_to_text/speech_recognition_result.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final userprofile = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? user;
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _loadChatHistoryFromFirebase();
    _initSpeech();
  }

  void _initSpeech() async {
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(
  onResult: (result) {
    setState(() {
      _controller.text = result.recognizedWords;
    });
  },
);
    }
  }

 void _startListening() {
  _speech.listen(
    onResult: (result) {
      setState(() {
        _controller.text = result.recognizedWords;
      });
    },
  );
  setState(() {
    _isListening = true;
  });
}


  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  Future<void> _sendRequest() async {
    final url = Uri.parse('http://192.168.26.100:3000/query');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'query': _controller.text}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final answer = data['answer'];
      setState(() {
        _messages.add(ChatMessage(
          text: _controller.text,
          isUserMessage: true,
        ));
        _messages.add(ChatMessage(
          text: answer,
          isUserMessage: false,
        ));
        _controller.clear();
      });
      _sendBotMessageToFirebase(answer);
    } else {
      // Handle error
    }
  }

  Future<void> _sendMessageToFirebase(String text) async {
    await _firestore.collection('chatMessages').add({
      'text': text,
      'userId': user?.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _sendBotMessageToFirebase(String text) async {
    await _firestore.collection('chatMessages').add({
      'text': text,
      'userId': 'bot',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _loadChatHistoryFromFirebase() async {
    final querySnapshot = await _firestore
        .collection('chatMessages')
        .orderBy('timestamp', descending: true)
        .get();

    final messages = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return ChatMessage(
        text: data['text'],
        isUserMessage: data['userId'] == user?.uid,
      );
    }).toList();

    setState(() {
      _messages.clear();
      _messages.addAll(messages.reversed);
    });
  }

  Future<void> _deleteChatHistory() async {
    final collectionReference = _firestore.collection('chatMessages');
    final querySnapshot = await collectionReference.get();

    final batch = _firestore.batch();

    for (final doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();

    setState(() {
      _messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom GPT'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color.fromARGB(255, 154, 201, 143)),
              child: Row(
                children: [
                  const Icon(
                    Icons.account_circle_rounded,
                    size: 48,
                  ),
                  const SizedBox(width: 10,),
                  Flexible(
                    child: Text(
                      userprofile?.emailVerified.toString() == null? 'Account': user!.email.toString(),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 20,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  _messages.clear();
                  _deleteChatHistory();
                });
                Navigator.pop(context);
              },
              contentPadding: const EdgeInsets.all(8),
              leading: const Icon(Icons.delete, size: 40,),
              title: const Text('Clear Chat'),
            ),
          ],
        ),
      ),
      body: Column(
  children: <Widget>[
    Expanded(
      child: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          return ChatBubble(
            text: message.text,
            isUserMessage: message.isUserMessage,
          );
        },
      ),
    ),
    Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: _isListening ? _stopListening : _startListening,
            icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Ask your query...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                _sendRequest();
                _sendMessageToFirebase(_controller.text);
              }
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    ),
  ],
),

    );
  }
}

class ChatMessage {
  final String text;
  final bool isUserMessage;

  ChatMessage({required this.text, required this.isUserMessage});
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUserMessage;

  const ChatBubble({super.key, required this.text, required this.isUserMessage});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: isUserMessage ? 48 : 8, // Adjust left margin for user messages
          right: isUserMessage ? 8 : 48, // Adjust right margin for bot messages
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUserMessage ? Colors.greenAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
          
          ],
        ),
      ),
    );
  }
}

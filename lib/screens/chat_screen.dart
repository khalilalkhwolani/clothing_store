import 'package:flutter/material.dart';
import 'package:myprojectshop/theme/theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> messages = [
    {'message': 'Hi, there!', 'isMe': false, 'time': '2:30 PM', 'status': ''},
    {
      'message': 'Hello! How can I help you today?',
      'isMe': true,
      'time': '2:31 PM',
      'status': 'read',
    },
  ];

  // void sendMessage() {
  //   final text = _messageController.text.trim();
  //   if (text.isEmpty) return;

  //   final now = TimeOfDay.now();
  //   final formattedTime =
  //       '${now.hour}:${now.minute.toString().padLeft(2, '0')}';

  //   setState(() {
  //     messages.add({
  //       'message': text,
  //       'isMe': true,
  //       'time': formattedTime,
  //       'status': 'sent',
  //     });
  //   });

  //   _messageController.clear();

  //   // Scroll to bottom
  //   Future.delayed(Duration(milliseconds: 100), () {
  //     _scrollController.animateTo(
  //       _scrollController.position.maxScrollExtent + 100,
  //       duration: Duration(milliseconds: 300),
  //       curve: Curves.easeOut,
  //     );
  //   });
  // }

  Widget buildMessage(Map<String, dynamic> message) {
    final bool isMe = message['isMe'];
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMe)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage("assets/images/google.png"),
              backgroundColor: Colors.yellow,
            ),
          ),
        Container(
          // color: isMe ? AppTheme.primaryColor : Colors.grey.shade200,
          margin: EdgeInsets.symmetric(vertical: 6),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          constraints: BoxConstraints(maxWidth: 250),
          decoration: BoxDecoration(
            color:
                isMe
                    ? AppTheme.primaryColor
                    : const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message['message'],
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message['time'],
                    style: TextStyle(
                      color: isMe ? Colors.white70 : Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                  if (isMe) SizedBox(width: 4),
                  if (isMe)
                    Icon(
                      message['status'] == 'read' ? Icons.done_all : Icons.done,
                      size: 16,
                      color:
                          message['status'] == 'read'
                              ? Colors.white
                              : Colors.white70,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildInputArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Icon(Icons.attach_file, color: Colors.grey),
          SizedBox(width: 8),
          Icon(Icons.camera_alt, color: Colors.grey),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type a message",
                border: InputBorder.none,
              ),
              onSubmitted: (_) => sendMessage(),
            ),
          ),
          GestureDetector(
            onTap: sendMessage,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: AppTheme.primaryColor,
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppTheme.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage("assets/images/google.png"),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("John Doe", style: TextStyle(fontSize: 16)),
                Text("Online", style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.video_call)),
          IconButton(onPressed: () {}, icon: Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return buildMessage(messages[index]);
              },
            ),
          ),
          buildInputArea(),
        ],
      ),
    );
  }

  void sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final now = TimeOfDay.now();
    final formattedTime =
        '${now.hour}:${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      messages.add({
        'message': text,
        'isMe': true,
        'time': formattedTime,
        'status': 'sent',
      });
    });

    _messageController.clear();

    // Scroll to bottom
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // 👇 الرد التلقائي بعد ثانيتين
    Future.delayed(Duration(seconds: 2), () {
      final replyTime = TimeOfDay.now();
      final replyFormattedTime =
          '${replyTime.hour}:${replyTime.minute.toString().padLeft(2, '0')}';

      String autoReply = getAutoReply(text); // نجيب رد مناسب للرسالة

      setState(() {
        messages.add({
          'message': autoReply,
          'isMe': false,
          'time': replyFormattedTime,
          'status': '',
        });
      });

      // Scroll بعد الرد
      Future.delayed(Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });
  }

  String getAutoReply(String userMessage) {
    userMessage = userMessage.toLowerCase();

    if (userMessage.contains("hello") || userMessage.contains("hi")) {
      return "Hello! How can I assist you?";
    } else if (userMessage.contains("how are you")) {
      return "I'm just a bot, but I'm doing great! 😄";
    } else if (userMessage.contains("thank")) {
      return "You're welcome!";
    } else if (userMessage.contains("bye")) {
      return "Goodbye! Have a nice day!";
    } else {
      return "Thank you for your message!";
    }
  }

  void showReactionMenu() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            contentPadding: EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check, color: Colors.green),
                  onPressed: () {
                    Navigator.pop(context);
                    // ضع هنا أي وظيفة تريد تنفيذها عند الضغط على الصح
                  },
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    Navigator.pop(context);
                    // وظيفة عند الضغط على الخطأ
                  },
                ),
                IconButton(
                  icon: Icon(Icons.emoji_emotions, color: Colors.orange),
                  onPressed: () {
                    Navigator.pop(context);
                    // وظيفة عند الضغط على الإيموجي
                  },
                ),
              ],
            ),
          ),
    );
  }

  // Widget buildMessage(Map<String, dynamic> message) {
  //   bool isMe = message['isMe'];

  //   return Align(
  //     alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
  //     child: Container(
  //       margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
  //       padding: const EdgeInsets.all(12),
  //       decoration: BoxDecoration(
  //         color: isMe ? Colors.blue[100] : Colors.grey[300],
  //         borderRadius: BorderRadius.circular(16),
  //       ),
  //       child: Stack(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.only(right: 24.0),
  //             child: Column(
  //               crossAxisAlignment:
  //                   isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
  //               children: [
  //                 Text(message['message']),
  //                 SizedBox(height: 4),
  //                 Text(
  //                   message['time'],
  //                   style: TextStyle(fontSize: 10, color: Colors.grey[600]),
  //                 ),
  //               ],
  //             ),
  //           ),

  //           // أيقونة "More"
  //           Positioned(
  //             top: 0,
  //             right: isMe ? -4 : null,
  //             left: isMe ? null : -4,
  //             child: IconButton(
  //               icon: Icon(Icons.more_vert, size: 18),
  //               onPressed: () {
  //                 showReactionMenu();
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

import 'package:flutter/material.dart';
import 'package:myprojectshop/screens/chat_screen.dart';
import 'package:myprojectshop/theme/theme.dart';

class ChatListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> chatList = [
    {
      'name': "khali 1",
      "lastMassage": "Hello, how are you?",
      "time": "10:30 AM",
      "unreadCount": 2,
      'avatar': "assets/images/pants.png",
      'isOnline': true,
      // C:\Users\Lenovo P53\Desktop\myprojectshop\assets\images\pants.png
    },
    {
      'name': "Ahmed ",
      "lastMassage": "Hello,?",
      "time": "10:30 AM",
      "unreadCount": 2,
      'avatar': "assets/images/google.png",
      'isOnline': false,
    },
    {
      'name': "Chat 1",
      "lastMassage": "Hello, how are you?",
      "time": "10:30 AM",
      "unreadCount": 2,
      'avatar': "assets/images/google.png",
      'isOnline': true,
    },
    {
      'name': "khali 1",
      "lastMassage": "Hello, how are you?",
      "time": "10:30 AM",
      "unreadCount": 2,
      'avatar': "assets/images/pants.png",
      'isOnline': true,
      // C:\Users\Lenovo P53\Desktop\myprojectshop\assets\images\pants.png
    },
    {
      'name': "Ahmed ",
      "lastMassage": "Hello,?",
      "time": "10:30 AM",
      "unreadCount": 2,
      'avatar': "assets/images/google.png",
      'isOnline': false,
    },
    {
      'name': "Chat 1",
      "lastMassage": "Hello, how are you?",
      "time": "10:30 AM",
      "unreadCount": 2,
      'avatar': "assets/images/google.png",
      'isOnline': true,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppTheme.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                title: Text(
                  'Massages',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Stack(
                  children: [
                    Positioned(
                      top: -50,
                      left: -50,
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  // Implement search functionality
                },
              ),
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {
                  // Implement more options functionality
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        hintText: 'Search Messages',
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: AppTheme.textsecandery),
                        hintStyle: TextStyle(
                          color: AppTheme.textsecandery,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: chatList.length,
                  itemBuilder: (context, index) {
                    final chat = chatList[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChatScreen()),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),

                        child: Row(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppTheme.primaryColor
                                      .withOpacity(0.1),
                                  radius: 30,
                                  child: Image.asset(
                                    chat['avatar'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                if (chat['isOnline'])
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: CircleAvatar(
                                      radius: 8,
                                      backgroundColor: Colors.green,
                                    ),
                                  ),
                              ],

                              // child: ListTile(
                              //   leading: CircleAvatar(
                              //     backgroundImage: NetworkImage(chat['avatar']),
                              //     radius: 30,
                              //   ),
                              //   title: Text(
                              //     chat['name'],
                              //     style: TextStyle(
                              //       fontWeight: FontWeight.bold,
                              //       color: AppTheme.textPrimary,
                              //     ),
                              //   ),
                              //   subtitle: Text(
                              //     chat['lastMassage'],
                              //     style: TextStyle(color: AppTheme.textsecandery),
                              //   ),
                              //   trailing: Column(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: [
                              //       Text(
                              //         chat['time'],
                              //         style: TextStyle(
                              //           color: AppTheme.textsecandery,
                              //           fontSize: 12,
                              //         ),
                              //       ),
                              //       if (chat['unreadCount'] > 0)
                              //         CircleAvatar(
                              //           radius: 10,
                              //           backgroundColor: AppTheme.primaryColor,
                              //           child: Text(
                              //             chat['unreadCount'].toString(),
                              //             style: TextStyle(
                              //               color: Colors.white,
                              //               fontSize: 12,
                              //             ),
                              //           ),
                              //         ),
                              //     ],
                              //   ),
                              //   onTap: () {
                              //     // Navigate to chat details screen
                              //   },
                              // ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    chat['name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textPrimary,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    chat['lastMassage'],
                                    style: TextStyle(
                                      color: AppTheme.textsecandery,
                                      fontSize:
                                          chat['unreadCount'] == 0 ? 13 : 14,
                                      fontWeight:
                                          chat['unreadCount'] == 0
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                ],
                              ),
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chat['time'],
                                  style: TextStyle(
                                    color: AppTheme.textsecandery,
                                    fontSize:
                                        chat['unreadCount'] == 0 ? 12 : 13,
                                    fontWeight:
                                        chat['unreadCount'] == 0
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4),
                                if (chat['unreadCount'] > 0)
                                  CircleAvatar(
                                    radius: 10,
                                    backgroundColor: AppTheme.primaryColor,
                                    child: Text(
                                      chat['unreadCount'].toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

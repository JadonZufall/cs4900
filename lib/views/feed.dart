import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  FeedPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(18, 25, 33, 1),
      appBar: AppBar(
        title: const Text('Feed Page'),
        backgroundColor: const Color.fromRGBO(18, 25, 33, 1),
        foregroundColor: Colors.white,
      ),
      // CREATES A SCROLL VIEW, MODIFY NUMBER OF POSTS BY USING THE CHILD COUNT, WILL NEED TO BE POPULATED WITH INFORMATION FROM FIREBASE
      body: CustomScrollView(slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Column(
                children: [
                  Container(
                    width: 375,
                    height: 54,
                    color: const Color.fromRGBO(18, 25, 33, 1),
                    child: Center(
                      child: ListTile(
                        leading: ClipOval(
                          child: SizedBox(
                            width: 35,
                            height: 35,
                            child: Image.asset('assets/images/bloop.jpg'), // WILL NEED FIREBASE PROFILE PHOTO OF UPLOADER
                          ),
                        ),
                        title: const Text(
                          'username', // WILL NEED FIREBASE USERNAME OF UPLOADER
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 375,
                    height: 375,
                    child: Image.asset(
                      'assets/images/bloop.jpg', // THIS IS THE ACTUAL POST IMAGE FROM USER
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: 375,
                    color: const Color.fromRGBO(18, 25, 33, 1),
                    child: Column(
                      // THIS IS THE LIKE / COMMENT / SHARE BAR
                      children: [
                        SizedBox(height: 14),
                        Row(
                          children: [
                            SizedBox(width: 14),
                            const Icon(
                              Icons.favorite_outline,
                              size: 25,
                              color: Colors.white,
                            ),
                            SizedBox(width: 17),
                            Image.asset(
                              'assets/images/comment.webp',
                              height: 28,
                            ),
                            SizedBox(width: 17),
                            Image.asset(
                              'assets/images/send.png',
                              height: 25,
                            ),
                          ],
                        ),
                        // THIS IS THE LIKES
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 15, top: 13.5, bottom: 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Likes 0', // WILL NEED TO BE REPLACED WITH NUMBER OF LIKES FROM FIREBASE
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Date',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color.fromRGBO(81, 111, 145, 1),
                              ),
                            ),
                          ),
                        ),
                        // THIS IS THE CAPTION SECTION
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Text(
                                'username ', // WILL NEED TO BE REPLACED WITH THE ACTUAL POSTS USERNAME
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'caption', // WILL NEED TO BE REPLACED WITH THE ACTUAL POSTS CAPTION
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            // DEFINES HOW MANY POSTS TO BE LOADED IN FEED
            childCount: 10,
          ),
        ),
      ]),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finstagram/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class FeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FeedPageState();
  }
}

class _FeedPageState extends State<FeedPage> {
  FirebaseService? _firebaseService;
  double? _deviceHeight, _deviceWidth;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _deviceHeight!,
      width: _deviceWidth!,
      child: _postsListView(),
    );
  }

  Widget _postsListView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseService?.getLatestPosts(),
      builder: (BuildContext context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          List _posts = _snapshot.data!.docs.map((e) => e.data()).toList();
          return ListView.builder(
            itemCount: _posts.length,
            itemBuilder: (context, index) {
              Map _post = _posts[index];
              return Container(
                height: _deviceHeight! * 0.30,
                margin: EdgeInsets.symmetric(
                  vertical: _deviceHeight! * 0.01,
                  horizontal: _deviceWidth! * 0.05,
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      _post["image"],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_paginator/flutter_paginator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import './login.dart';
import '../classes/Post.dart';
import './post.dart';

final storage = FlutterSecureStorage();

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();

  Future<bool> _attemptLogout() async {
    String token = await storage.read(key: 'access_token');
    Uri uri = Uri.http('said.saysusolutions.site', 'api/auth/logout');
    var response = await http.post(uri, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    });

    if (response.statusCode == 200) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('POSTS'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => {
              Scaffold.of(context).openDrawer(),
            },
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                bool res = await _attemptLogout();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              }),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: Image.asset(
                "images/logo_h.png",
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.article),
              title: Text('Posts'),
              onTap: () => {},
            ),
          ],
        ),
      ),
      body: Paginator.listView(
        key: paginatorGlobalKey,
        pageLoadFuture: fetchPosts,
        pageItemsGetter: listItemsGetter,
        listItemBuilder: listItemBuilder,
        loadingWidgetBuilder: loadingWidgetMaker,
        errorWidgetBuilder: errorWidgetMaker,
        emptyListWidgetBuilder: emptyListWidgetMaker,
        totalItemsGetter: totalPagesGetter,
        pageErrorChecker: pageErrorChecker,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Refresh future
          paginatorGlobalKey.currentState
              .changeState(pageLoadFuture: fetchPosts, resetState: true);
        },
        child: Icon(Icons.refresh),
      ),
    );
  }

  // Future of posts
  Future<PostData> fetchPosts(int page) async {
    try {
      String token = await storage.read(key: 'access_token');
      Uri uri = Uri.http(
          'said.saysusolutions.site', 'api/posts', {'page': page.toString()});
      http.Response response = await http.get(uri, headers: {
        'Authorization': "Bearer ${token ?? ''} ",
        'Accept': "application/json"
      });
      print(response.statusCode);
      if (response.statusCode == 200) {
        return PostData.fromResponse(response);
      } else {
        throw Exception();
      }
    } catch (e) {
      if (e is IOException) {
        return PostData.withError('Please check your internet connection.');
      } else {
        return PostData.withError('Something went wrong.');
      }
    }
  }

  // Get items data list
  List<Post> listItemsGetter(PostData postData) {
    List<Post> list = [];
    postData.posts.forEach((value) {
      list.add(value);
    });
    return list;
    // return postData.posts;
  }

  // Total item getter
  int totalPagesGetter(PostData postData) {
    return postData.totalPage;
  }

  // List item builder
  Widget listItemBuilder(post, index) {
    return ListTile(
      isThreeLine: true,
      leading: FadeInImage.assetNetwork(
        placeholder: "images/post.png",
        image: "https://via.placeholder.com/150?text=${post.id}",
      ),
      title: Text(
        post.title,
        maxLines: 1,
      ),
      subtitle: Text(
        post.body,
        maxLines: 2,
      ),
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostPage(post: post)),
        )
      },
    );
  }

  // Loading widget builder
  Widget loadingWidgetMaker() {
    return Container(
      alignment: Alignment.center,
      height: 160.0,
      child: CircularProgressIndicator(),
    );
  }

  // Empty widget maker
  Widget emptyListWidgetMaker(PostData postData) {
    return Center(
      child: Text('No posts in the list'),
    );
  }

  // Error widget maker
  Widget errorWidgetMaker(PostData postData, retryListener) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(postData.errorMessage),
        ),
        FlatButton(
          onPressed: retryListener,
          child: Text('Retry'),
        )
      ],
    );
  }

  // Page error checker
  bool pageErrorChecker(PostData postData) {
    return postData.statusCode != 200;
  }
}

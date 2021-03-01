import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_paginator/flutter_paginator.dart';

import '../classes/Post.dart';
import './post.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();

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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              //
            },
          ),
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
      Uri uri = Uri.http(
          'said.saysusolutions.site', 'api/posts', {'page': page.toString()});
      http.Response response = await http.get(uri);
      return PostData.fromResponse(response);
    } catch (e) {
      if (e is IOException) {
        return PostData.withError('Please check your internet connection.');
      } else {
        print(e.toString());
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

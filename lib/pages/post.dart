import 'package:flutter/material.dart';

// Clases
import '../classes/Post.dart';

class PostPage extends StatelessWidget {
  final Post post;

  PostPage({Key key, this.post}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${post.title}'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () => {
              // 
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.black12,
            child: Image.asset(
                'images/post_full.png',
                fit: BoxFit.fitWidth,
                width: double.infinity,
              ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    '${post.title}',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    '${post.body}',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

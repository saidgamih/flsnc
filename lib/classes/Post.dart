import 'dart:convert';
import 'package:http/http.dart' as http;

class PostData {
  int totalPage;
  List<Post> posts = []; // Holds posts fetched
  String errorMessage; // holds error message
  int statusCode;

  // Set posts list with values
  PostData.fromResponse(http.Response response) {
    statusCode = response.statusCode; // everything is all right
    Map data = jsonDecode(response.body);
    totalPage = data["total"];
    data['data'].forEach((item) {
      this.posts.add(Post.fromJson(item));
    });
  }
  // when an error message occures this will be used for constructor
  PostData.withError(String errorMessage) {
    this.errorMessage = errorMessage;
  }
}

// Post model
class Post {
  int id;
  String title;
  String body;

  Post({this.id, this.title, this.body});

  Post.fromJson(dynamic json) {
    id = json["id"];
    title = json["title"];
    body = json["body"];
  }
}

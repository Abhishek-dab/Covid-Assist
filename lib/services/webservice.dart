import 'dart:convert';

import 'package:covid_assist/model/news_info.dart';
import 'package:http/http.dart';

class ApiService {
  var url = Uri.parse(
      "https://newsapi.org/v2/top-headlines?country=in&q=covid&sortBy=popularity&apiKey=Your_API_KEY");

  Future<List<Article>> getArticle() async {
    Response res = await get(url);

    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);

      List<dynamic> body = json['articles'];

      List<Article> articles =
          body.map((dynamic item) => Article.fromJson(item)).toList();

      return articles;
    } else {
      throw ("Error Occured");
    }
  }
}

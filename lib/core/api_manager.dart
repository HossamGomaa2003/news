import 'package:dio/dio.dart';
import 'package:news/core/constans.dart';
import 'package:news/models/search_news.dart';
import 'package:news/models/sources_response.dart';
import '../models/news_response.dart';

class ApiManager {
  static final dio = Dio();

  static Future<SourcesResponse?> getSources(String category) async {
    try {
      Response response = await dio.get(
          "$BASEURL/v2/top-headlines/sources?apiKey=$APIKEY&category=$category");
      SourcesResponse sourcesResponse = SourcesResponse.fromJson(response.data);
      return sourcesResponse;
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }

  static Future<NewsResponse?> getNewsData(String sourceId) async {
    try {
      Response response = await dio.get(
          "$BASEURL/v2/everything?sources=$sourceId&apiKey=$APIKEY");

      NewsResponse newsResponse = NewsResponse.fromJson(response.data);
      return newsResponse;
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }

  static Future<SearchNews> getSearchData() async {
    try {
      Response response = await dio.get(
        "$BASEURL/v2/everything?q=flutter&language=en&sortBy=publishedAt&apiKey=$APIKEY",
      );

      SearchNews searchNews = SearchNews.fromJson(response.data);
      return searchNews;
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }
}

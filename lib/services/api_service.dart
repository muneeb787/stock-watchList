import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/artical_model.dart';
import 'package:http/http.dart' as http;
import '../models/chart_model.dart';
import '../models/latest_stock_model.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;

class ApiService {
  final endPointUrl =
      "https://www.alphavantage.co/query?function=NEWS_SENTIMENT&tickers=AAPL&apikey=<YOUR_API_KEY>";
  List<Article> newsList = [];

  Future<List<Article>> getArticle() async {
    final parsedUrl = Uri.parse(endPointUrl);
    final response = await http.get(parsedUrl);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final feed = data['feed'];
      //print(feed);
      if (feed != null && feed is List<dynamic>) {
        //print('1');
        newsList = feed.map((e) => Article.fromJson(e)).toList();
        //print(newsList[0].title);
      } else {
        debugPrint('Feed is null or not a list');
      }
    } else {
      debugPrint('Failed to fetch data');
    }
    return newsList;
  }

  Future<List<latestStockData>> fetchStockPrice() async {
    List<latestStockData> gettedData = [];
    String apiUrl =
        'https://query1.finance.yahoo.com/v7/finance/quote?symbols=ADBE,AMZN,AAPL,META,F,FOX,GOOGL,HPQ,INTC,OR,MA,MCD,MBG,MSFT,NESN,NFLX,NKE,ORCL,TSLA,VZ,WMT';

    http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> quotes = data['quoteResponse']['result'];

      quotes.forEach((element) {
        //print(element);
        gettedData.add(latestStockData.fromJson(element));
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return gettedData;
  }

  Future<List<latestStockData>> fetchStockPriceIND(String symbolName) async {
    List<latestStockData> gettedData = [];
    String apiUrl =
        'https://query1.finance.yahoo.com/v7/finance/quote?symbols=$symbolName';

    http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> quotes = data['quoteResponse']['result'];

      quotes.forEach((element) {
        //print(element);
        gettedData.add(latestStockData.fromJson(element));
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return gettedData;
  }
}

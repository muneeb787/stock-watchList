import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:charts_flutter_new/charts_flutter_new.dart' as charts;
import 'package:charts_flutter_new/flutter.dart' as charts;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Market Graph',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class TimeSeriesSales {
  final DateTime time;
  final double sales;

  TimeSeriesSales(this.time, this.sales);
}

class _MyHomePageState extends State<MyHomePage> {
  bool _loadingData = true;
  List<charts.Series<TimeSeriesSales, DateTime>> _seriesData = [
    charts.Series<TimeSeriesSales, DateTime>(
      id: 'Sales',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (TimeSeriesSales sales, _) => sales.time,
      measureFn: (TimeSeriesSales sales, _) => sales.sales,
      data: [],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Market Graph'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 300,
          child: Center(
            child: _loadingData
                ? CircularProgressIndicator()
                : charts.TimeSeriesChart(
                    _seriesData,
                    animate: true,
                    dateTimeFactory: const charts.LocalDateTimeFactory(),
                  ),
          ),
        ),
      ),
    );
  }

  // Helper method to fetch the stock market data from the API
  void _fetchData() async {
    var apiUrl =
        'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=TSLA&apikey=F2Q51WP33SABX727';
    var response = await http.get(Uri.parse(apiUrl));
    var data = jsonDecode(response.body)['Time Series (Daily)']
        as Map<String, dynamic>;

    setState(() {
      var newData = data.entries
          .map((entry) => TimeSeriesSales(
              DateTime.parse(entry.key), double.parse(entry.value['4. close'])))
          .toList();
      _seriesData[0] = charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: newData,
      );
      _loadingData = false;
    });

    // Fetch new data every minute
    Future.delayed(Duration(minutes: 1)).then((_) => _fetchData());
  }
}

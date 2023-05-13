import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stocks/models/portfolio_model.dart';

import '../models/latest_stock_model.dart';
import '../models/recent_investment_model.dart';
import '../models/stock_list.dart';
import '../services/api_service.dart';
import 'chart_practice.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:http/http.dart' as http;

class SingleStockScreen extends StatefulWidget {
  String symbolName;
  int listIndex;
  SingleStockScreen(this.symbolName, this.listIndex);

  @override
  State<SingleStockScreen> createState() => _SingleStockScreenState();
}

class _SingleStockScreenState extends State<SingleStockScreen> {
  bool _loadingData = true;
  bool isAlertSet = false;
  TextEditingController noOfShares = TextEditingController();

  List<charts.Series<TimeSeriesSales, DateTime>> seriesData = [
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
    // TODO: implement initState
    _fetchData(widget.symbolName);
    super.initState();
  }

  void _openBottomSheet(BuildContext context, final price) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: noOfShares,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter No of Shares',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      int shares = int.parse(noOfShares.text.toString());
                      print(shares);
                      final totalPrice = shares * price;
                      print(price);
                      print(totalPrice);
                      List<RecentInvestment> abc = [];
                      final cname =
                          StockList().listofStock[widget.listIndex].name;
                      final symbol =
                          StockList().listofStock[widget.listIndex].symbol;
                      final url =
                          StockList().listofStock[widget.listIndex].imageUrl;
                      if (totalPrice > balance) {
                        showDialogBox();
                        setState(() => isAlertSet = true);
                      } else {
                        balance -= totalPrice;
                        recentInvestments.add(
                          RecentInvestment(
                            companyName: cname.toString(),
                            symbol: symbol.toString(),
                            noOfShares: shares,
                            investment: double.parse(totalPrice.toString()),
                            perSharePrice: price,
                            url: url,
                          ),
                        );
                        Navigator.pop(context);
                      }
                      print(recentInvestments);
                    });
                  },
                  child: Text('Buy'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StockList().listofStock[widget.listIndex].name),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: FutureBuilder<List<latestStockData>>(
          future: ApiService().fetchStockPriceIND(widget.symbolName),
          builder: (context, snapshot) {
            //print(snapshot.data?.first.price);
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.amberAccent),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              StockList()
                                  .listofStock[widget.listIndex]
                                  .imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  StockList()
                                      .listofStock[widget.listIndex]
                                      .name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 27,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  StockList()
                                      .listofStock[widget.listIndex]
                                      .symbol,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "\$ ${snapshot.data?.first.price}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  '${snapshot.data?.first.change.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        height: 250,
                        child: Center(
                          child: _loadingData
                              ? const CircularProgressIndicator()
                              : charts.TimeSeriesChart(
                                  seriesData,
                                  animate: true,
                                  dateTimeFactory:
                                      const charts.LocalDateTimeFactory(),
                                ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              "Open Price",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              snapshot.data![0].open.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              "High Price",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              snapshot.data![0].high.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              "Low Price",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              snapshot.data![0].low.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              "Close Price",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              snapshot.data![0].close.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              "Volume",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              snapshot.data![0].volume.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              _openBottomSheet(
                                  context, snapshot.data?.first.price);
                            },
                            child: const Text('Buy')),
                        ElevatedButton(
                            onPressed: () {}, child: const Text('Sell')),
                      ],
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error loading data'),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.blueGrey,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _fetchData(String symbolName) async {
    var apiUrl =
        'https://query1.finance.yahoo.com/v8/finance/chart/$symbolName?interval=1d&range=1mo';
    var response = await http.get(Uri.parse(apiUrl));
    var data = jsonDecode(response.body)['chart']['result'][0]['timestamp']
        as List<dynamic>;
    var data1 = jsonDecode(response.body);
    setState(() {
      var newData = data
          .map((entry) => TimeSeriesSales(
              DateTime.fromMillisecondsSinceEpoch(entry * 1000),
              //double.parse([data1.indexOf(entry)].toString()) ?? 0.0,
              double.parse(data1['chart']['result'][0]['indicators']['quote'][0]
                          ['close'][data.indexOf(entry)]
                      .toString()) ??
                  0.0))
          .toList();
      seriesData[0] = charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: newData,
      );
      _loadingData = false;
    });

    // Fetch new data every minute
    Future.delayed(const Duration(minutes: 1))
        .then((_) => _fetchData(widget.symbolName));
  }

  showDialogBox() => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('No Enough Balance'),
          content: const Text(
              'TO Bye the Shares of this company,You nmust have balance in your account'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
}

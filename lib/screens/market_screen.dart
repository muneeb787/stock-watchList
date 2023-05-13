// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../models/latest_stock_model.dart';
import '../services/api_service.dart';

class MarketScreen extends StatefulWidget {
  MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Text(
                'Market',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.blueGrey.withOpacity(0.8),
                    ),
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text('Symbol'),
                  ),
                  // Container(

//  margin: EdgeInsets.symmetric(vertical: 10),                 //     padding: EdgeInsets.all(3),
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(3),
                  //       color: Colors.blueGrey.withOpacity(0.8),
                  //     ),
                  //     width: MediaQuery.of(context).size.width / 7,
                  //     child: Text('Bid')),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.blueGrey.withOpacity(0.8),
                      ),
                      width: MediaQuery.of(context).size.width / 7,
                      child: Text('HIgh')),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.blueGrey.withOpacity(0.8),
                      ),
                      width: MediaQuery.of(context).size.width / 7,
                      child: Text('Low')),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.blueGrey.withOpacity(0.8),
                      ),
                      width: MediaQuery.of(context).size.width / 7,
                      child: Text('Change')),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.blueGrey.withOpacity(0.8),
                      ),
                      width: MediaQuery.of(context).size.width / 5,
                      child: Text('Volumn')),
                ],
              ),
              Expanded(
                child: FutureBuilder<List<latestStockData>>(
                  future: ApiService().fetchStockPrice(),
                  builder: (context, snapshot) {
                    //print(snapshot.data?.length);
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.blueGrey.withOpacity(0.8),
                                ),
                                width: MediaQuery.of(context).size.width / 7,
                                child: Text(
                                  snapshot.data![index].symbol.toString(),
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              // Container(
                              // margin: EdgeInsets.symmetric(vertical: 10),
                              //   padding: EdgeInsets.all(3),
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(3),
                              //     color: Colors.blueGrey.withOpacity(0.8),
                              //   ),
                              //   width: MediaQuery.of(context).size.width / 7,
                              //   child: Text(snapshot.data![index].open
                              //       .toStringAsFixed(2)),
                              // ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.blueGrey.withOpacity(0.8),
                                ),
                                width: MediaQuery.of(context).size.width / 7,
                                child: Text(snapshot.data![index].high
                                    .toStringAsFixed(2)),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.blueGrey.withOpacity(0.8),
                                ),
                                width: MediaQuery.of(context).size.width / 7,
                                child: Text(snapshot.data![index].low
                                    .toStringAsFixed(2)),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.blueGrey.withOpacity(0.8),
                                ),
                                width: MediaQuery.of(context).size.width / 7,
                                child: Text(snapshot.data![index].close
                                    .toStringAsFixed(2)),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.blueGrey.withOpacity(0.8),
                                ),
                                width: MediaQuery.of(context).size.width / 5,
                                child: Text(snapshot.data![index].volume
                                    .toStringAsFixed(0)),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error loading data'),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

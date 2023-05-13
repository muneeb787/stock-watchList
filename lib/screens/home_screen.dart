import 'package:flutter/material.dart';
import 'package:stocks/screens/single_stock_screen.dart';

import '../models/latest_stock_model.dart';
import '../models/stock_list.dart';
import '../services/api_service.dart';
import '../models/portfolio_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Container(
          color: Colors.black38,
          child: FutureBuilder<List<latestStockData>>(
            future: ApiService().fetchStockPrice(),
            builder: (context, snapshot) {
              //print(snapshot.data?.length);
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SingleStockScreen(
                              snapshot.data![index].symbol.toString(), index);
                        }));
                      },
                      child: Card(
                        elevation: 3,
                        color: Colors.blueGrey.withOpacity(0.8),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                StockList().listofStock[index].imageUrl,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            StockList().listofStock[index].name,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(snapshot.data![index].symbol.toString()),
                          trailing: Text(
                            '\$ ${snapshot.data![index].price.toString()} ',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
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
      ),
    );
  }
}

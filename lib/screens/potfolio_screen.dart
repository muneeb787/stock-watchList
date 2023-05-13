import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stocks/screens/login_screen.dart';
import '../models/latest_stock_model.dart';
import '../models/portfolio_model.dart';
import '../models/portfolio_model.dart';
import '../services/api_service.dart';

class PotfolioScreen extends StatefulWidget {
  const PotfolioScreen({super.key});

  @override
  State<PotfolioScreen> createState() => _PotfolioScreenState();
}

class _PotfolioScreenState extends State<PotfolioScreen> {
  TextEditingController _textEditingController = TextEditingController();
  double apiPrice = 0;
  double change = 0;

  void _openBottomSheet(BuildContext context) {
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
                  controller: _textEditingController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter your text',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      print(_textEditingController.text.toString());
                      balance +=
                          double.parse(_textEditingController.text.toString());
                    });
                  },
                  child: Text('Add Balance'),
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
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Portfolio',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white),
                ),
                GestureDetector(
                    onTap: () {
                      FirebaseAuth _auth = FirebaseAuth.instance;
                      _auth.signOut();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginApp();
                      }));
                    },
                    child: Icon(
                      Icons.logout,
                      color: Colors.white,
                    )),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Balance',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                Row(
                  children: [
                    Text(
                      '\$ ${balance}',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        print('object');
                        _openBottomSheet(context);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100)),
                          child: Icon(Icons.add)),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Recent Investments',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: recentInvestments.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Container(
                            width: 50,
                            height: 50,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child:
                                    Image.asset(recentInvestments[index].url))),
                        title: Text(
                            recentInvestments[index].companyName.toString()),
                        subtitle: Row(
                          children: [
                            Text(recentInvestments[index].symbol),
                            SizedBox(
                              width: 10,
                            ),
                            FutureBuilder<List<latestStockData>>(
                                future: ApiService().fetchStockPriceIND(
                                    recentInvestments[index].symbol),
                                builder: (context, snapshot) {
                                  apiPrice = double.parse(
                                      snapshot.data!.first.price.toString());
                                  change = apiPrice -
                                      recentInvestments[index].perSharePrice;
                                  //print(snapshot.data?.first.price);
                                  if (snapshot.hasData) {
                                    return Text(
                                        '- \$ ${snapshot.data?.first.price.toStringAsFixed(3)}');
                                  } else if (snapshot.hasError) {
                                    return const Center(
                                      child: Text('Error loading data'),
                                    );
                                  } else {
                                    return Center(
                                      child: Text('-'),
                                    );
                                  }
                                }),
                          ],
                        ),
                        trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$ ${recentInvestments[index].investment.toStringAsFixed(3)}',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                '${recentInvestments[index].perSharePrice.toString()} - ${recentInvestments[index].noOfShares.toString()}',
                              ),
                              Text(
                                '${(apiPrice - recentInvestments[index].perSharePrice).toStringAsFixed(3)}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        change > 0 ? Colors.green : Colors.red),
                              ),
                            ]),
                      ),
                    );
                  }),
            )
          ],
        ),
      )),
    );
  }
}

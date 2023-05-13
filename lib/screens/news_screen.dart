import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../models/artical_model.dart';
import '../widgets/news_list_element.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ApiService client = ApiService();
    client.getArticle();
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              'Stock News',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            const Icon(
              Icons.book_online,
              color: Colors.white,
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder(
              future: client.getArticle(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Article>> snapshot) {
                //let's check if we got a response or not
                if (snapshot.hasData) {
                  //Now let's make a list of articles
                  // List<Article> articles = snapshot.data;
                  return Expanded(
                    child: ListView.builder(
                        //Now let's create our custom List tile
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return customListTile(snapshot.data![index], context);
                        }),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}

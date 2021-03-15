import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news/domain/article_response_data_model.dart';
import 'package:flutter_news/domain/error_response.dart';

import 'web_view_page.dart';

class NewsHomePage extends StatefulWidget {
  @override
  _NewsHomePageState createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              "Discover",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<ArticleResponseDataModel>(
                future: getAllArticlesData("elon musk"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.articles.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildNewsCard(snapshot.data.articles[index]),
                          );
                        });
                }),
          ),
        ],
      ),
    ));
  }

  Widget buildNewsCard(Articles data) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            blurRadius: 2,
            color: Colors.grey[200],
            spreadRadius: 2,
            offset: Offset.fromDirection(120, 4))
      ], borderRadius: BorderRadius.circular(5), color: Colors.white),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => WebViewPage(data.url)));
        },
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flex(
              direction: Axis.horizontal,
              verticalDirection: VerticalDirection.up,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      data.urlToImage,
                      height: 120,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  flex: 5,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${data.source.name} | ${data.author}",
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          data.title,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          data.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          maxLines: 4,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          data.publishedAt,
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<ArticleResponseDataModel> getAllArticlesData(String keywords) async {
    Dio _dio = Dio();
    Response response;
    Options options =
        Options(headers: {"X-Api-Key": "c386cc39b83d4021b732dcad942f74e9"});
    try {
      response = await _dio.get(
          "https://newsapi.org/v2/everything?q=${keywords}",
          options: options);
      final _data = response.data;
      print(_data['articles'].length);
      return ArticleResponseDataModel.fromJson(response.data);
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.RESPONSE:
          final _resultError = e.response.data;
          throw (ErrorResponse.fromJson(_resultError));
          break;

        default:
          throw (Exception("Something Wrong"));
          break;
      }
    }
  }
}

import 'package:flutter/material.dart';

class NewsHomePage extends StatefulWidget {
  @override
  _NewsHomePageState createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: ListView.builder(itemBuilder: (context, index) {
      return Card(
        child: Container(
          height: 150,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: 100,
                  width: double.infinity,
                  child: Image.network(
                    "https://techcrunch.com/wp-content/uploads/2021/02/GettyImages-1137834974-1.jpg?w=600",
                    scale: 1,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  child: Text("TEST"),
                ),
              )
            ],
          ),
        ),
      );
    })));
  }
}

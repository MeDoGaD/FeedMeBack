import 'package:flutter/material.dart';

class InsertQuote extends StatefulWidget {
  _InsertQuoteState createState() => _InsertQuoteState();
}

var textColor = Colors.white;

class _InsertQuoteState extends State<InsertQuote> {
  @override
  Widget build(BuildContext context) {
    double scwidth = MediaQuery.of(context).size.width;
    double scheight = MediaQuery.of(context).size.height;
    return (Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.only(top: scheight * 1 / 12),
        child: Center(
          child: Column(
            children: [
              Text(
                'Insert Quote',
                style: TextStyle(
                    color: Colors.yellow[100],
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              SizedBox(
                height: scheight * 1 / 25,
              ),
              Container(
                width: scwidth * 0.9,
                height: scheight * 0.71,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.yellow[200], width: 1)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: TextField(
                        style: TextStyle(color: textColor, fontSize: 18),
                        maxLines: 1,
                        decoration: InputDecoration(
                            hintText: 'Title',
                            hintStyle:
                                TextStyle(fontSize: 22, color: Colors.white30)),
                      ),
                    ),
                    Center(
                      child: Text(
                        '_________',
                        style: TextStyle(color: Colors.yellow[200]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Container(
                          height: scheight * 0.55,
                          child: TextField(
                            style: TextStyle(color: textColor, fontSize: 16),
                            decoration: InputDecoration(
                                hintText: 'Type your Quote here .... ',
                                hintStyle: TextStyle(
                                    fontSize: 20, color: Colors.white30)),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        height: scheight * 1 / 20,
                        child: Row(
                          children: [
                            SizedBox(
                              width: scwidth * 1 / 90,
                            ),
                            GestureDetector(
                                onTap: () {
                                  textColor = Colors.red;
                                  setState(() {});
                                },
                                child: Container(
                                  width: scwidth * 1 / 12,
                                  height: scheight * 1 / 25,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle),
                                )),
                            SizedBox(
                              width: scwidth * 1 / 90,
                            ),
                            GestureDetector(
                                onTap: () {
                                  textColor = Colors.deepPurpleAccent;
                                  setState(() {});
                                },
                                child: Container(
                                  width: scwidth * 1 / 12,
                                  height: scheight * 1 / 25,
                                  decoration: BoxDecoration(
                                      color: Colors.deepPurpleAccent,
                                      shape: BoxShape.circle),
                                )),
                            SizedBox(
                              width: scwidth * 1 / 90,
                            ),
                            GestureDetector(
                                onTap: () {
                                  textColor = Colors.deepOrange;
                                  setState(() {});
                                },
                                child: Container(
                                  width: scwidth * 1 / 12,
                                  height: scheight * 1 / 25,
                                  decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      shape: BoxShape.circle),
                                )),
                            SizedBox(
                              width: scwidth * 1 / 90,
                            ),
                            GestureDetector(
                                onTap: () {
                                  textColor = Colors.blue;
                                  setState(() {});
                                },
                                child: Container(
                                  width: scwidth * 1 / 12,
                                  height: scheight * 1 / 25,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle),
                                )),
                            SizedBox(
                              width: scwidth * 1 / 90,
                            ),
                            GestureDetector(
                                onTap: () {
                                  textColor = Colors.yellow;
                                  setState(() {});
                                },
                                child: Container(
                                  width: scwidth * 1 / 12,
                                  height: scheight * 1 / 25,
                                  decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      shape: BoxShape.circle),
                                )),
                            SizedBox(
                              width: scwidth * 1 / 90,
                            ),
                            GestureDetector(
                                onTap: () {
                                  textColor = Colors.green;
                                  setState(() {});
                                },
                                child: Container(
                                  width: scwidth * 1 / 12,
                                  height: scheight * 1 / 25,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle),
                                )),
                            SizedBox(
                              width: scwidth * 1 / 90,
                            ),
                            GestureDetector(
                                onTap: () {
                                  textColor = Colors.grey;
                                  setState(() {});
                                },
                                child: Container(
                                  width: scwidth * 1 / 12,
                                  height: scheight * 1 / 25,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle),
                                )),
                            SizedBox(
                              width: scwidth * 1 / 90,
                            ),
                            GestureDetector(
                                onTap: () {
                                  textColor = Colors.greenAccent;
                                  setState(() {});
                                },
                                child: Container(
                                  width: scwidth * 1 / 12,
                                  height: scheight * 1 / 25,
                                  decoration: BoxDecoration(
                                      color: Colors.greenAccent,
                                      shape: BoxShape.circle),
                                )),
                            SizedBox(
                              width: scwidth * 1 / 90,
                            ),
                            GestureDetector(
                                onTap: () {
                                  textColor = Colors.white;
                                  setState(() {});
                                },
                                child: Container(
                                  width: scwidth * 1 / 12,
                                  height: scheight * 1 / 25,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: scheight * 1 / 33,
              ),
              RaisedButton(
                color: Colors.yellow[300],
                onPressed: () {
                  //TODO Insert to database
                },
                child: Text(
                  'Sumbit Quote',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

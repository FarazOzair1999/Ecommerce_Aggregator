import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:new_argon/api.dart';
import 'package:new_argon/navbar.dart';
import 'package:new_argon/searchbar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Argon',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _items = [];
  bool isChecked = false;
  double twidth = 150;
  List<String> websites = ['Alibaba', 'DHGate'];
  bool onPress = false;
  final searchText = TextEditingController();
  final moqText = TextEditingController();
  final maxpText = TextEditingController();
  final minpText = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchText.dispose();
    moqText.dispose();
    maxpText.dispose();
    minpText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<String> websites = ["Alibaba", "DHGate", "EcPlaza", "MadeInChina"];

    return Scaffold(
      drawer: navbar(),
      appBar: AppBar(
        backgroundColor: const Color(0xff04292a),
        centerTitle: true,
        title: const Text(
          'Argon',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // head search bar
          Container(
            color: const Color.fromARGB(240, 244, 249, 255),
            width: double.infinity,
            height: (height) * 0.30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 10,
                  child: Container(
                      height: 60,
                      width: width * 0.42,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Row(
                        children: [
                          // icon
                          Container(
                            padding: const EdgeInsets.all(3),
                            child: Icon(
                              Icons.search_outlined,
                              color: const Color(0xff04292a),
                              size: (width) * 0.04,
                              // Announced in accessibility modes (e.g TalkBack/VoiceOver). This label does not show in the UI.
                            ),
                          ),
                          // text box
                          SizedBox(
                            height: 50,
                            width: width * 0.27,
                            child: TextField(
                              controller: searchText,
                              cursorHeight: 20,
                              cursorColor: Color(0xff01696e),
                              decoration: InputDecoration(
                                hoverColor: Colors.white,
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Enter a search term',
                              ),
                            ),
                          ),
                          // button
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox(
                              height: height * 0.08,
                              width: width * 0.10,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: const Color(0xff01696e)),
                                child: const Text('Search'),
                                onPressed: () async {
                                  setState(() {
                                    onPress = true;
                                  });
                                  var Data = await Getdata(
                                      'http://localhost:5000/run/?query=' +
                                          searchText.text.toString() +
                                          '&moq=' +
                                          moqText.text.toString() +
                                          '&minp=' +
                                          minpText.text.toString() +
                                          '&maxp=' +
                                          maxpText.text.toString());
                                  var DecodedData = jsonDecode(Data);
                                  setState(() {
                                    _items = DecodedData["products"];
                                  });
                                },
                                // ignore: prefer_const_constructors
                              ),
                            ),
                          )
                        ],
                      )),
                ),
                // filters
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //moq input
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //moq
                          Container(
                            child: const Text(
                              'Min. Order Quantity:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            padding: const EdgeInsets.all(10),
                          ),
                          Container(
                            height: 40,
                            width: twidth,
                            child: TextField(
                              controller: moqText,
                              cursorHeight: 20,
                              cursorColor: const Color(0xff01696e),
                              decoration: InputDecoration(
                                hoverColor: Color.fromARGB(255, 255, 255, 255),
                                border: InputBorder.none,
                                fillColor: Color.fromARGB(255, 255, 255, 255),
                                filled: true,
                                hintText: 'MOQ',
                              ),
                            ),
                          ),
                        ],
                      ),
                      // max price input
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: const Text(
                              'Maximum Price:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            padding: const EdgeInsets.all(10),
                          ),
                          Container(
                            height: 40,
                            width: twidth,
                            child: TextField(
                              controller: maxpText,
                              cursorHeight: 20,
                              cursorColor: const Color(0xff01696e),
                              decoration: InputDecoration(
                                hoverColor: Color.fromARGB(255, 255, 255, 255),
                                border: InputBorder.none,
                                fillColor: Color.fromARGB(255, 255, 255, 255),
                                filled: true,
                                hintText: 'Max. Price',
                              ),
                            ),
                          ),
                        ],
                      ),
                      //min price input
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: const Text(
                              'Minimum Price:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            padding: const EdgeInsets.all(10),
                          ),
                          Container(
                            height: 40,
                            width: twidth,
                            child: TextField(
                              controller: minpText,
                              cursorHeight: 20,
                              cursorColor: const Color(0xff01696e),
                              decoration: InputDecoration(
                                hoverColor: Color.fromARGB(255, 255, 255, 255),
                                border: InputBorder.none,
                                fillColor: Color.fromARGB(255, 255, 255, 255),
                                filled: true,
                                hintText: 'Min. Price',
                              ),
                            ),
                          ),
                        ],
                      ),
                      // apply filters
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //moq
                          Container(
                            child: const Text(
                              'Apply Filters:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            padding: const EdgeInsets.all(10),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 10,
          ),
          // products
          _items.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: height * 0.60,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 2),
                      shrinkWrap: true,
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return Expanded(
                          child: Card(
                            elevation: 10,
                            shadowColor: const Color(0xff01696e),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //image display
                                Container(
                                  height: double.infinity,
                                  width: width * 0.20,
                                  child: Image.network(
                                    _items[index]['image'] ??
                                        'https://bitsofco.de/content/images/2018/12/broken-1.png',
                                    fit: BoxFit.fill,
                                    alignment: Alignment.center,
                                  ),
                                ),

                                Container(
                                  margin: EdgeInsets.all(10),
                                  width: width * 0.25,
                                  child: Column(
                                    children: [
                                      // Primary information
                                      ListTile(
                                          title: Text(
                                            _items[index]['name'].toString(),
                                            style: GoogleFonts.roboto(),
                                          ),
                                          subtitle: Text(
                                            'Price range: ' +
                                                (_items[index]['price'] ??
                                                    'not available'),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black
                                                    .withOpacity(0.6)),
                                          )),
                                      // seller information
                                      Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              15.0, 0, 15, 15),
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius
                                                      .all(
                                                  Radius.circular(
                                                      5.0) //                 <--- border radius here
                                                  ),
                                              border: Border.all(
                                                  color:
                                                      const Color(0xff04292a))),
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 0, 0, 0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text(
                                                    'Review Count: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Text(_items[index]['review']
                                                          .toString() ??
                                                      'not available'),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Text('Experience: ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                  Text(_items[index]
                                                              ['seller_years']
                                                          .toString() ??
                                                      'not available'),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                      'Minimum Order Count: ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                  Text(_items[index]['MOQs']
                                                          .toString() ??
                                                      'not available'),
                                                ],
                                              ),
                                            ],
                                          )),
                                      // buttons
                                      ButtonBar(
                                        alignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: height * 0.03,
                                              width: 400,
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: Colors.blue),
                                                  child: const Text(
                                                      'Visit Website'),
                                                  onPressed: () {
                                                    _launchURL(
                                                        _items[index]['link']);
                                                  }
                                                  // ignore: prefer_const_constructors
                                                  ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: height * 0.03,
                                              width: 400,
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: const Color(
                                                              0xff01696e)),
                                                  child:
                                                      const Text('Save Item'),
                                                  onPressed: () {}
                                                  // ignore: prefer_const_constructors
                                                  ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                //ratings

                                // buttons
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : Center(
                  child: onPress ? CircularProgressIndicator() : Container())
        ],
      ),
    );
  }
}

_launchURL(String url) async {
  if (!await launchUrl(
    Uri.parse(url),
    mode: LaunchMode.externalApplication,
    // webViewConfiguration: const WebViewConfiguration(enableJavaScript: false),
  )) throw 'Could not launch';
}

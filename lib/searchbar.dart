import 'package:flutter/material.dart';

class searchbar extends StatelessWidget {
  double width;
  double height;
  double twidth = 150;
  bool isChecked;
  final JsonCallback go;
  final StateCallback state;

  searchbar(this.width, this.height, this.go, this.state, this.isChecked);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(240, 244, 249, 255),
      width: double.infinity,
      height: (height) * 0.35,
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
                      child: const TextField(
                        cursorHeight: 20,
                        cursorColor: const Color(0xff04292a),
                        decoration: const InputDecoration(
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
                          onPressed: go,
                          // ignore: prefer_const_constructors
                        ),
                      ),
                    )
                  ],
                )),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      child: const TextField(
                        cursorHeight: 20,
                        cursorColor: const Color(0xff04292a),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //moq
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
                      child: const TextField(
                        cursorHeight: 20,
                        cursorColor: const Color(0xff04292a),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //moq
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
                      child: const TextField(
                        cursorHeight: 20,
                        cursorColor: const Color(0xff04292a),
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
                    Container(
                      child: Switch(
                        value: isChecked,
                        onChanged: (bool value) {
                          state(value);
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

typedef JsonCallback = void Function();
typedef StateCallback = void Function(bool d);

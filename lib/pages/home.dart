import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chaquopy/chaquopy.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int cells = 1;
  List ditems = [
    'Run',
    'Share',
    'Delete'
  ];
  String output = '';
  List<TextEditingController> textEditingControllers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingControllers.add(TextEditingController());
  }
  @override
  void dispose() {
    super.dispose();
    // dispose textEditingControllers to prevent memory leaks
    for (TextEditingController textEditingController in textEditingControllers) {
      textEditingController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Pytter'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height:MediaQuery.of(context).size.height*0.8,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: cells+1,
                    itemBuilder: (BuildContext context, int index) {
                  if (index == cells) {
                    return Center(
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              child: Text('New cell', style: TextStyle(color: Colors.white),),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.black
                              ),
                              onPressed: () {
                                setState(() {
                                  cells += 1;
                                });
                                textEditingControllers.add(TextEditingController());
                              },
                            ),
                            SizedBox(width: 20,),
                            TextButton(
                              child: Text('Delete', style: TextStyle(color: Colors.white),),
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.black
                              ),
                              onPressed: () {
                                setState(() {
                                  cells -= 1;
                                });
                                textEditingControllers.removeAt(textEditingControllers.length);
                              },
                            )
                          ],
                        )
                      ),
                    );
                  } else {
                    return Card(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width-60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                              color: Colors.grey
                            ),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  controller: textEditingControllers[index],
                                  decoration: InputDecoration(
                                    hintText: "Enter Code",
                                    enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                                  cursorColor: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                              color: Colors.black,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.play_circle_fill, color: Colors.white,),
                              onPressed: () async {
                                final _result = await Chaquopy.executeCode(textEditingControllers[index].text);
                                setState(() {
                                  output = _result['textOutputOrError'].toString();
                                });
                              },
                            )
                          )
                        ],
                      ),
                    );
                  }
                }),
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.2,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, -2), // changes position of shadow
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'OUTPUT',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Divider(height: 10,),
                      Text(
                        output,
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy, color: Colors.white,),
                        onPressed: () {
                          Clipboard.setData(new ClipboardData(text: output));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Copied to clipboard'),
                            backgroundColor: Colors.green,
                          ));
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

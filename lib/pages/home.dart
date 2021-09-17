import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chaquopy/chaquopy.dart';

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
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height:MediaQuery.of(context).size.height*0.8,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: cells+1,
                    itemBuilder: (BuildContext context, int index) {
                  if (index == cells) {
                    return Center(
                      child: SizedBox(
                        width: 100,
                        height: 50,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RaisedButton(
                              child: Text('New Cell'),
                              onPressed: () {
                                setState(() {
                                  cells += 1;
                                });
                                textEditingControllers.add(TextEditingController());
                              },
                            ),
                            SizedBox(width: 20,),
                            RaisedButton(
                              child: Text('Delete'),
                              onPressed: () {
                                print("stop");
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 70,
                            width: MediaQuery.of(context).size.width-60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                              color: Colors.blueGrey[100]
                            ),
                            child: SizedBox(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  controller: textEditingControllers[index],
                                  decoration: InputDecoration(
                                    hintText: "Enter Code"
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height:70,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                              color: Colors.yellow[700],
                            ),
                            child: IconButton(
                              icon: Icon(Icons.play_circle_fill),
                              onPressed: () async {
                                final _result = await Chaquopy.executeCode(textEditingControllers[index].text);
                                setState(() {
                                  output = _result['textOutputOrError'].toString();
                                });
                              },
                            )
                            /*DropdownButton(
                              icon: Icon(Icons.more_vert),
                              items: [
                                DropdownMenuItem(child: Text('Run'), onTap: () async {
                                  final _result = await Chaquopy.executeCode(textEditingControllers[index].text);
                                  setState(() {
                                    output = _result.toString();
                                  });
                                }),
                                DropdownMenuItem(child: Text('Clear'), onTap: () {textEditingControllers[index].clear();}),
                                DropdownMenuItem(child: Text('Delete'), onTap: () {
                                  setState(() {
                                    cells -= 1;
                                  });
                                })
                              ]
                            )*/
                          )
                        ],
                      ),
                    );
                  }
                }),
              ),
              output == '' ? Container() : Container(
                height: MediaQuery.of(context).size.height*0.2,
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Text(
                        'OUTPUT',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Divider(height: 10,),
                      Text(
                        output,
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
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

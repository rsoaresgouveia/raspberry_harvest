import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:raspberry_harvest/entities/requests.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController ipController = new TextEditingController(),
      pathController = new TextEditingController(),
      gpioController = new TextEditingController(),
      portController = new TextEditingController();
  Request request = Request();
  bool hasErr = false;
  List<String> rStringList = [];
  String errString = '';
  final dio = Dio();
  List<String> itemBuilder = [
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23",
    "24",
    "25",
    "26",
    "27"
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Raspberry Harvest"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(hintText: "IP"),
                  controller: ipController,
                ),
              ),
            ),
            // Flexible(
            //   flex: 1,
            //   child: Container(
            //     padding: EdgeInsets.all(10),
            //     child: TextField(
            //       decoration: InputDecoration(hintText: "Port"),
            //       controller: portController,
            //     ),
            //   ),
            // ),
            Divider(
              height: 10,
            ),
            Flexible(
              flex: 5,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 100,
                    childAspectRatio: 3 / 2.5,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2),
                itemCount: itemBuilder.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(width: 2, color: Colors.grey)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.light_mode),
                          onPressed: () async {
                            try {
                              await dio.post<String>(
                                  "http://" +
                                      ipController.text +
                                      ":7777" +
                                      "/" +
                                      "toogle",
                                  queryParameters: {
                                    "gpio": itemBuilder[index],
                                  }).then((r) {
                                setState(() {
                                  print(r.data);
                                  rStringList.insert(
                                      0,
                                      r.statusCode.toString() +
                                          " - GPIO " +
                                          itemBuilder[index] +
                                          " toogled");

                                  hasErr = false;
                                });
                              });
                            } catch (e) {
                              setState(() {
                                errString = itemBuilder[index] +
                                    " - Error on comunication to the server";
                                hasErr = true;
                              });
                              print(e);
                            }
                          },
                        ),
                        Text(itemBuilder[index])
                      ],
                    ),
                  );
                },
              ),
            ),
            Text(
              "Histórico",
              style: TextStyle(fontSize: 25),
            ),
            Flexible(
              flex: 2,
              child: hasErr
                  ? SingleChildScrollView(
                      child: Container(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            errString,
                            style: TextStyle(
                                color: hasErr ? Colors.red : Colors.black),
                          )),
                    )
                  : ListView.builder(
                      itemCount: rStringList.length,
                      itemBuilder: (context, ind) {
                        return Center(
                          child: Container(
                            padding: EdgeInsets.all(3),
                            child: Text(rStringList[ind]),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

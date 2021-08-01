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
      gpioController = new TextEditingController();
  Request request = Request();
  String rString = '', result = '';
  String errString = '';
  final dio = Dio();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Raspberry Harvest"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: Column(
                children: [
                  Text("IP"),
                  TextField(
                    controller: ipController,
                  ),
                  Container(
                    child: Text("PATH"),
                  ),
                  TextField(
                    controller: pathController,
                  ),
                  Container(
                    child: Text("GPIO"),
                  ),
                  TextField(
                    controller: gpioController,
                    keyboardType: TextInputType.number,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 50),
                  ),
                  Text(rString.toString()),
                  Text(errString.toString()),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await dio.post<String>(
                            "http://" +
                                ipController.text +
                                ":7777" +
                                "/" +
                                pathController.text,
                            queryParameters: {
                              "gpio": gpioController.text
                            }).then((r) {
                          setState(() {
                            print(r.data);
                            rString = r.statusCode.toString();
                          });
                        });
                      } catch (e) {
                        setState(() {
                          errString = e.toString();
                        });
                        print(e);
                      }
                    },
                    child: Text("Send Request"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///final fullPath = "http://"+ipController.text + "/" + pathController.text;
//                       final queries = {"gpio":gpioController.text};

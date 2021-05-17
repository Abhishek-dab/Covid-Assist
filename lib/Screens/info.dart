import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:covid_assist/Screens/indiadetails.dart';

class StateIndia extends StatefulWidget {
  @override
  _StateIndiaState createState() => _StateIndiaState();
}

class _StateIndiaState extends State<StateIndia> {
  @override
  ApiData apiData;
  var decodedJson;

  Future<List<ApiData>> getData() async {
    var url = Uri.parse("https://api.covid19india.org/data.json");
    var res = await http.get(url);

    decodedJson = jsonDecode(res.body);

    List<ApiData> data = [];
    for (var u in decodedJson["statewise"]) {
      apiData = ApiData(
          u["state"],
          u["confirmed"],
          u["active"],
          u["recovered"],
          u["deaths"],
          u["deltaconfirmed"],
          u["deltadeaths"],
          u["deltarecovered"]);
      data.add(apiData);
    }
    return data;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('India Covid Cases'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: getData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return (snapshot.data == null)
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () => {
                              Navigator.of(context).push(
                                  MaterialPageRoute<Null>(
                                      builder: (BuildContext context) {
                                return IndiaDetail(
                                    snapshot.data[index].state,
                                    snapshot.data[index].total,
                                    snapshot.data[index].active,
                                    snapshot.data[index].recovered,
                                    snapshot.data[index].death,
                                    snapshot.data[index].new_cases,
                                    snapshot.data[index].new_deaths,
                                    snapshot.data[index].deltarecovered);
                              }))
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 12,
                              margin: EdgeInsets.all(12),
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.notes_rounded),
                                      Text(
                                        "${snapshot.data[index].state}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Roboto',
                                          letterSpacing: 2,
                                          wordSpacing: 2,
                                          fontWeight: FontWeight.w500,
                                          shadows: [
                                            Shadow(
                                                color: Colors.black12,
                                                offset: Offset(2, 1))
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 12.0,
                                      ),
                                      Container(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "Total Cases: ${snapshot.data[index].total.toString()}",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            Text(
                                              "Deaths: ${snapshot.data[index].death.toString()}",
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                            Text(
                                              "Recovered: ${snapshot.data[index].recovered.toString()}",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ApiData {
  final String state;
  final String total;
  final String active;
  final String recovered;
  final String death;
  final String new_cases;
  final String new_deaths;
  final String deltarecovered;

  ApiData(this.state, this.total, this.active, this.recovered, this.death,
      this.new_cases, this.new_deaths, this.deltarecovered);
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pie_chart/pie_chart.dart';

class IndiaDetail extends StatefulWidget {
  var state,
      total,
      active,
      recovered,
      death,
      new_cases,
      new_deaths,
      new_recovered;
  IndiaDetail(this.state, this.total, this.active, this.recovered, this.death,
      this.new_cases, this.new_deaths, this.new_recovered);

  @override
  _IndiaDetailState createState() => _IndiaDetailState(state, total, active,
      recovered, death, new_cases, new_deaths, new_recovered);
}

class _IndiaDetailState extends State<IndiaDetail> {
  @override
  void initState() {
    _dataMap.putIfAbsent('cases', () => double.parse(widget.total));
    _dataMap.putIfAbsent('deaths', () => double.parse(widget.death));
    _dataMap.putIfAbsent('recovered', () => double.parse(widget.recovered));

    super.initState();
  }

  Map<String, double> _dataMap = Map();

  var state,
      total,
      active,
      recovered,
      death,
      new_cases,
      new_deaths,
      new_recovered;
  _IndiaDetailState(
    this.state,
    this.total,
    this.active,
    this.recovered,
    this.death,
    this.new_cases,
    this.new_deaths,
    this.new_recovered,
  );

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(state),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 28.0, width: 8.0),
            PieChart(
              dataMap: _dataMap,
              animationDuration: Duration(milliseconds: 500),
              chartLegendSpacing: 40.0,
              chartRadius: MediaQuery.of(context).size.width / 2.5,
              colorList: [
                Colors.deepOrange,
                Colors.deepPurpleAccent,
                Colors.red,
              ],
              initialAngleInDegree: 0,
              legendOptions: LegendOptions(
                showLegends: true,
                legendPosition: LegendPosition.right,
              ),
              chartType: ChartType.disc,
              chartValuesOptions: ChartValuesOptions(
                showChartValuesInPercentage: true,
                showChartValues: true,
                showChartValuesOutside: true,
                chartValueBackgroundColor: Colors.grey[200],
                decimalPlaces: 1,
              ),
            ),
            SizedBox(height: 18.0),
            colorCard(
                "Total Cases", total, context, new_cases, Colors.deepOrange),
            colorCard("Total Deaths", death, context, new_deaths,
                Colors.deepPurpleAccent),
            colorCard(
                "Recoverd", recovered, context, new_recovered, Colors.red),
          ],
        ),
      ),
    );
  }
}

class ApiData {
  final String district;
  final int total;
  final int new_cases;
  ApiData(this.district, this.total, this.new_cases);
}

Widget colorCard(String text, String fields, BuildContext context,
    String new_cases, Color color) {
  return Container(
    margin: EdgeInsets.only(top: 9, right: 9),
    padding: EdgeInsets.all(25),
    height: 100,
    width: 250,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(17),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          text,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            Text(
              "${fields.toString()}",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            (new_cases == "" || new_cases == "0")
                ? Container()
                : Icon(
                    Icons.arrow_upward,
                    color: Colors.yellow,
                    size: 12,
                  ),
            (new_cases == "" || new_cases == "0")
                ? Container()
                : Text(new_cases),
          ],
        )
      ],
    ),
  );
}

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:covid_assist/model/nearbyHosp.dart';
import 'package:covid_assist/model/marker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class HospMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentPosition = Provider.of<Position>(context);
    final markerservice = MarkerService();

    Future<List<Hospital>> fetchPlace() async {
      List<Hospital> lists = [];
      if (currentPosition != null) {
        var lat = currentPosition.latitude.toString(),
            lng = currentPosition.longitude.toString();

        var url = Uri.parse(
            "https://api.tomtom.com/search/2/search/hospital.json?key=YOUR_API_KEY&limit=30&lat=$lat&lon=$lng&radius=10000000");
        var response =
            await http.get(url, headers: {'Accept': 'application/json'});
        var getData = json.decode(response.body);
        var listsJson = getData['results'];
        for (var itmes in listsJson) {
          var poi = itmes['poi'];
          var name = poi['name'];
          var position = itmes['position'];
          var lat = position['lat'];
          var lon = position['lon'];
          var addpoi = itmes['address'];
          var add = addpoi['freeformAddress'];
          var id = itmes['id'];
          Hospital vari = Hospital(name, lat, lon, add, id);
          lists.add(vari);
        }
      }
      return lists;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Hospitals'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
          child: (currentPosition != null)
              ? FutureBuilder(
                  future: fetchPlace(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    var markers = (snapshot.data != null)
                        ? markerservice.getMarkers(snapshot.data)
                        : <Marker>[];
                    return (snapshot.data != null)
                        ? Column(
                            children: <Widget>[
                              Expanded(
                                child: ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 12,
                                        margin: EdgeInsets.all(12),
                                        child: ListTile(
                                          title: Text(
                                            snapshot.data[index].name,
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
                                          ),
                                          subtitle: Text(
                                            snapshot.data[index].addr,
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6)),
                                          ),
                                          trailing: IconButton(
                                            icon: Icon(
                                                Icons.keyboard_arrow_right),
                                            color:
                                                Theme.of(context).primaryColor,
                                            onPressed: () {
                                              _launchMaps(
                                                snapshot.data[index].name,
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 4),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                ),
                                height:
                                    MediaQuery.of(context).size.height / 2.5,
                                width: MediaQuery.of(context).size.width,
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                      target: LatLng(currentPosition.latitude,
                                          currentPosition.longitude),
                                      zoom: 16),
                                  zoomControlsEnabled: true,
                                  myLocationEnabled: true,
                                  markers: Set<Marker>.of(markers),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }

  void _launchMaps(String name) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$name near me';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Error Occured';
    }
  }
}

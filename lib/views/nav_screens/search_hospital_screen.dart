import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../google_map_backend/entity/hospital.dart';
import '../../google_map_backend/service/addmarker.dart';

class SearchHospitalScreen extends StatefulWidget {
  const SearchHospitalScreen({super.key});

  @override
  State<SearchHospitalScreen> createState() => _SearchHospitalScreenState();
}

class _SearchHospitalScreenState extends State<SearchHospitalScreen> {
  late GoogleMapController mapController;
  LatLng? _currentPosition;

  getLocation() async {
    try {
      LocationPermission permission;
      permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      // Handle location retrieval error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error getting location: $e"),
      ));
      setState(() {
        _currentPosition = null; // Or handle the error in another way
      });
    }
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = _currentPosition;
    final markerservice = MarkerService();

    Future<List<Hospital>> fetchPlace() async {
      List<Hospital> lists = [];
      if (currentPosition != null) {
        var key = 'OG0vuhDcqclx2TR94v0kkymYJXPc3axm',
            lat = currentPosition.latitude.toString(),
            lng = currentPosition.longitude.toString();
        var radius = '10000';
        var url = Uri.parse(
            'https://api.tomtom.com/search/2/search/hospital.json?key=$key&limit=30&lat=$lat&lon=$lng&radius=$radius');
        var response =
            await http.get(url, headers: {'Accept': 'application/json'});
        if (response.statusCode == 200) {
          var jsonuse = json.decode(response.body);
          var listsjson = jsonuse['results'];
          for (var h in listsjson) {
            var poi = h['poi'];
            var name = poi['name'];
            var score = h['score'];
            var dist = h['dist'];
            var pos = h['position'];
            var lat = pos['lat'];
            var lng = pos['lon'];
            var addpoi = h['address'];
            var add = addpoi['freeformAddress'];
            var id = h['id'];
            Hospital vari = Hospital(name, score, dist, lat, lng, add, id);
            lists.add(vari);
          }
        } else {
          // Handle API error
          throw Exception('Failed to load data');
        }
      }
      return lists;
    }

    return Scaffold(
      body: currentPosition != null
          ? FutureBuilder<List<Hospital>>(
              future: fetchPlace(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    var markers = markerservice.getMarkers(snapshot.data!);
                    return Column(
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 2.5,
                          width: MediaQuery.of(context).size.width,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                                target: LatLng(currentPosition.latitude,
                                    currentPosition.longitude),
                                zoom: 16),
                            zoomControlsEnabled: true,
                            myLocationEnabled: true,
                            mapType: MapType.normal,
                            zoomGesturesEnabled: true,
                            markers: Set<Marker>.of(markers),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  title:
                                  Text(snapshot.data![index].name),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          RatingBarIndicator(
                                            rating: snapshot
                                                .data![index].score,
                                            itemBuilder: (context,
                                                index) =>
                                                const Icon(Icons.star,
                                                    color:
                                                    Colors.amber),
                                            itemCount: 5,
                                            itemSize: 20.0,
                                            direction:
                                            Axis.horizontal,
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ((snapshot.data![index].dist) <
                                          1000)
                                          ? Text(
                                          '${snapshot.data![index].freeformAddress} \u00b7 ${(snapshot.data![index].dist).round()} Meters')
                                          : Text(
                                          '${snapshot.data![index].freeformAddress} \u00b7 ${double.parse((snapshot.data![index].dist / 1000).toStringAsFixed(2))} Kms'),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.directions),
                                    color: Theme.of(context)
                                        .primaryColor,
                                    onPressed: () {
                                      _launchMaps(
                                          snapshot.data![index].lat,
                                          snapshot.data![index].lng);
                                    },
                                  ),
                                  onTap: () {
                                    _launchMaps(
                                        snapshot.data![index].lat,
                                        snapshot.data![index].lng);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                } else {
                  return Center(
                      child: Text('State: ${snapshot.connectionState}'));
                }
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  void _launchMaps(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

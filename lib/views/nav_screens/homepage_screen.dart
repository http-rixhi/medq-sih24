import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../../google_map_backend/entity/hospital.dart';
import '../../google_map_backend/service/addmarker.dart';
import '../sub_screens/opd_registration_screen.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final TextEditingController _searchController = TextEditingController();

  late GoogleMapController mapController;
  LatLng? _currentPosition;

  getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
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

  String _sortBy = '';

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
        var radius = '10000000';
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
      appBar: AppBar(
        title: const Text("Home"),
        leading: const Icon(Icons.home),
      ),
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
                    markerservice.getMarkers(snapshot.data!);
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            // Add padding around the search bar
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            // Use a Material design search bar
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                // Add a clear button to the search bar
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () => _searchController.clear(),
                                ),
                                // Add a search icon or button to the search bar
                                prefixIcon: IconButton(
                                  icon: const Icon(Icons.search),
                                  onPressed: () {
                                    // Perform the search here
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Center(
                          child: Text(
                            "---------- Explore ----------",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _exploreBtn("OPD Registration",
                                const AssetImage("assets/images/opd.jpeg")),
                            _exploreBtn("Bed Availability",
                                const AssetImage("assets/images/bed.png")),
                            _exploreBtn("Nearest Hospitals",
                                const AssetImage("assets/images/hospital.png")),
                            _exploreBtn("Medcoins",
                                const AssetImage("assets/images/medcoin.png"))
                          ],
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                        const Center(
                          child: Text(
                            "---------- Nearby Hospitals ----------",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Row(
                            children: [
                              const Text(
                                "Sort By: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _sortBy = "distance";
                                    });
                                  },
                                  child: const Text("Distance")),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _sortBy = "name";
                                    });
                                  },
                                  child: const Text("Name")),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              if (_sortBy == "distance") {
                                snapshot.data!
                                    .sort((a, b) => a.dist.compareTo(b.dist));
                              } else if (_sortBy == "name") {
                                snapshot.data!
                                    .sort((a, b) => a.name.compareTo(b.name));
                              }
                              return Card(
                                child: ListTile(
                                  title: Text(snapshot.data![index].name),
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
                                            rating: 4,
                                            itemBuilder: (context, index) =>
                                                const Icon(Icons.star,
                                                    color: Colors.amber),
                                            itemCount: 5,
                                            itemSize: 20.0,
                                            direction: Axis.horizontal,
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ((snapshot.data![index].dist) < 1000)
                                          ? Text(
                                              '${snapshot.data![index].freeformAddress} \u00b7 ${(snapshot.data![index].dist).round()} Meters')
                                          : Text(
                                              '${snapshot.data![index].freeformAddress} \u00b7 ${double.parse((snapshot.data![index].dist / 1000).toStringAsFixed(2))} Kms'),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.directions),
                                    color: Theme.of(context).primaryColor,
                                    onPressed: () {
                                      _launchMaps(snapshot.data![index].lat,
                                          snapshot.data![index].lng);
                                    },
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                              Text(snapshot.data![index].name),
                                          actions: [
                                            Center(
                                                child: ElevatedButton(
                                              onPressed: () {},
                                              style: const ButtonStyle(
                                                  fixedSize:
                                                      WidgetStatePropertyAll(
                                                          Size(200, 45)),
                                                  alignment: Alignment.center),
                                              child:
                                                  const Text("Emergency SOS"),
                                            )),
                                            Center(
                                                child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            OpdRegistrationScreen(hospital: snapshot.data![index].name,)));
                                              },
                                              style: const ButtonStyle(
                                                  fixedSize:
                                                      WidgetStatePropertyAll(
                                                          Size(200, 45)),
                                                  alignment: Alignment.center),
                                              child: const Text(
                                                  "OPD Registration"),
                                            )),
                                            Center(
                                                child: ElevatedButton(
                                              onPressed: () {
                                                _launchMaps(
                                                    snapshot.data![index].lat,
                                                    snapshot.data![index].lng);
                                              },
                                              style: const ButtonStyle(
                                                  fixedSize:
                                                      WidgetStatePropertyAll(
                                                          Size(200, 45)),
                                                  alignment: Alignment.center),
                                              child: const Text("View Maps"),
                                            )),
                                          ],
                                        );
                                      },
                                    );
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

  _exploreBtn(String title, ImageProvider image) {
    return Container(
      height: 93,
      width: 75,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: image,
            height: 40,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            title,
            style: GoogleFonts.kanit(fontSize: 12),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

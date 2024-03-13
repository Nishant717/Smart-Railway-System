// ignore_for_file: unnecessary_brace_in_string_interps, prefer_final_fields, avoid_print, prefer_const_constructors, prefer_typing_uninitialized_variables, file_names, unused_import

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:project/screens/trainroute.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:project/trainModel.dart';

class LiveStation extends StatefulWidget {
  const LiveStation({super.key});

  @override
  State<LiveStation> createState() => _LiveStationState();
}

class _LiveStationState extends State<LiveStation> {
  var train;
  // var traiNumber;
  String startStationCode = '';
  // String destinationStationCode = 'ST';
  DateTime? selectedDate; // Variable to hold selected date

  @override
  void initState() {
    super.initState();
    print("Test");
    loadJsonData();
  }

  List<StationsBase> items = [];

  TextEditingController _startStationController = TextEditingController();

  void getdata() async {
    try {
      var response = await Dio().get(
          'https://indian-railway-api.cyclic.app/trains/stationLive?code=${startStationCode}'); // Use selectedDate here
      if (response.statusCode == 200) {
        setState(() {
          train = response.data["data"];
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadJsonData() async {
    // Load JSON data from the asset file
    String jsonData = await rootBundle.loadString('assets/data.json');
    Map<String, dynamic> jsonMap = json.decode(jsonData);

    List<dynamic> jsonList = jsonMap['data'];

    List<StationsBase> loadStations =
        jsonList.map((json) => StationsBase.fromJson(json)).toList();

    setState(() {
      items = loadStations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Train Ticket Booking'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  labelText: 'Station',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                controller: _startStationController),
            suggestionsCallback: (pattern) {
              return items.where((item) =>
                  item.name.toLowerCase().contains(pattern.toLowerCase()) ||
                  item.code.toLowerCase().contains(pattern.toLowerCase()));
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                  title: Text(suggestion.name),
                  subtitle: Text(suggestion.code));
            },
            onSuggestionSelected: (suggestion) {
              setState(() {
                _startStationController.text = suggestion.name;
                startStationCode = suggestion.code;
              });
            },
          ),
          SizedBox(height: 20),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: getdata,
            child: Text('Search Train'),
          ),
          SizedBox(height: 20),
          if (train != null)
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                final trainData = train[index]; // Use train variable here
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TrainRoute(trainNumber: trainData['train_no']),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${trainData['train_no']}',
                            style: TextStyle(
                              color: Colors.white,
                              backgroundColor: Colors.orangeAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(width: 13),
                          Text(
                            trainData['train_name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${trainData['source_stn_name']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(Icons.arrow_forward),
                                Text(
                                  '${trainData['dstn_stn_name']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  'Departure',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${trainData['time_at']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: train.length, // Use train.length here
            )
        ],
      ),
    );
  }
}

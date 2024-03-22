// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables, avoid_print, prefer_final_fields, unnecessary_brace_in_string_interps, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart'; // Import DateFormat
import 'package:project/screens/trainroute.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:project/trainModel.dart';

class TrainPage extends StatefulWidget {
  const TrainPage({Key? key}) : super(key: key);

  @override
  State<TrainPage> createState() => _TrainPageState();
}

class _TrainPageState extends State<TrainPage> {
  var train;
  // var traiNumber;
  bool isTrainAvailable = true;
  String startStationCode = '';
  String destinationStationCode = '';
  DateTime? selectedDate; // Variable to hold selected date

  @override
  void initState() {
    super.initState();
    print("Test");
    loadJsonData();
  }

  List<StationsBase> items = [];

  TextEditingController _startStationController = TextEditingController();
  TextEditingController _destinationStationController = TextEditingController();

  void getdata() async {
    try {
      var response = await Dio().get(
          'https://indian-railway-api.cyclic.app/trains/gettrainon?from=${startStationCode}&to=${destinationStationCode}&date=${DateFormat('dd-MM-yyyy').format(selectedDate ?? DateTime.now())}'); // Use selectedDate here
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

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
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
                  labelText: 'Starting Station',
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
          TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  labelText: 'Destination Station',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                controller: _destinationStationController),
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
                _destinationStationController.text = suggestion.name;
                destinationStationCode = suggestion.code;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _selectDate(context); // Call the date picker function
            },
            child: Text('Select Date'), // Change button text accordingly
          ),
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
                if (train != null && train is List && train!.isNotEmpty) {
                  final trainBase = train![index]['train_base'];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TrainRoute(trainNumber: trainBase['train_no']),
                        ),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '‎ ‎${trainBase['train_no']}‎ ‎',
                              style: TextStyle(
                                color: Colors.white,
                                backgroundColor: Colors.orangeAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              width: 13,
                            ),
                            Text(
                              trainBase['train_name'],
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${trainBase['from_stn_name']}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Icon(Icons.arrow_forward),
                                    Text(
                                      '${trainBase['to_stn_name']}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${trainBase['from_stn_code']}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // Icon(Icons.arrow_forward),
                                    Text(
                                      '${trainBase['to_stn_code']}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${trainBase['from_time']}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '-${trainBase['travel_time']}-',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${trainBase['to_time']}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  // Set isTrainAvailable to false to indicate no train data available
                  isTrainAvailable = false;
                  return SizedBox(); // Return an empty SizedBox
                }
              },
              itemCount: train?.length ?? 0,
            ),
          // Display "No train data available" message if isTrainAvailable is false
          if (!isTrainAvailable)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                          'assets/trainerror.webp')), // Your image asset
                  SizedBox(height: 16),
                  Text(
                    'No train available between the stations.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

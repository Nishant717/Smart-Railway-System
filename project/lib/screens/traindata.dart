// ignore_for_file: prefer_typing_uninitialized_variables, prefer_final_fields, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:project/screens/trainroute.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:fluttertoast/fluttertoast.dart';
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
  var traiNumber;
  String startStationCode = '';
  String destinationStationCode = '';

  @override
  void initState() {
    super.initState();
    print("Test");
    loadJsonData();
  }

  List<StationsBase> items = [];

  TextEditingController _startStationController = TextEditingController();
  TextEditingController _destinationStationController = TextEditingController();

  // void showToast() {
  //   Fluttertoast.showToast(
  //     msg: "This is a short toast",
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     timeInSecForIosWeb: 1,
  //     backgroundColor: Colors.black,
  //     textColor: Colors.white,
  //   );
  // }

  void getdata() async {
    try {
      // showToast();
      var response = await Dio().get(
          'https://indian-railway-api.cyclic.app/trains/betweenStations/?from=${startStationCode}&to=${destinationStationCode}');
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
    // print(jsonData);
    // // Decode the JSON data
    Map<String, dynamic> jsonMap = json.decode(jsonData);

    List<dynamic> jsonList = jsonMap['data'];

    // // Map the JSON data to a list of Person objects
    List<StationsBase> loadStations =
        jsonList.map((json) => StationsBase.fromJson(json)).toList();

    // print(loadStations);
    // // Update the state with the loaded data
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
          // TextField(
          //   controller: _startStationController,
          //   // onChanged: (text) {
          //   //   _destinationStationController.value =
          //   //       _destinationStationController.value.copyWith(
          //   //     text: text.toUpperCase(),
          //   //     selection: TextSelection.collapsed(offset: text.length),
          //   //   );
          //   // },
          //   decoration: InputDecoration(
          //     labelText: 'Starting Station',
          //     labelStyle: TextStyle(
          //       fontWeight: FontWeight.bold, // Font weight
          //       fontSize: 16.0, // Font size
          //     ),
          //   ),
          // ),
          // SizedBox(height: 20),
          // TextField(
          //   controller: _destinationStationController,
          //   // onChanged: (text) {
          //   //   _destinationStationController.value =
          //   //       _destinationStationController.value.copyWith(
          //   //     text: text.toUpperCase(),
          //   //     selection: TextSelection.collapsed(offset: text.length),
          //   //   );
          //   // },
          //   decoration: InputDecoration(
          //     labelText: 'Destination Station',
          //     labelStyle: TextStyle(
          //       fontWeight: FontWeight.bold, // Font weight
          //       fontSize: 16.0, // Font size
          //     ),
          //   ),
          // ),
          // SizedBox(height: 20),
          TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(labelText: 'Select an item'),
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
                decoration: InputDecoration(labelText: 'Select an item'),
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
            onPressed: getdata,
            child: Text('Search Train'),
          ),
          SizedBox(height: 20),

          if (train != null)
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
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
                      title: Text(
                        trainBase['train_name'],
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        trainBase['train_no'],
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: train!.length,
            ),
        ],
      ),
    );
  }
}

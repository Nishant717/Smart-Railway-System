// ignore_for_file: prefer_typing_uninitialized_variables, prefer_final_fields, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:project/screens/trainroute.dart';

class TrainPage extends StatefulWidget {
  const TrainPage({Key? key}) : super(key: key);

  @override
  State<TrainPage> createState() => _TrainPageState();
}

class _TrainPageState extends State<TrainPage> {
  var train;
  var traiNumber;

  TextEditingController _startStationController = TextEditingController();
  TextEditingController _destinationStationController = TextEditingController();

  void getdata() async {
    try {
      var response = await Dio().get(
          'https://indian-railway-api.cyclic.app/trains/betweenStations/?from=${_startStationController.text}&to=${_destinationStationController.text}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Train Ticket Booking'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          TextField(
            controller: _startStationController,
            // onChanged: (text) {
            //   _destinationStationController.value =
            //       _destinationStationController.value.copyWith(
            //     text: text.toUpperCase(),
            //     selection: TextSelection.collapsed(offset: text.length),
            //   );
            // },
            decoration: InputDecoration(
              labelText: 'Starting Station',
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold, // Font weight
                fontSize: 16.0, // Font size
              ),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _destinationStationController,
            // onChanged: (text) {
            //   _destinationStationController.value =
            //       _destinationStationController.value.copyWith(
            //     text: text.toUpperCase(),
            //     selection: TextSelection.collapsed(offset: text.length),
            //   );
            // },
            decoration: InputDecoration(
              labelText: 'Destination Station',
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold, // Font weight
                fontSize: 16.0, // Font size
              ),
            ),
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

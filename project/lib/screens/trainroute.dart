// ignore_for_file: prefer_typing_uninitialized_variables, prefer_final_fields, avoid_print, prefer_const_constructors, sized_box_for_whitespace

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TrainRoute extends StatefulWidget {
  final String trainNumber;

  const TrainRoute({Key? key, required this.trainNumber}) : super(key: key);

  @override
  State<TrainRoute> createState() => _TrainRouteState();
}

class _TrainRouteState extends State<TrainRoute> {
  var train;
  TextEditingController _trainNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _trainNumberController.text = widget.trainNumber;
  }

  void getdata() async {
    try {
      var trainNumber = _trainNumberController.text;
      var response = await Dio().get(
          'https://indian-railway-api.cyclic.app/trains/getRoute?trainNo=$trainNumber');
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
        title: Text('Train Route'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _trainNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter Train Number',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: getdata,
              child: Text('Get Route'),
            ),
            SizedBox(
              height: 20,
            ),
            if (train != null)
              Container(
                height: 680, // Set a fixed height for the ListView
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    final station = train[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          station['source_stn_name'],
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Arrive: ${station['arrive']}',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Depart: ${station['depart']}',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Distance: ${station['distance']}',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Day: ${station['day']}',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Zone: ${station['zone']}',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: train.length,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
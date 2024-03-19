// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class PnrStatus extends StatefulWidget {
  const PnrStatus({Key? key}) : super(key: key);

  @override
  State<PnrStatus> createState() => _PnrStatusState();
}

class _PnrStatusState extends State<PnrStatus> {
  final TextEditingController _pnrController = TextEditingController();
  Map<String, dynamic>? _trainData;

  void getdata() async {
    try {
      var pnr = _pnrController.text;
      var response = await Dio().get(
          'https://indian-railway-api.cyclic.app/trains/pnrstatus?pnr=$pnr');
      if (response.statusCode == 200) {
        setState(() {
          _trainData = response.data["data"];
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
        title: Text('PNR Status'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _pnrController,
              decoration: InputDecoration(
                labelText: 'Enter PNR number',
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: getdata,
              child: Text('Get Status'),
            ),
            if (_trainData != null) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDataRow(
                                'Train Number', '${_trainData!['TrainNo']}'),
                            _buildDataRow(
                                'Train Name', '${_trainData!['TrainName']}'),
                            _buildDataRow('Date', '${_trainData!['Doj']}'),
                            _buildDataRow('Boarding Point',
                                '${_trainData!['BoardingPoint']}'),
                            _buildDataRow('Reserved Upto',
                                '${_trainData!['ReservationUpto']}'),
                            _buildDataRow('Class', '${_trainData!['Class']}'),
                            _buildPassengerDetails(),
                            _buildDataRow(
                                'Total Fare', '${_trainData!['TicketFare']}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                value,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
          ],
        ),
        Divider(color: Colors.grey),
      ],
    );
  }

  Widget _buildPassengerDetails() {
    List<Widget> passengerRows = [];
    if (_trainData!['PassengerStatus'] != null) {
      for (var passenger in _trainData!['PassengerStatus']) {
        passengerRows.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Passenger ${passenger['Number']}:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Booking Status: ${passenger['BookingStatus']}'),
                        Text('Current Status: ${passenger['CurrentStatus']}'),
                        Text(
                            'Seat: ${passenger['Coach']} ${passenger['Berth']}'),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.grey),
            ],
          ),
        );
      }
    } else {
      passengerRows.add(Text('No passenger data available'));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: passengerRows,
    );
  }
}

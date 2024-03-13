// ignore_for_file: prefer_final_fields, prefer_const_constructors, avoid_print, unused_field, unused_import

import 'package:flutter/material.dart';
import 'package:project/screens/traindata.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Train'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                // Added Expanded to ensure each InkWell takes equal space
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/trains");
                  },
                  splashColor: Color.fromARGB(0, 220, 210, 210),
                  child: _buildCard(
                    'assets/train.avif',
                    'Book Train Ticket',
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/routes");
                  },
                  child: _buildCard(
                    'assets/route.avif',
                    'Check Train Route',
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: InkWell(
                  onTap: () {
                    // Handle check PNR status card tap
                  },
                  child: _buildCard(
                    'assets/tickets.avif',
                    'Check PNR Status',
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/station");
                  },
                  child: _buildCard(
                    'assets/station.avif',
                    'Live Station',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String imagePath, String text) {
    return Container(
      width: 300,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 8,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: Colors.blue, // You can adjust the color as needed
              ),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

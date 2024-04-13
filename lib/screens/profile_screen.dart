import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.blue, 
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 100, 
                height: 100, 
                decoration: BoxDecoration(
                  shape: BoxShape.circle, 
                  color: Color.fromARGB(255, 255, 255, 255), 
                ),
                child: Center(
                  child: Text(
                    'Lingkaran',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Text(
                'Nama: Ester',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Text(
                'Email: ester@gmail.com',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Text(
                'No. HP: 0815678239',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

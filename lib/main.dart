import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

enum Gender { male, female, other }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Gender? selectedGender = Gender.male;

  List<Gender> genderList = [Gender.male, Gender.female, Gender.other];

  int? selectedAge = 18;

  List<int> ageList = List<int>.generate(83, (i) => i + 18);

  @override
  initState() {
    super.initState();
    _loadItems();
  }

  List<String> _items = [];

  Future _loadItems() async {
    // call the function that returns a list
    List<String> items = await getData();
    items.sort();
    setState(() {
      _items = items;
    });
  }

  Future getData() async {
    var response = await http.get(
        Uri.parse('https://restcountries.com/v3.1/independent?status=true'));
    var jsonResponse = json.decode(response.body);
    List<String> countryNames = [];
    for (var country in jsonResponse) {
      String name = country['name']['common'];
      countryNames.add(name);
    }
    return countryNames;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: Text(
              'Registration Form',
              style: TextStyle(
                fontSize: 23.0,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.grey[900]),
        body: Container(
          margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          child: Form(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 40.0,
                  ),
                  Text(
                    'First Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2.0,
                        )),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ))),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Text(
                    'Last Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2.0,
                        )),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ))),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Text(
                    'Choose your age',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    child: DropdownButton<int>(
                      value: selectedAge,
                      hint: Text('Select your age'),
                      onChanged: (int? newValue) {
                        setState(() {
                          selectedAge = newValue;
                        });
                      },
                      items: ageList.map((int age) {
                        return DropdownMenuItem<int>(
                          value: age,
                          child: Container(
                            child: Text('$age'),
                            margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Text(
                    'Select your gender',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: genderList
                        .map(
                          (gender) => Expanded(
                            child: RadioListTile<Gender>(
                              title: Text(gender.toString().split('.').last),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 0.0),
                              value: gender,
                              groupValue: selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value;
                                });
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 20.0,),
                  Text(
                    'Select your location',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Your Country',
                      border: OutlineInputBorder(),
                    ),
                    items: _items.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      // do something with the selected value
                    },
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:myfi/viewCode.dart';

var database;
var data;

class Wifi {
  final int id;
  final String Title;
  final String Description;
  final String WifiName;
  final String WifiPass;
  final String Code;

  const Wifi(
      {required this.id,
      required this.Title,
      required this.Description,
      required this.WifiName,
      required this.WifiPass,
      required this.Code});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Title': Title,
      'Description': Description,
      'WifiName': WifiName,
      'WifiPass': WifiPass,
      'Code': Code
    };
  }

  @override
  String toString() {
    return 'Wifi{id: $id, Title: $Title, Description: $Description, WifiName: $WifiName, WifiPass: $WifiPass, Code: $Code}';
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
  database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'data.db'),
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE Wifi(id INTEGER PRIMARY KEY, Title TEXT, Description TEXT, WifiName TEXT, WifiPass TEXT, Code TEXT)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  data = await wifi();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyFi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 57, 83, 202),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
            ),
            onPressed: () async {
              data = await wifi();
              setState(() {});
            },
          ),
        ],
      ),
      body: data.isEmpty
          ? Center(
              child: Text('No Data'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => viewWifi(
                          dataIndex: index,
                        ),
                      ),
                    ).then((value) async {
                      data = await wifi();
                      setState(() {
                        // refresh state of Page1
                      });
                    });
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(data[index].Title),
                      subtitle: Text(data[index].Description),
                      trailing: Icon(Icons.keyboard_arrow_right_rounded),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => FullScreenDialog(),
              fullscreenDialog: true,
            ),
          ).then((value) {
            setState(() {
              // refresh state of Page1
            });
          });
        },
        label: const Text('Add Wifi'),
        icon: const Icon(Icons.wifi),
        backgroundColor: Color.fromARGB(255, 57, 83, 202),
      ),
    );
  }
}

final _formKey = GlobalKey<FormState>();

class FullScreenDialog extends StatefulWidget {
  FullScreenDialog({Key? key}) : super(key: key);

  @override
  State<FullScreenDialog> createState() => _FullScreenDialogState();
}

class _FullScreenDialogState extends State<FullScreenDialog> {
  @override
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final wifiNameController = TextEditingController();
  final wifiPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 57, 83, 202),
        title: Text('Add wifi'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    textInputAction: TextInputAction.next,
                    decoration:
                        const InputDecoration(labelText: 'Name (e.g My Wifi)'),
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: descController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                        labelText: 'Description (e.g Home Kitcken Wifi)'),
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: wifiNameController,
                    textInputAction: TextInputAction.next,
                    decoration:
                        const InputDecoration(labelText: 'Network Name (SSID)'),
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: wifiPassController,
                    textInputAction: TextInputAction.done,
                    decoration:
                        const InputDecoration(labelText: 'Network Password '),
                    onEditingComplete: () => FocusScope.of(context).unfocus(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        int ID = data.isEmpty ? 1 : data.length + 1;
                        var newData = Wifi(
                          id: ID,
                          Title: titleController.text,
                          Description: descController.text,
                          WifiName: wifiNameController.text,
                          WifiPass: wifiPassController.text,
                          Code: 'WIFI:S:' +
                              wifiNameController.text +
                              ';T:WPA;P:' +
                              wifiPassController.text +
                              ';;',
                        );
                        await insertWifi(newData);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Adding Wifi')),
                        );
                        data = await wifi();
                        setState(() {});
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> insertWifi(Wifi wifi) async {
  // Get a reference to the database.
  final db = await database;

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    'wifi',
    wifi.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Wifi>> wifi() async {
  // Get a reference to the database.
  final db = await database;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query('wifi');

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return Wifi(
      id: maps[i]['id'],
      Title: maps[i]['Title'],
      Description: maps[i]['Description'],
      WifiName: maps[i]['WifiName'],
      WifiPass: maps[i]['WifiPass'],
      Code: maps[i]['Code'],
    );
  });
}

Future<void> updateWifi(Wifi wifi) async {
  // Get a reference to the database.
  final db = await database;

  // Update the given Dog.
  await db.update(
    'wifi',
    wifi.toMap(),
    // Ensure that the Dog has a matching id.
    where: 'id = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [wifi.id],
  );
}

// data = Wifi(
//   id: data.id,
//   Title: data.Title,
//   Description: data.Description,
//   WifiName: data.WifiName,
//   WifiPass: data.WifiPass,
//   Code: data.Code,
// );
//await updateWifi(data);
//print(await wifi());

Future<void> deleteWifi(int id) async {
  // Get a reference to the database.
  final db = await database;

  // Remove the Dog from the database.
  await db.delete(
    'wifi',
    // Use a `where` clause to delete a specific dog.
    where: 'id = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [id],
  );
}

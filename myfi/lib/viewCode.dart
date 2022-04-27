import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfi/main.dart';
import 'package:qr_flutter/qr_flutter.dart';

class viewWifi extends StatefulWidget {
  final int dataIndex;
  const viewWifi({Key? key, required this.dataIndex}) : super(key: key);

  @override
  State<viewWifi> createState() => _viewWifiState();
}

class _viewWifiState extends State<viewWifi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data[widget.dataIndex].Title),
        actions: [
          IconButton(
            icon: Icon(
              Icons.create_rounded,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => editDialog(
                    dataIndex: widget.dataIndex,
                  ),
                ),
              ).then((value) async {
                data = await wifi();
                setState(() {
                  // refresh state of Page1
                });
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outlined,
            ),
            onPressed: () async {
              deleteWifi(data[widget.dataIndex].id);
              setState(() {});
              Navigator.pop(context);
            },
          ),
        ],
        backgroundColor: Color.fromARGB(255, 57, 83, 202),
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: QrImage(
          data: "WIFI:S:" +
              data[widget.dataIndex].WifiName +
              ";T:WPA;P:" +
              data[widget.dataIndex].WifiPass +
              ";;",
          version: QrVersions.auto,
          size: 300.0,
        ),
      ),
    );
  }
}

final _formKey = GlobalKey<FormState>();

class editDialog extends StatefulWidget {
  final int dataIndex;
  editDialog({Key? key, required this.dataIndex}) : super(key: key);

  @override
  State<editDialog> createState() => _editDialogState();
}

class _editDialogState extends State<editDialog> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final wifiNameController = TextEditingController();
  final wifiPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = data[widget.dataIndex].Title;
    descController.text = data[widget.dataIndex].Description;
    wifiNameController.text = data[widget.dataIndex].WifiName;
    wifiPassController.text = data[widget.dataIndex].WifiPass;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 57, 83, 202),
        title: Text('Edit wifi'),
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
                        var newData = Wifi(
                          id: data[widget.dataIndex].id,
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
                        await updateWifi(newData);

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

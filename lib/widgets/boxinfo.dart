import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skipsmaritiem/services/boxservice.dart';
import 'package:skipsmaritiem/widgets/archief.dart';
import '../models/boxmodel.dart'; // Import your Box model

import '../providers/boxprovider.dart';

class BoxInfo extends StatefulWidget {
  @override
  _BoxInfoState createState() => _BoxInfoState();
}

class _BoxInfoState extends State<BoxInfo> {
  bool fillBootnaam = false; // Add this variable to track the checkbox state

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _opmerkingenController = TextEditingController();
  TextEditingController _nummerController = TextEditingController();
  TextEditingController _lengteController = TextEditingController();
  TextEditingController _breedteController = TextEditingController();
  TextEditingController _datumController = TextEditingController();
  TextEditingController _bootnaamController = TextEditingController();
  TextEditingController _bootnaamvlhController = TextEditingController();
  TextEditingController _steigerController = TextEditingController();
  bool _status = false; // Default status

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BoxProvider activebox = Provider.of<BoxProvider>(context, listen: false);
    fillBootnaam = activebox.bootnaam != '';
    _opmerkingenController.text = activebox.opmerkingen ?? '';
    _nummerController.text = activebox.nummer ?? '';
    _lengteController.text = activebox.lengte?.toString() ?? '';
    _breedteController.text = activebox.breedte?.toString() ?? '';
    _datumController.text = activebox.datum?.toString() ?? '';
    _bootnaamController.text = activebox.bootnaam ?? '';
    _bootnaamvlhController.text = activebox.bootnaamvlh ?? '';
    _steigerController.text = activebox.steiger ?? '';
    _status = activebox.status ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Box Info'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context)
              .unfocus(); // Close keyboard when tapping outside
        },
        child: SingleChildScrollView(
          // Make the form scrollable
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
                    controller: _opmerkingenController,
                    decoration: InputDecoration(labelText: 'Opmerkingen'),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {}
                    }),
                TextFormField(
                  controller: _nummerController,
                  decoration: InputDecoration(labelText: 'Nummer'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nummer cannot be empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _lengteController,
                  decoration: InputDecoration(labelText: 'Lengte'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lengte cannot be empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _breedteController,
                  decoration: InputDecoration(labelText: 'Breedte'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Breedte cannot be empty';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _bootnaamController,
                        decoration: InputDecoration(labelText: 'Bootnaam'),
                        validator: (value) {
                          //  setState(() {fillBootnaam!=(value == null || value.isEmpty) ;});
                        },
                      ),
                    ),
                    Checkbox(
                      value: fillBootnaam,
                      onChanged: (value) {
                        setState(() {
                          fillBootnaam = value!;

                          if (fillBootnaam) {
                            activebox.bootnaam = "passant";
                            // Set "passant" in the "voornaam" field when the checkbox is checked
                            _bootnaamController.text = "passant";
                          } else {
                            // Clear the "voornaam" field when the checkbox is unchecked
                            _bootnaamController.text = "";
                            activebox.bootnaam = "";
                          }
                        });
                      },
                    ),
                  ],
                ),
                TextFormField(
                  controller: _bootnaamvlhController,
                  decoration: InputDecoration(labelText: 'Bootnaamvlh'),
                  //   validator: (value) {
                  //    if (value == null || value.isEmpty) {
                  //      return 'Bootnaamvlh cannot be empty';
                  //    }
                  //   return null;
                  // },
                ),
                TextFormField(
                  controller: _steigerController,
                  decoration: InputDecoration(labelText: 'Steiger'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Steiger cannot be empty';
                    }
                    return null;
                  },
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Update the fields in the BoxProvider
                          activebox.opmerkingen = _opmerkingenController.text;
                          activebox.nummer = _nummerController.text;
                          activebox.lengte =
                              double.parse(_lengteController.text);
                          activebox.breedte =
                              double.parse(_breedteController.text);
                          activebox.datum =
                              DateTime.parse(_datumController.text);
                          activebox.bootnaam = _bootnaamController.text;
                          activebox.bootnaamvlh = _bootnaamvlhController.text;
                          activebox.steiger = _steigerController.text;
                          activebox.status = _status;
                          if (activebox.opmerkingen != '') {
                            activebox.opmerkingen =
                                DateFormat('dd-MM-yyyy HH:mm')
                                        .format(DateTime.now()) +
                                    ' : ' +
                                    activebox.opmerkingen;
                          }

                          await BoxService().updateBox(activebox.box);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Changes saved')),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text('Save'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(child: BoxCalendar());//BoxCalendar());
                          },
                        );

                     //   Navigator.of(context).pop();
                      },
                      child: Text('Archief'),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

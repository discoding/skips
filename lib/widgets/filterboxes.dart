import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../assets/constants.dart';
import '../providers/fliterprovider.dart';

class BoxFilter extends StatefulWidget {
  @override
  _BoxFilterState createState() => _BoxFilterState();
}

class _BoxFilterState extends State<BoxFilter> {
  String selectedStatus = Constanten.status[0]; // Default value
  String verhuurd = Constanten.huurstatus[0]; // Default value
  String bezetDoor = Constanten.bezet[0]; // Default value
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FilterProvider activefilter =
        Provider.of<FilterProvider>(context, listen: false);
    selectedStatus = activefilter.selectedStatus!;
    verhuurd = activefilter.verhuurd!;
    bezetDoor = activefilter.bezetDoor!;
    //_searchController.text=activefilter.searchQuery.toString();

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Text('Box is leeg of bezet:   '),
            DropdownButton<String>(
              value: selectedStatus,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                setState(() {
                  selectedStatus = value!;
                });
                activefilter.selectedStatus = value;
              },
              items: Constanten.status
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
        Row(
          children: [
            Text('Box is verhuurd of vrij:   '),
            DropdownButton<String>(
              value: verhuurd,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                setState(() {
                  verhuurd = value!;
                });
                activefilter.verhuurd = value;
              },
              items: Constanten.huurstatus
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
        Row(
          children: [
            Text('Bezet door passant of vlh    '),
            DropdownButton<String>(
              value: bezetDoor,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                setState(() {
                  bezetDoor = value!;
                });
                activefilter.bezetDoor = value;
              },
              items: Constanten.bezet
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
        TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              // Update the search query and apply filters
              activefilter.searchQuery = value;
            });
          },
          decoration: InputDecoration(
            labelText: 'Zoek op Bootnaam',
            prefixIcon: Icon(Icons.search),
          ),
        ),

        SizedBox(height: 16),
        // Add some space between the text field and button
        Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          ElevatedButton(
            onPressed: () {
              // Apply the filters and close the filter window
              Navigator.of(context).pop();
            },
            child: Text('Toepassen'),
          ),
          ElevatedButton(
            onPressed: () {
              activefilter.clearFilters();
              setState(() {
                // Manually update the state after clearing filters
                selectedStatus = Constanten.status[0];
                verhuurd = Constanten.huurstatus[0];
                bezetDoor = Constanten.bezet[0];
                _searchController.text = ''; // Clear search query
              });
            },
            child: Text('alles wissen'),
          ),
        ])
      ]),
    );
  }
}

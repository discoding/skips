import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../assets/constants.dart';
import '../models/boxmodel.dart';
import '../providers/boxprovider.dart';
import '../providers/fliterprovider.dart';
import '../services/boxservice.dart';
import 'boxbezetting.dart';
import 'boxinfo.dart';

class BoxList extends StatelessWidget {
  final Stream<List<Box>> boxesStream =
      BoxService().getBoxesStreamFromFirestore();

  @override
  Widget build(BuildContext context) {
     FilterProvider activeFilter =
        Provider.of<FilterProvider>(context, listen: false);
    FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: activeFilter.selectedSteiger!);

    int? selectedSteigerIndex = 0;

    return StreamBuilder<List<Box>>(
      stream: boxesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error reading: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No boxes found.');
        } else {
          List<Box> boxes = snapshot.data!;
          boxes = BoxService().filterBoxes(boxes, activeFilter);
          selectedSteigerIndex = activeFilter.selectedSteiger;

          return Stack(children: [

            Container(
              alignment: Alignment.centerRight,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(height:30,),
                   Container(

                   width: MediaQuery.of(context).size.width/1.1,
                      height: MediaQuery.of(context).size.height/1.2,  // Maximum height


                    child:
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: boxes.length,
                      // itemExtent:20,
                      itemBuilder: (context, index) {
                        return
                         BoxbezettingWidget(box: boxes[index]);}
                        )

                    )
                 ],
              ),
            )
          ]);
        }
      },
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../assets/constants.dart';
import '../models/boxmodel.dart';
import '../providers/fliterprovider.dart';
import '../services/boxservice.dart';
import 'boxbezetting.dart';
import 'boxinfo.dart';

class BoxList extends StatelessWidget {


  final Stream<List<Box>> boxesStream = BoxService().getBoxesStreamFromFirestore();


  @override
  Widget build(BuildContext context) {

    FilterProvider activeFilter = Provider.of<FilterProvider>(context,listen: false);
    FixedExtentScrollController scrollController =
    FixedExtentScrollController(initialItem: activeFilter.selectedSteiger!);

    int? selectedSteigerIndex=0;

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
          boxes=BoxService().filterBoxes(boxes, activeFilter);
          selectedSteigerIndex=activeFilter.selectedSteiger;

          return Stack( children:
              [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 200,
                    child: ListWheelScrollView(
                      controller: scrollController,

                      itemExtent: 40,
                      useMagnifier: true,
                      magnification: 3,
                      onSelectedItemChanged: (int index) {
                        // Set the selected steiger directly using the index
                        //selectedSteigerIndex = index;

                        //Animate the scroll after updating the selectedSteigerIndex
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                         // scrollController.animateToItem(index,
                         //     duration: Duration(seconds: 1), curve: Curves.easeInOut);
                          activeFilter.selectedSteiger = index;

                        });
                      },

                      children: Constanten.steigers.map((steiger) {
                        return Container(
                          alignment: Alignment.centerLeft,
                          color: Colors.black12,
                          width: 30,
                          height: 30,
                          child: Text(
                            steiger,
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),



                Align(
            alignment: Alignment.centerRight,
            child: Container(//color: Colors.yellow,
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 1.2,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: boxes.length,
                itemBuilder: (context, index) {
                  return BoxbezettingWidget(box: boxes[index]);
                },
              ),
            ),
          )]);
        }
      },
    );
  }
}

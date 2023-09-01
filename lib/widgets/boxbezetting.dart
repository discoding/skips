import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skipsmaritiem/providers/boxprovider.dart';
import 'package:skipsmaritiem/services/boxservice.dart';
import 'package:skipsmaritiem/widgets/boxinfo.dart';

import '../assets/constants.dart';
import '../models/boxmodel.dart';

class BoxbezettingWidget extends StatefulWidget {
  final Box box;

  BoxbezettingWidget({required this.box});

  @override
  _BoxbezettingWidgetState createState() => _BoxbezettingWidgetState();
}

class _BoxbezettingWidgetState extends State<BoxbezettingWidget> {
  BoxStatusIndicator({required box}) {
    // ... Existing code for determining color based on box status
  }

  @override
  Widget build(BuildContext context) {
    BoxProvider activebox = Provider.of<BoxProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        activebox.box = widget.box;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: BoxInfo(),
            );
          },
        );
      },
      onHorizontalDragEnd: (details) async {

           bool newStatus = !widget.box.status!;
           activebox.box = widget.box;
           if (!activebox.status){activebox.bootnaam='';}
           if (activebox.status){activebox.bootnaam='Passant';}


        setState(() {
          widget.box.status = newStatus;
        }

        );

         //  await BoxService().updateBox(activebox.box);

      },
      child: Padding(
        padding: EdgeInsets.all(Constanten.boxlijndikte),
        child: SizedBox(
          height: widget.box.breedte!* Constanten.schaalfactor,
          width: widget.box.lengte! * Constanten.schaalfactor,
          //color: BoxColor(),
          child: FractionallySizedBox(
            alignment: Alignment.centerRight,
            widthFactor: widget.box.status! ? 0.3 : 1,
            child: Container(
              color: BoxColor(),
              child: Text(widget.box.status! ?

                '${widget.box.nummer}':'${widget.box.nummer}  ${widget.box.bootnaamvlh}',
                style: TextStyle(
                  color: Colors.white,
                  backgroundColor: BoxColor(),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Color BoxColor()
  { var kleur=Colors.transparent;
    if ((widget.box.bootnaamvlh!='') ) kleur= Colors.blue;
    if ((widget.box.bootnaamvlh =='') ) kleur=Colors.green;
    if ((widget.box.bootnaamvlh !='') && ((widget.box.bootnaam!=null) && (widget.box.bootnaam!='') )) kleur=Colors.red;
    return kleur;}


}



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:skipsmaritiem/models/boxmodel.dart';
import 'package:skipsmaritiem/providers/boxprovider.dart';
import 'package:skipsmaritiem/providers/fliterprovider.dart';

import 'package:skipsmaritiem/services/boxservice.dart';

import 'package:skipsmaritiem/widgets/boxlist.dart';
import 'package:skipsmaritiem/widgets/boxprint.dart';
import 'package:skipsmaritiem/widgets/filterboxes.dart';
import 'package:skipsmaritiem/widgets/importboxen.dart';
import 'package:skipsmaritiem/widgets/opmerkingenlist.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //final SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          //     FutureProvider<UserModel>(
          //     initialData: UserModel.initalData(),
          //   create: (context) => UserService.getUser(),
          //),
          ChangeNotifierProvider<BoxProvider>(
              create: (context) => BoxProvider()),
          ChangeNotifierProvider<FilterProvider>(
              create: (context) => FilterProvider()),
        ],
        child: MaterialApp(
          title: 'Skipsmaritiem',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
          home: const MyHomePage(title: 'Jachthaven Hindeloopen'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Box examplebox = Box.placeholder();

  @override
  Widget build(BuildContext context) {
    FilterProvider activefilter = Provider.of<FilterProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: Icon(Icons.note_outlined),

              onPressed: () {

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(child: opmerkingenPrint());
                  },
                );
              }),
          IconButton(
              icon: Icon(Icons.print),

              onPressed: () {


                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(child: BoxPrint());
                  },
                );
              }),

          IconButton(
              icon: activefilter.isFiltered! // Check if any filter is applied
                  ? Icon(Icons
                      .filter_alt) // Show filter icon if a filter is applied
                  : Icon(Icons.filter_alt_off), // Show default filter icon

              onPressed: () {
                activefilter.searchQuery = '';

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(child: BoxFilter());
                  },
                );
              }),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Create Box'),
                onTap: () => BoxService().showCreateBoxForm(context),
              ),
              PopupMenuItem(
                child: Text('Import Boxen'),
                onTap: () => ImportBoxen().importCSV(),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage('lib/assets/watersurface.png'),
        fit: BoxFit.cover,
    ),
    ),
    child: CustomPaint(
    painter: GridPainter(),
    child: BoxList(),
    )));


  }}

class GridPainter extends CustomPainter {
@override
void paint(Canvas canvas, Size size) {
  final paint = Paint()
    ..color = Colors.red // Line color
    ..strokeWidth = 1.0; // Line width

  final textStyle = TextStyle(
    color: Colors.white,
    fontSize: 15,
  );

  final int numberOfLines = 30; // Number of vertical lines
  final double spacing = size.width / numberOfLines;

  for (int i = 0; i <= numberOfLines; i++) {
    final double x = i * spacing;
    final String numberText = (31-(i + 1)).toString(); // Start from 1 to 30
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: numberText, style: textStyle,),
      textDirection: TextDirection.ltr,
    );

    // Layout the text
    textPainter.layout();

    // Calculate the position to draw the text (adjust for text width)
    final double textX = x - textPainter.width / 2;
    final double top = 0; // Adjust this value for vertical positioning
    final double down = size.height-30;

  ; // Adjust this value for vertical positioning

    // Draw the line
    canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);

    // Draw the number
    if (i.isEven){ textPainter.paint(canvas, Offset(textX, top));}
      else {textPainter.paint(canvas, Offset(textX, down));}
  }
}

@override
bool shouldRepaint(covariant CustomPainter oldDelegate) {
  return false;
}
}
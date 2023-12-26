import 'package:dart_crs/dart_crs.dart';
import 'package:flutter/material.dart';
import 'package:proj4dart/proj4dart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                textStyle:
                    const TextStyle(color: Colors.white, fontSize: 14.0))),
      ),
      home: const MyHomePage(title: 'Dart_Crs Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CoordinateTransform? transform;
  TextEditingController xController = TextEditingController();
  TextEditingController yController = TextEditingController();
  TextEditingController xTransformController = TextEditingController();
  TextEditingController yTransformController = TextEditingController();
  TextEditingController sourceCRSController = TextEditingController();
  TextEditingController targetCRSController = TextEditingController();
  Point? sourcePoint;
  Point? targetPoint;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(widget.title,
              style: const TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30),
            const Text('Coordinate Reference Systems',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: sourceCRSController,
                    decoration: const InputDecoration(
                      label: Text('Source CRS',
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w500)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                      border: OutlineInputBorder(),
                      hintText: 'EPSG:xxxx',
                      hintStyle: TextStyle(fontSize: 13),
                      enabled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 15.0),
                Expanded(
                  child: TextField(
                    controller: targetCRSController,
                    decoration: const InputDecoration(
                      label: Text('Target CRS',
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w500)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                      border: OutlineInputBorder(),
                      hintText: 'EPSG:xxxx',
                      hintStyle: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Source Coordinates',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: xController,
                    decoration: const InputDecoration(
                      label: Text('X (East) Coordinate',
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w500)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                      border: OutlineInputBorder(),
                      hintText: 'Enter Coordinate',
                      hintStyle: TextStyle(fontSize: 13),
                      enabled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 15.0),
                Expanded(
                  child: TextField(
                    controller: yController,
                    decoration: const InputDecoration(
                      label: Text('Y (North) Coordinate',
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w500)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                      border: OutlineInputBorder(),
                      hintText: 'Enter Coordinate',
                      hintStyle: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Transformed Coordinates',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    controller: xTransformController,
                    decoration: const InputDecoration(
                      label: Text('X (East) Coordinate',
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w500)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                      border: OutlineInputBorder(),
                      // hintText: 'Enter Coordinate',
                      // hintStyle: TextStyle(fontSize: 13),
                      enabled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 15.0),
                Expanded(
                  child: TextField(
                    controller: yTransformController,
                    decoration: const InputDecoration(
                      label: Text('Y (North) Coordinate',
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w500)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                      border: OutlineInputBorder(),
                      // hintText: 'Enter Coordinate',
                      // hintStyle: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: const Text('Forward',
                      style: TextStyle(color: Colors.white, fontSize: 14.0)),
                  onPressed: () async {
                    final sourceCRS = sourceCRSController.text.toUpperCase();
                    if (!validateCRS(sourceCRS)) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Invalid or missing source SRS')));
                      return;
                    }
                    final targetCRS = targetCRSController.text.toUpperCase();
                    if (!validateCRS(targetCRS)) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Invalid or missing target SRS')));
                      return;
                    }
                    transform ??= await CRSFactory
                        .createCoordinateTransformFromCodes(
                            sourceCRS, targetCRS);
                    final x = double.parse(xController.value.text);
                    final y = double.parse(yController.value.text);
                    sourcePoint = Point(x: x, y: y);
                    targetPoint = transform!.transform(sourcePoint!);
                    setState(() {
                      if (targetPoint != null) {
                        xTransformController.text =
                            targetPoint!.x.toStringAsPrecision(11);
                        yTransformController.text =
                            targetPoint!.y.toStringAsPrecision(11);
                      }
                    });
                  },
                ),
                const SizedBox(width: 30.0),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            side: const BorderSide(color: Colors.teal))),
                  ),
                  child: const Text('Inverse',
                      style: TextStyle(color: Colors.white, fontSize: 16.0)),
                  onPressed: () async {
                    if (targetPoint != null) {
                      targetPoint = transform!.inverse(targetPoint!);
                      setState(() {
                        if (targetPoint != null) {
                          xTransformController.text =
                              targetPoint!.x.toStringAsPrecision(11);
                          yTransformController.text =
                              targetPoint!.y.toStringAsPrecision(11);
                        }
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool validateCRS(String crsCode) {
    final lc = crsCode.toLowerCase();
    return lc.startsWith("epsg:");
  }
}

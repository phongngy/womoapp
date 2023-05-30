import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:womoapp/Widget/grundausstattung.dart';
import 'package:womoapp/Widget/textlabel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:camera/camera.dart';

class Stellplatz extends StatefulWidget {
  const Stellplatz({super.key});

  @override
  State<Stellplatz> createState() => _StellplatzState();
}

class _StellplatzState extends State<Stellplatz> {
  final _formKey = GlobalKey<FormState>();
  double _latitude = 0;
  double _longitude = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Bezeichnunng"),
        ),
        body: Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(decoration: TextLabel("Stellplatz", true)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                const Text("GPS"),
                Text((24.089324).toString()),
                Text((84.0324).toString()),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.gps_fixed),
                ),
              ]),
              Row(
                children: [
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Align(
                          widthFactor: 1.0,
                          heightFactor: 1.0,
                          child: IconButton(
                            icon: const Icon(Icons.calendar_month),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Text("2x besucht"),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.info)),
                ],
              ),
              Row(
                children: [
                  const Text("Bilder hinzufügen:"),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.camera_alt))
                ],
              ),
              Grundausstatung(),
              ElevatedButton(onPressed: () {}, child: const Text("Speichern")),
            ])));
  }
}

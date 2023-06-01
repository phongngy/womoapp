import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:womoapp/Widget/textlabel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:womoapp/databaseHelper.dart';
import 'package:womoapp/injector.dart';
import 'package:intl/intl.dart';

bool _toilette = false,
    _dusche = false,
    _entsorgung = false,
    _frischwasser = false;

class Stellplatz extends StatefulWidget {
  Stellplatz({super.key});
  @override
  State<Stellplatz> createState() => _StellplatzState();
}

class _StellplatzState extends State<Stellplatz> {
  final _formKey = GlobalKey<FormState>();
  double _latitude = 0;
  double _longitude = 0;
  final _imagePicker = getItInjector<ImagePicker>();
  //to save in Database
  List<Uint8List> imglist = [];
  //to Show Image on Screen
  List imgpathlist = [];
  bool _loadingGPSLesen = false;

  final _dateformatter = DateFormat('dd.MM.yyy');
  List<String> _besuche = [];
  final _datumCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  @override
  initState() {
    _datumCtrl.text = _dateformatter.format(DateTime.now());
    initDb();
    super.initState();
  }

  @override
  void dispose() {
    _datumCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void initDb() async {
    await DatabaseHelper.instance.database;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Bezeichnunng"),
        ),
        body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
                  decoration: TextLabel("Stellplatz", true),
                  controller: _nameCtrl,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text("GPS"),
                      Text(_latitude.toStringAsFixed(4)),
                      Text(_longitude.toStringAsFixed(4)),
                      _loadingGPSLesen
                          ? const CircularProgressIndicator()
                          : IconButton(
                              onPressed: () async {
                                setState(() {
                                  _loadingGPSLesen = true;
                                });
                                var tmp = await Geolocator.getCurrentPosition(
                                    desiredAccuracy: LocationAccuracy.high);
                                setState(() {
                                  _latitude = tmp.latitude;
                                  _longitude = tmp.longitude;
                                  _loadingGPSLesen = false;
                                });
                              },
                              icon: const Icon(Icons.gps_fixed),
                            )
                    ]),
                Row(
                  children: [
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller: _datumCtrl,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          suffixIcon: Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: IconButton(
                              icon: const Icon(Icons.calendar_month),
                              onPressed: () {
                                _selectDate(context);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text("${_besuche.length}x besucht"),
                    IconButton(
                        onPressed: () {
                          showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                return SimpleDialog(
                                  title:
                                      const Center(child: Text("Besuche am")),
                                  children: [
                                    SingleChildScrollView(
                                      child: Column(children: [
                                        for (int i = 0;
                                            i < _besuche.length;
                                            i++)
                                          Card(
                                            child: Row(children: [
                                              Text(_besuche[i]),
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _besuche.removeAt(i);
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete))
                                            ]),
                                          ),
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("OK"))
                                      ]),
                                    )
                                  ],
                                );
                              });
                        },
                        icon: const Icon(Icons.info)),
                  ],
                ),
                Row(
                  children: [
                    const Text("Bilder hinzufügen:"),
                    IconButton(
                        onPressed: () async {
                          await _imagePicker
                              .pickImage(
                                  source: ImageSource.camera,
                                  maxHeight: 200,
                                  maxWidth: 200)
                              .then((value) {
                            setState(() {
                              imglist.add(File(value!.path).readAsBytesSync());
                              imgpathlist.add(value.path);
                            });
                          });
                        },
                        icon: const Icon(Icons.camera_alt))
                  ],
                ),
                if (imglist.isNotEmpty)
                  CarouselSlider(
                      items:
                          imgpathlist.map((e) => Image.file(File(e))).toList(),
                      options: CarouselOptions()),
                Grundausstatung(),
                ElevatedButton(
                    onPressed: () async {
                      await DatabaseHelper.instance
                          .insertStellplatzKomplett(
                              _nameCtrl.text,
                              _longitude,
                              _latitude,
                              _toilette,
                              _dusche,
                              _entsorgung,
                              _frischwasser,
                              _besuche,
                              imglist)
                          .then((value) => Navigator.pop(context));
                    },
                    child: const Text("Speichern")),
              ])),
        ));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      _besuche.add(_dateformatter.format(picked));
      setState(() {
        _datumCtrl.text = _dateformatter.format(picked);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${_datumCtrl.text} wurde hinzugefuegt"),
        ));
      });
    }
  }
}

class Grundausstatung extends StatefulWidget {
  Grundausstatung({super.key});

  @override
  State<Grundausstatung> createState() => _GrundausstatungState();
}

class _GrundausstatungState extends State<Grundausstatung> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add),
        ),
        CheckboxListTile(
            value: _toilette,
            title: const Text("Toilette"),
            onChanged: (bool? value) {
              setState(() {
                _toilette = !_toilette;
              });
            }),
        CheckboxListTile(
            value: _dusche,
            title: const Text("Dusche"),
            onChanged: (bool? value) {
              setState(() {
                _dusche = !_dusche;
              });
            }),
        CheckboxListTile(
            value: _entsorgung,
            title: const Text("Entsorgung"),
            onChanged: (bool? value) {
              setState(() {
                _entsorgung = !_entsorgung;
              });
            }),
        CheckboxListTile(
            value: _frischwasser,
            title: const Text("Frichwasser"),
            onChanged: (bool? value) {
              setState(() {
                _frischwasser = !_frischwasser;
              });
            }),
      ]),
    );
  }
}

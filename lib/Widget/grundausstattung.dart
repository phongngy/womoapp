import 'package:flutter/material.dart';

class Grundausstatung extends StatefulWidget {
  Grundausstatung({super.key});
  bool _toilette = false,
      _dusche = false,
      _entsorgung = false,
      _frischwasser = false;

  bool get toilette => _toilette;
  bool get dusche => _dusche;
  bool get entsorgung => _entsorgung;
  bool get frischwasser => _frischwasser;
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
            value: widget._toilette,
            title: const Text("Toilette"),
            onChanged: (bool? value) {
              setState(() {
                widget._toilette = !widget._toilette;
              });
            }),
        CheckboxListTile(
            value: widget._dusche,
            title: const Text("Dusche"),
            onChanged: (bool? value) {
              setState(() {
                widget._dusche = !widget._dusche;
              });
            }),
        CheckboxListTile(
            value: widget._entsorgung,
            title: const Text("Entsorgung"),
            onChanged: (bool? value) {
              setState(() {
                widget._entsorgung = !widget._entsorgung;
              });
            }),
        CheckboxListTile(
            value: widget._frischwasser,
            title: const Text("Frichwasser"),
            onChanged: (bool? value) {
              setState(() {
                widget._frischwasser = !widget._frischwasser;
              });
            }),
      ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

InputDecoration TextLabel(String text, bool pflichtfeld) {
  return InputDecoration(
    label: Text.rich(TextSpan(
      children: <InlineSpan>[
        WidgetSpan(
          child: Text(
            text,
          ),
        ),
        if (pflichtfeld)
          const WidgetSpan(
            child: Text(
              '*',
              style: TextStyle(color: Colors.red),
            ),
          )
      ],
    )),
  );
}

import 'package:flutter/material.dart';
import 'package:womoapp/Screen/stellplatz.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: const TextSpan(
                text: "WoMo",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 80,
                    color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Stellplatz()));
                },
                child: const Text("Stellplatz eintragen"),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Checkliste"),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Verwaltung"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

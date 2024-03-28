import 'package:flutter/material.dart';

class HourlyForecastCard extends StatelessWidget {
  String hour = '';
  IconData icon;
  String temp = '';
  HourlyForecastCard(
      {super.key, required this.hour, required this.icon, required this.temp});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: 100,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 10,
          child: Container(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    hour,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Icon(
                    icon,
                    size: 32,
                    color: icon == Icons.wb_sunny
                        ? Colors.amber
                        : Colors.blue[900],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    temp,
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

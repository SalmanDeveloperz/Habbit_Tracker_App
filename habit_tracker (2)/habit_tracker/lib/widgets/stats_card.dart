import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final double value;
  final String subtitle;

  const StatsCard({
    required this.title,
    required this.value,
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            CircularPercentIndicator(
              radius: 60.0,
              lineWidth: 10.0,
              percent: value / 100,
              center: Text(
                '${value.toStringAsFixed(1)}%',
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              progressColor: Colors.teal,
              backgroundColor: Colors.grey[300]!,
            ),
            const SizedBox(height: 8),
            Text(subtitle, style: GoogleFonts.poppins(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
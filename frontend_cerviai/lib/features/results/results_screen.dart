import 'dart:io';
import 'package:flutter/material.dart';
import '../../services/tflite_service_clean.dart';

class ResultsScreen extends StatelessWidget {
  final AnalysisResult result;
  final File? image;

  const ResultsScreen({super.key, required this.result, this.image});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;
    String statusTitle;

    switch (result.status) {
      case 'Parabasal':
        statusColor = Colors.orange;
        statusIcon = Icons.warning;
        statusTitle = 'Parabasal Cell';
        break;

      case 'Dyskeratotic':
        statusColor = Colors.red;
        statusIcon = Icons.warning;
        statusTitle = 'Dyskeratotic (Abnormal)';
        break;

      case 'Koilocytotic':
        statusColor = Colors.red;
        statusIcon = Icons.warning;
        statusTitle = 'Koilocytotic (HPV)';
        break;

      case 'Metaplastic':
        statusColor = Colors.blue;
        statusIcon = Icons.info;
        statusTitle = 'Metaplastic Cell';
        break;

      case 'Superficial-Intermediate':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusTitle = 'Normal Cell';
        break;

      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
        statusTitle = 'Analysis Result';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Analysis Result"),
        backgroundColor: statusColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image display
            if (image != null)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(image!, height: 250, fit: BoxFit.cover),
                ),
              )
            else
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
              ),

            const SizedBox(height: 24),

            // Status indicator
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusColor.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statusColor.withAlpha(50)),
              ),
              child: Column(
                children: [
                  Icon(statusIcon, size: 48, color: statusColor),
                  const SizedBox(height: 8),
                  Text(
                    statusTitle,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (result.status != 'invalid') ...[
                    const SizedBox(height: 8),
                    Text(
                      'Confidence: ${result.confidence.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 16,
                        color: statusColor.withAlpha(200),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Detailed message
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Text(
                result.message,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Probabilities (if available)
            if (result.probabilities.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                'Detailed Analysis',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...result.probabilities.entries.map((entry) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${entry.value.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: entry.key == 'abnormal' ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              )),
            ],

            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Take Another Photo'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false),
                  icon: const Icon(Icons.home),
                  label: const Text('Home'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Disclaimer
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: const Text(
                '⚠️ This is an AI-assisted analysis and not a medical diagnosis. Always consult with healthcare professionals for proper medical advice.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.amber,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

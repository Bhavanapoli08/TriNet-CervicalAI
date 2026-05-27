import 'package:flutter/material.dart';
import '../../core/widgets/animated_loader.dart';
import '../../services/tflite_service_clean.dart';
import '../results/results_screen.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate AI Processing Time
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsScreen(
              result: AnalysisResult(
                status: 'invalid',
                confidence: 0.0,
                message: 'No image provided. Please use the Get Tested flow to analyze a sample.',
                probabilities: {},
              ),
              image: null,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedLoader(text: "Analyzing sample using Deep Learning..."),
      ),
    );
  }
}

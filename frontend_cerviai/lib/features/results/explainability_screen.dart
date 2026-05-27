import 'package:flutter/material.dart';

class ExplainabilityScreen extends StatelessWidget {
  const ExplainabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Attention Heatmap")),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Original Image Placeholder
                Container(
                  color: Colors.grey[800],
                  child: const Center(
                    child: Icon(Icons.image, color: Colors.white24, size: 100),
                  ),
                ),
                // Heatmap Overlay (Mock)
                Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Colors.red.withAlpha(153),
                        Colors.yellow.withAlpha(76),
                        Colors.transparent,
                      ],
                      stops: const [0.2, 0.5, 1.0],
                      center: const Alignment(0.2, -0.3),
                      radius: 0.5,
                    ),
                  ),
                ),
                Container(
                   decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Colors.red.withAlpha(128),
                         Colors.transparent,
                      ],
                      center: const Alignment(-0.4, 0.4),
                      radius: 0.3,
                    ),
                  ),
                ),
                // Legend
                Positioned(
                  bottom: 24,
                  left: 24,
                  right: 24,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(children: [
                          CircleAvatar(backgroundColor: Colors.red, radius: 6),
                          SizedBox(width: 8),
                          Text("High Attention", style: TextStyle(color: Colors.white, fontSize: 12)),
                        ]),
                        Row(children: [
                          CircleAvatar(backgroundColor: Colors.yellow, radius: 6),
                          SizedBox(width: 8),
                          Text("Medium Attention", style: TextStyle(color: Colors.white, fontSize: 12)),
                        ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            color: Theme.of(context).cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Heatmap Analysis",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "The heat map highlights regions where the AI model focused its attention to determine the diagnosis. Red areas indicate the most significant features contributing to the 'High Risk' classification.",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

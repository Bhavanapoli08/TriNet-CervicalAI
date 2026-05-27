// import 'dart:io';
// import 'dart:typed_data';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:image/image.dart' as img;
//
// class AnalysisResult {
//   final String status;
//   final double confidence;
//   final String message;
//   final Map<String, double> probabilities;
//
//   AnalysisResult({
//     required this.status,
//     required this.confidence,
//     required this.message,
//     required this.probabilities,
//   });
// }
//
// class TFLiteService {
//   Interpreter? _interpreter;
//
//   Future<void> loadModel() async {
//     try {
//       _interpreter = await Interpreter.fromAsset('assets/efficientnet_b3.tflite');
//     } catch (e) {
//       _interpreter = null;
//     }
//   }
//
//   bool _isImageValid(img.Image image) {
//     if (image.width < 100 || image.height < 100) return false;
//     final variance = _calculateImageVariance(image);
//     if (variance < 50.0) return false;
//     final contrast = _calculateImageContrast(image);
//     if (contrast < 30.0) return false;
//     return true;
//   }
//
//   double _calculateImageVariance(img.Image image) {
//     final total = image.width * image.height;
//     double sum = 0;
//     double sumSq = 0;
//     for (int y = 0; y < image.height; y++) {
//       for (int x = 0; x < image.width; x++) {
//         final p = image.getPixel(x, y);
//         final gray = (p.r + p.g + p.b) / 3.0;
//         sum += gray;
//         sumSq += gray * gray;
//       }
//     }
//     final mean = sum / total;
//     return (sumSq / total) - (mean * mean);
//   }
//
//   double _calculateImageContrast(img.Image image) {
//     int minGray = 255;
//     int maxGray = 0;
//     for (int y = 0; y < image.height; y += 10) {
//       for (int x = 0; x < image.width; x += 10) {
//         final p = image.getPixel(x, y);
//         final gray = ((p.r + p.g + p.b) / 3).round();
//         if (gray < minGray) minGray = gray;
//         if (gray > maxGray) maxGray = gray;
//       }
//     }
//     return (maxGray - minGray).toDouble();
//   }
//
//   Float32List _preprocess(File file) {
//     final decoded = img.decodeImage(file.readAsBytesSync());
//     if (decoded == null) throw Exception('Unable to decode image');
//     final resized = img.copyResize(decoded, width: 224, height: 224);
//
//     final input = Float32List(224 * 224 * 3);
//     int i = 0;
//     for (int y = 0; y < 224; y++) {
//       for (int x = 0; x < 224; x++) {
//         final p = resized.getPixel(x, y);
//         input[i++] = p.r / 255.0;
//         input[i++] = p.g / 255.0;
//         input[i++] = p.b / 255.0;
//       }
//     }
//     return input;
//   }
//
//   AnalysisResult predict(File imageFile) {
//     if (_interpreter == null) {
//       return AnalysisResult(
//         status: 'invalid',
//         confidence: 0.0,
//         message: 'Model not loaded',
//         probabilities: {},
//       );
//     }
//
//     final decoded = img.decodeImage(imageFile.readAsBytesSync());
//     if (decoded == null) {
//       return AnalysisResult(
//         status: 'invalid',
//         confidence: 0.0,
//         message: 'Unable to decode image',
//         probabilities: {},
//       );
//     }
//
//     if (!_isImageValid(decoded)) {
//       return AnalysisResult(
//         status: 'invalid',
//         confidence: 0.0,
//         message: 'Image quality too low',
//         probabilities: {},
//       );
//     }
//
//     final input = _preprocess(imageFile);
//     final output = List.generate(1, (_) => List.filled(1, 0.0));
//
//     try {
//       _interpreter!.run(input.reshape([1, 224, 224, 3]), output);
//     } catch (e) {
//       return AnalysisResult(
//         status: 'invalid',
//         confidence: 0.0,
//         message: 'Inference error: $e',
//         probabilities: {},
//       );
//     }
//
//     final abnormalProb = (output[0] as List)[0] as double;
//     final normalProb = (1.0 - abnormalProb).clamp(0.0, 1.0);
//     final isAbnormal = abnormalProb > 0.5;
//
//     return AnalysisResult(
//       status: isAbnormal ? 'abnormal' : 'normal',
//       confidence: (isAbnormal ? abnormalProb : normalProb) * 100,
//       message: isAbnormal
//           ? 'Potential abnormalities detected. Consult a doctor.'
//           : 'No abnormalities detected. Continue regular checks.',
//       probabilities: {
//         'normal': normalProb * 100,
//         'abnormal': abnormalProb * 100,
//       },
//     );
//   }
// }



import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class AnalysisResult {
  final String status;          // class label (e.g., "Dyskeratotic")
  final String category;        // "normal" / "abnormal" / "benign"
  final double confidence;      // 0-100
  final String message;
  final Map<String, double> probabilities;

  AnalysisResult({
    required this.status,
    required this.category,
    required this.confidence,
    required this.message,
    required this.probabilities,
  });
}

class TFLiteService {
  Interpreter? _interpreter;

  // ⚠️ Order MUST match training. PyTorch ImageFolder sorts class folders
  // alphabetically. Folders were im_Dyskeratotic, im_Koilocytotic, etc.,
  // so the alphabetical (and model output) order is:
  static const List<String> classNames = [
    'Dyskeratotic',              // index 0  — abnormal
    'Koilocytotic',              // index 1  — abnormal
    'Metaplastic',               // index 2  — benign
    'Parabasal',                 // index 3  — normal
    'Superficial-Intermediate',  // index 4  — normal
  ];

  // Clinical category for each class
  static const Map<String, String> classCategories = {
    'Dyskeratotic':             'abnormal',
    'Koilocytotic':             'abnormal',
    'Metaplastic':              'benign',
    'Parabasal':                'normal',
    'Superficial-Intermediate': 'normal',
  };

  // ImageNet normalization (must match training)
  static const List<double> _mean = [0.485, 0.456, 0.406];
  static const List<double> _std  = [0.229, 0.224, 0.225];

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/efficientnet_b3.tflite',
      );
      print('✅ Model loaded');
      print('   Input shape:  ${_interpreter!.getInputTensor(0).shape}');
      print('   Output shape: ${_interpreter!.getOutputTensor(0).shape}');
    } catch (e) {
      print('❌ Model load error: $e');
      _interpreter = null;
    }
  }

  /// Preprocess image: resize to 224x224, normalize with ImageNet mean/std,
  /// output as NHWC float32 (the layout onnx2tf produces).
  Float32List _preprocess(File file) {
    final decoded = img.decodeImage(file.readAsBytesSync());
    if (decoded == null) {
      throw Exception('Unable to decode image');
    }
    final resized = img.copyResize(decoded, width: 224, height: 224);

    final input = Float32List(1 * 224 * 224 * 3);
    int i = 0;
    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final p = resized.getPixel(x, y);
        // ImageNet normalization: (pixel/255 - mean) / std
        input[i++] = ((p.r / 255.0) - _mean[0]) / _std[0];
        input[i++] = ((p.g / 255.0) - _mean[1]) / _std[1];
        input[i++] = ((p.b / 255.0) - _mean[2]) / _std[2];
      }
    }
    return input;
  }

  /// Numerically-stable softmax.
  List<double> _softmax(List<double> logits) {
    final maxLogit = logits.reduce(math.max);
    final exps = logits.map((x) => math.exp(x - maxLogit)).toList();
    final sumExp = exps.reduce((a, b) => a + b);
    return exps.map((e) => e / sumExp).toList();
  }

  AnalysisResult predict(File imageFile) {
    if (_interpreter == null) {
      return AnalysisResult(
        status: 'error',
        category: 'unknown',
        confidence: 0.0,
        message: 'Model not loaded',
        probabilities: {},
      );
    }

    try {
      final input = _preprocess(imageFile);

      // Output buffer: [1, 5] for 5-class softmax
      print('🔍 USING UPDATED CODE — output buffer is [1, 5]');
      final output = List.generate(1, (_) => List.filled(5, 0.0));

      _interpreter!.run(input.reshape([1, 224, 224, 3]), output);

      // Convert raw logits to softmax probabilities
      final logits = List<double>.from(output[0]);
      final probs  = _softmax(logits);

      // Find top class
      int topIdx = 0;
      double topProb = probs[0];
      for (int i = 1; i < probs.length; i++) {
        if (probs[i] > topProb) {
          topProb = probs[i];
          topIdx = i;
        }
      }

      // Build per-class probability map (as percentages)
      final probMap = <String, double>{};
      for (int i = 0; i < probs.length; i++) {
        probMap[classNames[i]] = probs[i] * 100;
      }

      final topLabel = classNames[topIdx];
      final category = classCategories[topLabel] ?? 'unknown';

      // Confidence-aware message
      final confPct = topProb * 100;
      final confWord = confPct > 90
          ? 'very high'
          : confPct > 75
          ? 'high'
          : confPct > 50
          ? 'moderate'
          : 'low';

      String message;
      switch (category) {
        case 'abnormal':
          message = 'Possible abnormality ($topLabel) — consult a healthcare provider.';
          break;
        case 'benign':
          message = 'Benign cell type ($topLabel) — typically not concerning.';
          break;
        case 'normal':
          message = 'Normal cell ($topLabel) — no abnormalities detected.';
          break;
        default:
          message = 'Predicted: $topLabel';
      }

      return AnalysisResult(
        status: topLabel,
        category: category,
        confidence: confPct,
        message: '$message (confidence: $confWord, ${confPct.toStringAsFixed(1)}%)',
        probabilities: probMap,
      );
    } catch (e) {
      return AnalysisResult(
        status: 'error',
        category: 'unknown',
        confidence: 0.0,
        message: 'Inference error: $e',
        probabilities: {},
      );
    }
  }
}
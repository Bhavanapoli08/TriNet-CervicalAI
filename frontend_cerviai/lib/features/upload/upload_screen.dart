// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../services/tflite_service_clean.dart';
// import '../results/results_screen.dart';
//
// class UploadScreen extends StatefulWidget {
//   const UploadScreen({super.key});
//
//   @override
//   State<UploadScreen> createState() => _UploadScreenState();
// }
//
// class _UploadScreenState extends State<UploadScreen> {
//   File? _image;
//   final picker = ImagePicker();
//   final tflite = TFLiteService();
//
//   @override
//   void initState() {
//     super.initState();
//     tflite.loadModel();
//   }
//
//   Future pickImage(ImageSource source) async {
//     final picked = await picker.pickImage(source: source);
//
//     if (picked != null) {
//       File imgFile = File(picked.path);
//
//       var result = tflite.predict(imgFile);
//
//       if (!mounted) return;
//       setState(() {
//         _image = imgFile;
//       });
//
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => ResultsScreen(result: result, image: imgFile),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Upload Image")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (_image != null)
//               Image.file(_image!, height: 250),
//             const SizedBox(height: 16),
//             const Text(
//               "Choose how to capture your sample:",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//             const SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () => pickImage(ImageSource.camera),
//                   icon: const Icon(Icons.camera_alt),
//                   label: const Text("Take Photo"),
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 ElevatedButton.icon(
//                   onPressed: () => pickImage(ImageSource.gallery),
//                   icon: const Icon(Icons.photo_library),
//                   label: const Text("Choose from Gallery"),
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               "For best results, ensure good lighting and clear image of the sample.",
//               style: TextStyle(fontSize: 12, color: Colors.grey),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/tflite_service_clean.dart';
import '../results/results_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _image;
  final picker = ImagePicker();
  final tflite = TFLiteService();

  bool isModelLoaded = false; // ✅ NEW

  @override
  void initState() {
    super.initState();

    // ✅ LOAD MODEL PROPERLY
    tflite.loadModel().then((_) {
      setState(() {
        isModelLoaded = true;
      });
      print("✅ Model Loaded");
    });
  }

  Future pickImage(ImageSource source) async {
    // 🚨 PREVENT EARLY CLICK
    if (!isModelLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Model is still loading...")),
      );
      return;
    }

    final picked = await picker.pickImage(source: source);

    if (picked != null) {
      File imgFile = File(picked.path);

      var result = tflite.predict(imgFile);

      if (!mounted) return;

      setState(() {
        _image = imgFile;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultsScreen(result: result, image: imgFile),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Image")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image != null)
              Image.file(_image!, height: 250),

            const SizedBox(height: 16),

            Text(
              isModelLoaded
                  ? "Model Ready ✅"
                  : "Loading Model... ⏳",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),

            const Text(
              "Choose how to capture your sample:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Take Photo"),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Gallery"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
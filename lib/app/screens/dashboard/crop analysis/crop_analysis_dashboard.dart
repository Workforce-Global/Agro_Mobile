import 'package:agro_sav/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'widgets/dashboard_header.dart';
import 'widgets/image_upload_section.dart';
import 'widgets/model_selection_section.dart';
import 'widgets/analyze_button.dart';
import 'widgets/results_section.dart';
import 'widgets/image_picker.dart';
import 'widgets/analysis_results_dialog.dart';
import 'package:agro_sav/app/screens/dashboard/widgets/sidebar_menu.dart';

class CropAnalysisDashboard extends StatefulWidget {
  const CropAnalysisDashboard({Key? key}) : super(key: key);

  @override
  State<CropAnalysisDashboard> createState() => _CropAnalysisDashboardState();
}

class _CropAnalysisDashboardState extends State<CropAnalysisDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  File? _selectedImage;
  String _selectedModel = 'efficientnet';
  bool _isAnalyzing = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _selectImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ImagePickerBottomSheet(
        onCameraSelected: () async {
          Navigator.pop(context);
          final XFile? image = await _picker.pickImage(
            source: ImageSource.camera,
          );
          if (image != null) {
            setState(() => _selectedImage = File(image.path));
          }
        },
        onGallerySelected: () async {
          Navigator.pop(context);
          final XFile? image = await _picker.pickImage(
            source: ImageSource.gallery,
          );
          if (image != null) {
            setState(() => _selectedImage = File(image.path));
          }
        },
      ),
    );
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;

    setState(() => _isAnalyzing = true);

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://agrosaviour-backend-947103695812.europe-west1.run.app/predict/',
        ),
      );
      request.fields['model_name'] = _selectedModel;
      request.files.add(
        await http.MultipartFile.fromPath('file', _selectedImage!.path),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final data = jsonDecode(respStr);

        final label = data['result']['label'];
        final confidence = (data['result']['confidence'] as double) * 100;
        final modelUsed = data['model_used'];

        // Save to Firestore
        await FirestoreService().saveAnalysisResult({
          'label': label,
          'confidence': confidence,
          'model_used': modelUsed,
          'timestamp': DateTime.now(),
        });

        // Show dialog
        _showAnalysisResults(label, confidence);
      } else {
        _showError('API error: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Error: $e');
    }

    setState(() => _isAnalyzing = false);
  }

  void _showAnalysisResults(String label, double confidence) {
    showDialog(
      context: context,
      builder: (context) =>
          AnalysisResultsDialog(label: label, confidence: confidence),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF5F5DC),

        drawer: Drawer(
          child: SafeArea(
            child: Sidebar(
              isCollapsed: false,
              currentPage: 'Analysis',
              onToggle: () {},
              onPageChanged: (page) {
                Navigator.pop(context);
              },
            ),
          ),
        ),

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 4,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          title: const Text(
            'Crop Analysis',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.light_mode, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DashboardHeader(),
              const SizedBox(height: 24),
              ImageUploadSection(
                selectedImage: _selectedImage,
                onImageSelected: _selectImage,
              ),
              const SizedBox(height: 24),
              ModelSelectionSection(
                selectedModel: _selectedModel,
                onModelChanged: (model) {
                  setState(() {
                    _selectedModel = model;
                  });
                },
              ),
              const SizedBox(height: 24),
              AnalyzeButton(
                isAnalyzing: _isAnalyzing,
                onAnalyze: _analyzeImage,
                isEnabled: _selectedImage != null,
              ),
              /*
              const SizedBox(height: 24),
              if (_isAnalyzing || _selectedImage != null)
                ResultsSection(isAnalyzing: _isAnalyzing),
              */
            ],
          ),
        ),
      ),
    );
  }
}

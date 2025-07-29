import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  String _selectedModel = 'MobileNet';
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
          final XFile? image = await _picker.pickImage(source: ImageSource.camera);
          if (image != null) {
            setState(() => _selectedImage = File(image.path));
          }
        },
        onGallerySelected: () async {
          Navigator.pop(context);
          final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
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
    await Future.delayed(const Duration(seconds: 3));
    setState(() => _isAnalyzing = false);
    _showAnalysisResults();
  }

  void _showAnalysisResults() {
    showDialog(
      context: context,
      builder: (context) => AnalysisResultsDialog(),
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
              onToggle: () {}, // Not needed for mobile drawer
              onPageChanged: (page) {
                Navigator.pop(context); // Close drawer when item is selected
                // Handle page navigation here if needed
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
              onPressed: () {}, // Theme toggle
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.black),
              onPressed: () {}, // Profile
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
              const SizedBox(height: 24),
              if (_isAnalyzing || _selectedImage != null)
                ResultsSection(isAnalyzing: _isAnalyzing),
            ],
          ),
        ),
      ),
    );
  }
}
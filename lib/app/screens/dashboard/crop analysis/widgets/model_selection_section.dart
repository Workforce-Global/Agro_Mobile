// dashboard/crop_analysis/widgets/model_selection_section.dart
import 'package:flutter/material.dart';
import 'model_card.dart';

class ModelSelectionSection extends StatelessWidget {
  final String selectedModel;
  final Function(String) onModelChanged;

  const ModelSelectionSection({
    Key? key,
    required this.selectedModel,
    required this.onModelChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Analysis Model',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ModelCard(
                  title: 'MobileNet',
                  description: 'Faster, less accurate',
                  icon: Icons.speed,
                  isSelected: selectedModel == 'MobileNet',
                  onTap: () => onModelChanged('MobileNet'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ModelCard(
                  title: 'EfficientNet',
                  description: 'Slower, more accurate',
                  icon: Icons.precision_manufacturing,
                  isSelected: selectedModel == 'EfficientNet',
                  onTap: () => onModelChanged('EfficientNet'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
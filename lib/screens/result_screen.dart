import 'dart:io';

import 'package:flutter/material.dart';

import '../services/coffeeguard_api.dart';
import '../theme/app_theme.dart';

class ResultScreen extends StatelessWidget {
  final File image;
  final PredictionResult result;

  const ResultScreen({super.key, required this.image, required this.result});

  Color get _statusColor =>
      result.predictedClass == 'Healthy' ? AppColors.leafGreen : AppColors.warnAmber;

  IconData get _statusIcon =>
      result.predictedClass == 'Healthy' ? Icons.check_circle_rounded : Icons.warning_rounded;

  @override
  Widget build(BuildContext context) {
    final sortedProbs = result.allProbabilities.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(title: const Text('Diagnosis')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(image, height: 240, fit: BoxFit.cover),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(_statusIcon, color: _statusColor, size: 36),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              result.predictedClass,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.coffeeBrown,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${(result.confidence * 100).toStringAsFixed(1)}% confidence',
                              style: TextStyle(color: AppColors.coffeeBrownLight),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What to do',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.coffeeBrown,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        result.careTip,
                        style: const TextStyle(height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Scan another leaf'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
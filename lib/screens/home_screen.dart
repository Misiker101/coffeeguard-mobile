import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/coffeeguard_api.dart';
import '../theme/app_theme.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _picker = ImagePicker();
  final _api = CoffeeGuardApi();
  bool _isLoading = false;

  Future<void> _pickAndPredict(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1600,
      imageQuality: 90,
    );
    if (picked == null) return;

    final file = File(picked.path);
    setState(() => _isLoading = true);

    try {
      final result = await _api.predict(file);
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ResultScreen(image: file, result: result),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      _showError(e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.leafGreenLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.eco_rounded,
                    color: AppColors.leafGreen, size: 34),
              ),
              const SizedBox(height: 24),
              Text('CoffeeGuard', style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 8),
              Text(
                'Snap a coffee leaf and get an instant health diagnosis, powered by a model trained specifically for coffee crops.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.coffeeBrownLight,
                  height: 1.4,
                ),
              ),
              const Spacer(),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.leafGreen,
                    ),
                  ),
                ),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : () => _pickAndPredict(ImageSource.camera),
                icon: const Icon(Icons.camera_alt_rounded),
                label: const Text('Take a photo'),
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(56)),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _isLoading ? null : () => _pickAndPredict(ImageSource.gallery),
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('Choose from gallery'),
                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(56)),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
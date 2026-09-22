import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class PredictionResult {
  final String predictedClass;
  final double confidence;
  final String careTip;
  final double latencyMs;
  final Map<String, double> allProbabilities;

  PredictionResult({
    required this.predictedClass,
    required this.confidence,
    required this.careTip,
    required this.latencyMs,
    required this.allProbabilities,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    final probs = <String, double>{};
    (json['all_probabilities'] as Map<String, dynamic>? ?? {}).forEach(
          (k, v) => probs[k] = (v as num).toDouble(),
    );
    return PredictionResult(
      predictedClass: json['predicted_class'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      careTip: json['care_tip'] as String? ?? '',
      latencyMs: (json['latency_ms'] as num?)?.toDouble() ?? 0,
      allProbabilities: probs,
    );
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

/// Thin client for the CoffeeGuard FastAPI backend.
class CoffeeGuardApi {
  final String baseUrl;
  final Duration timeout;

  CoffeeGuardApi({
    this.baseUrl = 'https://coffeeguard-rapy.onrender.com',
    this.timeout = const Duration(seconds: 75),
  });


  MediaType _mediaTypeFor(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return MediaType('image', 'png');
    return MediaType('image', 'jpeg');
  }

  Future<PredictionResult> predict(File imageFile) async {
    final uri = Uri.parse('$baseUrl/predict');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          contentType: _mediaTypeFor(imageFile.path),
        ),
      );

    try {
      final streamedResponse = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return PredictionResult.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      } else if (response.statusCode == 503) {
        throw ApiException(
          'The model isn\'t loaded on the server yet. Try again shortly.',
        );
      } else {
        throw ApiException(
          'Server error (${response.statusCode}). Please try again.',
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Could not reach CoffeeGuard. Check your connection and try again.',
      );
    }
  }

  Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return false;
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body['model_loaded'] == true;
    } catch (_) {
      return false;
    }
  }
}
import 'package:dio/dio.dart';
import 'package:well_less_app/core/network/api_client.dart';
import 'package:well_less_app/features/prototype/ai_analysis.dart';

class AiAnalysisService {
  AiAnalysisService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<AiRoutineAnalysis> analyzeRoutine({
    required String accessToken,
    required String routineId,
    required String profileCode,
    required List<String> imagePaths,
  }) async {
    if (imagePaths.isEmpty) {
      throw const AiAnalysisException('분석할 제품 사진을 먼저 촬영해주세요.');
    }

    try {
      final files = <MultipartFile>[];
      for (final path in imagePaths.take(10)) {
        final lowerPath = path.toLowerCase();
        final contentType = lowerPath.endsWith('.png')
            ? DioMediaType('image', 'png')
            : lowerPath.endsWith('.webp')
            ? DioMediaType('image', 'webp')
            : DioMediaType('image', 'jpeg');
        files.add(
          await MultipartFile.fromFile(
            path,
            filename: path.split(RegExp(r'[/\\]')).last,
            contentType: contentType,
          ),
        );
      }
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        '/ai/analyze-routine',
        data: FormData.fromMap({
          'routine_id': routineId,
          'profile_code': profileCode,
          'images': files,
        }),
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(minutes: 3),
        ),
      );
      final payload = response.data?['data'];
      if (payload is! Map<String, dynamic>) {
        throw const AiAnalysisException('서버의 AI 분석 응답 형식이 올바르지 않습니다.');
      }
      return AiRoutineAnalysis.fromJson(payload);
    } on DioException catch (error) {
      final body = error.response?.data;
      String? serverMessage;
      if (body is Map) {
        final serverError = body['error'];
        if (serverError is Map) {
          serverMessage = serverError['message']?.toString();
        }
        serverMessage ??= body['detail']?.toString();
      }
      final fallback = error.response == null
          ? 'AI 분석 서버에 연결하지 못했습니다. 네트워크와 API 주소를 확인해주세요.'
          : 'AI 분석 요청에 실패했습니다. (HTTP ${error.response?.statusCode})';
      throw AiAnalysisException(serverMessage ?? fallback);
    }
  }
}

class AiAnalysisException implements Exception {
  const AiAnalysisException(this.message);
  final String message;

  @override
  String toString() => message;
}

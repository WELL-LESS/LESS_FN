import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:well_less_app/core/network/api_client.dart';

class WellLessSession {
  const WellLessSession({
    required this.accessToken,
    required this.latestDiagnosisId,
    required this.skinTypeCode,
  });

  final String accessToken;
  final String latestDiagnosisId;
  final String skinTypeCode;
}

class WellLessApiService {
  WellLessApiService({ApiClient? apiClient})
    : _dio = (apiClient ?? ApiClient()).dio;

  final Dio _dio;
  final Uuid _uuid = const Uuid();

  Future<WellLessSession> verifyPersonalCode(String personalCode) async {
    try {
      final authResponse = await _dio.post<Map<String, dynamic>>(
        '/auth/code/verify',
        data: {
          'personal_code': personalCode.trim().toUpperCase(),
          'device_id': _uuid.v4(),
        },
      );
      final authData = _responseData(authResponse.data);
      final accessToken = authData['access_token']?.toString();
      final diagnosisId = authData['latest_diagnosis_id']?.toString();
      if (accessToken == null || diagnosisId == null) {
        throw const WellLessApiException('인증 응답 형식이 올바르지 않습니다.');
      }

      final overviewResponse = await _dio.get<Map<String, dynamic>>(
        '/me/overview',
        options: _authorized(accessToken),
      );
      final overview = _responseData(overviewResponse.data);
      final diagnosis = overview['latest_diagnosis'];
      final skinTypeCode = diagnosis is Map
          ? diagnosis['diagnosis_code']?.toString()
          : null;
      if (skinTypeCode == null || skinTypeCode.isEmpty) {
        throw const WellLessApiException('피부 진단 결과를 찾을 수 없습니다.');
      }

      return WellLessSession(
        accessToken: accessToken,
        latestDiagnosisId: diagnosisId,
        skinTypeCode: skinTypeCode,
      );
    } on DioException catch (error) {
      throw WellLessApiException(_errorMessage(error));
    }
  }

  Future<String> createRoutine({
    required WellLessSession session,
    required List<String> categoryCodes,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/routines',
        data: {
          'diagnosis_id': session.latestDiagnosisId,
          'category_codes': categoryCodes,
        },
        options: _authorized(session.accessToken),
      );
      final routineId = _responseData(response.data)['id']?.toString();
      if (routineId == null) {
        throw const WellLessApiException('루틴 생성 응답 형식이 올바르지 않습니다.');
      }
      return routineId;
    } on DioException catch (error) {
      throw WellLessApiException(_errorMessage(error));
    }
  }

  Future<void> uploadProductImage({
    required WellLessSession session,
    required String routineId,
    required String categoryCode,
    required String imagePath,
  }) async {
    try {
      final lowerPath = imagePath.toLowerCase();
      final contentType = lowerPath.endsWith('.png')
          ? DioMediaType('image', 'png')
          : lowerPath.endsWith('.webp')
          ? DioMediaType('image', 'webp')
          : DioMediaType('image', 'jpeg');
      final filename = imagePath.split(RegExp(r'[/\\]')).last;
      final form = FormData.fromMap({
        'category_code': categoryCode,
        'client_product_id': _uuid.v4(),
        'images': await MultipartFile.fromFile(
          imagePath,
          filename: filename,
          contentType: contentType,
        ),
      });
      await _dio.post<Map<String, dynamic>>(
        '/routines/$routineId/product-inputs',
        data: form,
        options: _authorized(session.accessToken),
      );
    } on DioException catch (error) {
      throw WellLessApiException(_errorMessage(error));
    }
  }

  Options _authorized(String accessToken) =>
      Options(headers: {'Authorization': 'Bearer $accessToken'});

  static Map<String, dynamic> _responseData(Map<String, dynamic>? body) {
    final data = body?['data'];
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw const WellLessApiException('서버 응답 형식이 올바르지 않습니다.');
  }

  static String _errorMessage(DioException error) {
    final body = error.response?.data;
    if (body is Map) {
      final apiError = body['error'];
      if (apiError is Map && apiError['message'] != null) {
        return apiError['message'].toString();
      }
      if (body['detail'] != null) return body['detail'].toString();
    }
    return error.response == null
        ? '서버에 연결하지 못했습니다. 네트워크와 API 주소를 확인해주세요.'
        : '서버 요청에 실패했습니다. (HTTP ${error.response?.statusCode})';
  }
}

class WellLessApiException implements Exception {
  const WellLessApiException(this.message);

  final String message;
}

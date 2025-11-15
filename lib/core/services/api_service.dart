import 'dart:convert';
import 'dart:developer';
import 'package:bm_binus/core/notifiers/session_notifier.dart';
import 'package:bm_binus/core/services/general_service.dart';
import 'package:bm_binus/core/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:js_interop';
import 'package:web/web.dart' as web;

const String baseUrl = "https://yusnar.my.id/go-bm-binus";

class ApiService {
  
  // ============================== API REQUEST ============================== //
  static Future<Map<String, dynamic>?> apiRequest({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
    List<http.MultipartFile> listFile = const [],
    String? token,
    String contentType = 'application/json',
  }) async {
    // init
    http.Response response;
    final url = '$baseUrl$endpoint';
    Map<String, String> header = {'Content-Type': contentType};

    if (token != null) {
      header['Authorization'] = 'Bearer $token';
    }

    try {
      // function hit api
      Future<http.Response> hitAPI() async {
        switch (method.toUpperCase()) {
          case 'POST':
            if (contentType == 'application/json') {
              return http.post(
                Uri.parse(url),
                headers: header,
                body: jsonEncode(body),
              );
            }
            return _handleMultipartRequest(method, url, header, listFile, body);
          case 'GET':
            return http.get(Uri.parse(url), headers: header);
          case 'PUT':
            if (contentType == 'application/json') {
              return http.put(
                Uri.parse(url),
                headers: header,
                body: jsonEncode(body),
              );
            }
            return _handleMultipartRequest(method, url, header, listFile, body);
          case 'DELETE':
            return http.delete(Uri.parse(url), headers: header);
          case 'PATCH':
            return contentType == 'application/json'
                ? http.patch(
                    Uri.parse(url),
                    headers: header,
                    body: jsonEncode(body),
                  )
                : await _handleMultipartRequest(
                    method,
                    url,
                    header,
                    listFile,
                    body,
                  );
          default:
            throw Exception('Unsupported HTTP method: $method');
        }
      }

      // hit api
      response = await hitAPI();
      // cek if refresh token needed
      final isAuthEndpoint = [
        "/auth/login",
        "/auth/logout",
        "/auth/send-email/forgot-password",
        "/auth/verify-number",
        "/auth/register",
      ];
      if (response.statusCode == 401 && !isAuthEndpoint.contains(endpoint)) {
        final newToken = await _refreshToken(token);
        if (newToken != null) {
          header['Authorization'] = 'Bearer $newToken';
          response = await hitAPI();
        } else {
          await _handleExpiredSession();
        }
      } else if (response.statusCode == 422 && !isAuthEndpoint.contains(endpoint)) {
        await _handleExpiredSession();
      }

      // return body
      final Map<String, dynamic> jsonBody = jsonDecode(response.body);
      return jsonBody;
    } catch (e, trace) {
      debugPrint("trace :>>> $trace");
      // return null;
      rethrow;
    }
  }


  // ============================== API REQUEST (PRIVATE FUNCTION) ============================== //
  static Future<http.Response> _handleMultipartRequest(
    String method,
    String url,
    Map<String, String> header,
    List<http.MultipartFile> listFile,
    Map<String, dynamic>? body,
  ) async {
    var request = http.MultipartRequest(method, Uri.parse(url))
      ..headers.addAll(header);
    body?.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    request.files.addAll(listFile);
    return await http.Response.fromStream(await request.send());
  }

  static Future<String?> _refreshToken(String? token) async {
    log("Hit refresh token...");
    try {
      final response = await authRefeshToken(token!);
      if (response!['success'] == true) {
        final newToken = response['data']['token'];
        StorageService.setToken(newToken);
        final token = StorageService.getToken();
        return token;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<void> _handleExpiredSession() async {
    try {
      final storedToken = StorageService.getToken();
      if (storedToken != null) {
        await apiRequest(
          method: 'POST',
          endpoint: '/auth/logout',
          body: null,
          token: storedToken,
          contentType: 'application/json',
        );
      }
    } catch (e) {
      debugPrint("Error when auto logout: $e");
    } finally {
      StorageService.clearToken();
      sessionExpiredNotifier.value = true;
    }
  }


  // ============================== AUTH ============================== //
  static Future<Map<String, dynamic>?> authLogin(
    String email,
    String password,
  ) async {
    final response = await apiRequest(
      method: 'POST',
      endpoint: '/auth/login',
      body: {'email': email, 'password': password,},
      token: null,
      contentType: 'application/json',
    );

    return response;
  }

  static Future<Map<String, dynamic>?> authRefeshToken(String token) async {
    final url = '$baseUrl/auth/refresh-token';
    Map<String, String> header = {'Content-Type': 'application/json'};
    header['Authorization'] = 'Bearer $token';
    final response = await http.post(
      Uri.parse(url),
      body: null,
      headers: header,
    );
    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    return jsonBody;
  }

  static Future<void> authLogout() async {
    final token = StorageService.getToken();

    try {
      final response = await apiRequest(
        method: 'POST',
        endpoint: '/auth/logout',
        body: null,
        token: token,
        contentType: 'application/json',
      );

      if (response == null || response['code'] != 200) {
        log("Logout API gagal: ${response?['code']}");
      }
      
      StorageService.clearToken();
    } catch (e) {
      debugPrint("Error when logout: $e");
    }
  }

  static Future<Map<String, dynamic>?> sendForgotPasswordEmail(
    String email,
  ) async {
    try {
      final response = await apiRequest(
        method: 'POST',
        endpoint: '/auth/send-email/forgot-password',
        body: {'email': email},
        token: null,
        contentType: 'application/json',
      );

      if (response != null && response['code'] == 401) {
        return {'success': false, 'message': 'Email tidak terdaftar'};
      }
      return response;
    } catch (e) {
      debugPrint('Error when sent email reset: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan saat mengirim email reset: $e',
      };
    }
  }

  static Future<dynamic> userInfo(String token) async {
    final url = '$baseUrl/user/info';
    Map<String, String> header = {'Content-Type': 'application/json'};
    header['Authorization'] = 'Bearer $token';
    final response = await http.get(
      Uri.parse(url),
      headers: header,
    );
    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    return jsonBody;
  }

  static Future<String?> refreshTokenForWebSocket(String? token) async {
    log("Hit socket refresh token...");
    try {
      final response = await authRefeshToken(token!);
      if (response!['success'] == true) {
        final newToken = response['data']['token'];
        StorageService.setToken(newToken);
        final token = StorageService.getToken();
        return token;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }


  // ============================== DASHBOARD & NOTIF ============================== //
  static Future<dynamic> handleNotifDashboard({
    required String method,
    int? notifId,
    bool? getDashboard,
    int? roleId,
    String? contentType = "application/json",
    Map<String, String>? params,
  }) async {
    final token = StorageService.getToken();

    String endpoint;
    if (method == 'GET') {
      endpoint = '/notification${params != null ? GeneralService.buildQueryParams(params) : ""}';
      if (getDashboard != null && roleId != null){
        endpoint = '/dashboard/$roleId';
      }
    } else if (method == 'PUT') {
      endpoint = '/notification/set-read-all';
    } else if (method == 'PATCH' && notifId != null) {
      endpoint = '/notification/set-read/$notifId';
    } else {
      throw Exception('Parameter tidak lengkap untuk operasi $method');
    }

    if (token == null && endpoint.contains("/notification?")) return null;
    
    final response = await apiRequest(
      method: method,
      endpoint: endpoint,
      token: token,
      contentType: contentType!,
    );

    return response;
  }


  // ============================== MASTER DATA (USER) ============================== //
  static Future<dynamic> handleUser({
    required String method,
    int? userId,
    Map<String, dynamic>? data,
    String? contentType = "application/json",
    Map<String, String>? params,
  }) async {
    final token = StorageService.getToken();

    String endpoint;
    if (method == 'GET') {
      endpoint = '/user${userId != null ? "/$userId" : ""}${params != null ? GeneralService.buildQueryParams(params) : ""}';
    } else if (method == 'POST') {
      endpoint = '/user';
    } else if (method == 'PUT' && userId != null) {
      endpoint = '/user/$userId';
    } else if (method == 'PATCH' && userId != null) {
      endpoint = '/user/change-password/$userId';
    } else if (method == 'DELETE' && userId != null) {
      endpoint = '/user/$userId';
    } else {
      throw Exception('Parameter tidak lengkap untuk operasi $method');
    }

    final response = await apiRequest(
      method: method,
      endpoint: endpoint,
      body: data,
      token: token,
      contentType: contentType!,
    );

    return response;
  }


  // ============================== MASTER DATA (EVENT TYPE) ============================== //
  static Future<dynamic> handleEventType({
    required String method,
    int? eventTypeId,
    Map<String, dynamic>? data,
    String? contentType = "application/json",
    Map<String, String>? params,
  }) async {
    final token = StorageService.getToken();

    String endpoint;
    if (method == 'GET') {
      endpoint = '/request/event-type${eventTypeId != null ? "/$eventTypeId" : ""}${params != null ? GeneralService.buildQueryParams(params) : ""}';
    } else if (method == 'POST') {
      endpoint = '/request/event-type';
    } else if (method == 'PUT' && eventTypeId != null) {
      endpoint = '/request/event-type/$eventTypeId';
    } else if (method == 'DELETE' && eventTypeId != null) {
      endpoint = '/request/event-type/$eventTypeId';
    } else {
      throw Exception('Parameter tidak lengkap untuk operasi $method');
    }

    final response = await apiRequest(
      method: method,
      endpoint: endpoint,
      body: data,
      token: token,
      contentType: contentType!,
    );

    return response;
  }


  // ============================== REQUEST ============================== //
  static Future<dynamic> handleRequest({
    required String method,
    int? requestId,
    Map<String, dynamic>? data,
    String? contentType = "application/json",
    Map<String, String>? params,
    List<http.MultipartFile> listFile = const [],
  }) async {
    final token = StorageService.getToken();

    String endpoint;
    if (method == 'GET') {
      endpoint = '/request${requestId != null ? "/$requestId" : ""}${params != null ? GeneralService.buildQueryParams(params) : ""}';
    } else if (method == 'POST') {
      endpoint = '/request';
    } else if (method == 'PUT' && requestId != null) {
      endpoint = '/request/$requestId';
    } else if (method == 'DELETE' && requestId != null) {
      endpoint = '/request/$requestId';
    } else {
      throw Exception('Parameter tidak lengkap untuk operasi $method');
    }

    final response = await apiRequest(
      method: method,
      endpoint: endpoint,
      body: data,
      token: token,
      contentType: contentType!,
      listFile: listFile
    );

    return response;
  }


  // ============================== STATUS ============================== //
  static Future<dynamic> handleStatus({
    required String method,
    int? statusId,
    Map<String, dynamic>? data,
    String? contentType = "application/json",
    Map<String, String>? params,
  }) async {
    final token = StorageService.getToken();

    String endpoint;
    if (method == 'GET') {
      endpoint = '/status${statusId != null ? "/$statusId" : ""}${params != null ? GeneralService.buildQueryParams(params) : ""}';
    } else if (method == 'POST') {
      endpoint = '/status';
    } else if (method == 'PUT' && statusId != null) {
      endpoint = '/status/$statusId';
    } else if (method == 'DELETE' && statusId != null) {
      endpoint = '/status/$statusId';
    } else {
      throw Exception('Parameter tidak lengkap untuk operasi $method');
    }

    final response = await apiRequest(
      method: method,
      endpoint: endpoint,
      body: data,
      token: token,
      contentType: contentType!,
    );

    return response;
  }


  // ============================== COMMENT ============================== //
  static Future<dynamic> handleComment({
    required String method,
    int? commentId,
    Map<String, dynamic>? data,
    String? contentType = "application/json",
    Map<String, String>? params,
  }) async {
    final token = StorageService.getToken();

    String endpoint;
    if (method == 'GET') {
      endpoint = '/request/comment${commentId != null ? "/$commentId" : ""}${params != null ? GeneralService.buildQueryParams(params) : ""}';
    } else if (method == 'POST') {
      endpoint = '/request/comment';
    } else if (method == 'PUT' && commentId != null) {
      endpoint = '/request/comment/$commentId';
    } else if (method == 'DELETE' && commentId != null) {
      endpoint = '/request/comment/$commentId';
    } else {
      throw Exception('Parameter tidak lengkap untuk operasi $method');
    }

    final response = await apiRequest(
      method: method,
      endpoint: endpoint,
      body: data,
      token: token,
      contentType: contentType!,
    );

    return response;
  }


  // ============================== FILE ============================== //
  static Future<dynamic> handleFile({
    required String method,
    int? fileId,
    Map<String, dynamic>? data,
    String? contentType = "application/json",
    Map<String, String>? params,
    List<http.MultipartFile> listFile = const [],
  }) async {
    final token = StorageService.getToken();

    String endpoint;
    if (method == 'GET') {
      endpoint = '/request/file${fileId != null ? "/$fileId" : ""}${params != null ? GeneralService.buildQueryParams(params) : ""}';
    } else if (method == 'POST') {
      endpoint = '/request/file';
    } else if (method == 'PUT' && fileId != null) {
      endpoint = '/request/file/$fileId';
    } else if (method == 'DELETE' && fileId != null) {
      endpoint = '/request/file/$fileId';
    } else {
      throw Exception('Parameter tidak lengkap untuk operasi $method');
    }

    final response = await apiRequest(
      method: method,
      endpoint: endpoint,
      body: data,
      token: token,
      listFile: listFile,
      contentType: contentType!,
    );

    return response;
  }


  // ============================== EXPORT DATA ============================== //
  static Future<http.Response> apiRequestExportData({
    required String method,
    required String endpoint,
    Map<String, String>? params,
    String? token,
  }) async {
    // init
    http.Response response;
    final url = '$baseUrl$endpoint';
    Map<String, String> header = {};

    if (token != null) {
      header['Authorization'] = 'Bearer $token';
    }

    try {
      // function hit api
      Future<http.Response> hitAPI() async {
        switch (method.toUpperCase()) {
          case 'GET':
            return http.get(
              Uri.parse(
                '$url${params != null ? GeneralService.buildQueryParams(params) : ""}',
              ),
              headers: header,
            );
          default:
            throw Exception('Unsupported HTTP method: $method');
        }
      }

      // hit api
      response = await hitAPI();
      // cek if refresh token needed
      final isAuthEndpoint = [
        "/auth/login",
        "/auth/logout",
        "/auth/send-email/forgot-password",
        "/auth/verify-number",
        "/auth/register",
      ];
      if (response.statusCode == 401 && !isAuthEndpoint.contains(endpoint)) {
        final newToken = await _refreshToken(token);
        if (newToken != null) {
          header['Authorization'] = 'Bearer $newToken';
          response = await hitAPI();
        } else {
          await _handleExpiredSession();
        }
      } else if (response.statusCode == 422 && !isAuthEndpoint.contains(endpoint)) {
        await _handleExpiredSession();
      }

      return response;
    } catch (e, trace) {
      debugPrint("trace :>>> $trace");
      // return null;
      rethrow;
    }
  }

  static Future<void> downloadFileFromResponse(http.Response response) async {
    final contentDisposition = response.headers['content-disposition'];
    String fileName = 'file.pdf';
    if (contentDisposition != null) {
      final regex = RegExp(r'filename="?([^"]+)"?');
      final match = regex.firstMatch(contentDisposition);
      if (match != null) fileName = match.group(1)!;
    }

    final bytes = response.bodyBytes;
    final jsBytes = bytes.toJS;

    final blobParts = [jsBytes].toJS;
    final blob = web.Blob(blobParts, web.BlobPropertyBag(type: 'application/pdf'));

    final url = web.URL.createObjectURL(blob);

    final anchor = web.HTMLAnchorElement()
      ..href = url
      ..download = fileName
      ..target = '_blank';

    anchor.click();

    web.URL.revokeObjectURL(url);
  }

  static Future<http.Response> exportUsers() async {
    final token = StorageService.getToken();
    final response = await apiRequestExportData(
      method: 'GET',
      endpoint: '/user/export',
      params: {'format':'pdf'},
      token: token,
    );
    return response;
  }

  static Future<http.Response> exportRequests(Map<String, String> param) async {
    final token = StorageService.getToken();
    final response = await apiRequestExportData(
      method: 'GET',
      endpoint: '/request/export',
      params: param,
      token: token,
    );
    return response;
  }

  static Future<http.Response> exportRequestById(int requestId) async {
    final token = StorageService.getToken();
    final response = await apiRequestExportData(
      method: 'GET',
      endpoint: '/request/export/$requestId',
      params: {'format':'pdf'},
      token: token,
    );
    return response;
  }
}

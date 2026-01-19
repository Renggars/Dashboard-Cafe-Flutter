import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ProductService {
  final String baseUrl = "http://10.0.2.2:4001/v1";

  Future<List<Map<String, dynamic>>> getMenus() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/menu'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        final List results = body['data']['menus'];
        return results.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      debugPrint("Error GetMenus: $e");
      return [];
    }
  }

  Future<bool> createProduct({
    required String name,
    required int price,
    required int categoryId,
    File? imageFile,
    required String token,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl/menu');
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll({"Authorization": "Bearer $token"});
      request.fields['name'] = name;
      request.fields['price'] = price.toString();
      request.fields['categoryId'] = categoryId.toString();

      if (imageFile != null) await _addFileToRequest(request, imageFile, name);

      var response = await http.Response.fromStream(await request.send());
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProduct({
    required int id,
    required String name,
    required int price,
    required int categoryId,
    File? imageFile,
    required String token,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl/menu/$id');
      var request = http.MultipartRequest('PUT', uri);
      request.headers.addAll({"Authorization": "Bearer $token"});
      request.fields['name'] = name;
      request.fields['price'] = price.toString();
      request.fields['categoryId'] = categoryId.toString();

      if (imageFile != null) await _addFileToRequest(request, imageFile, name);

      var response = await http.Response.fromStream(await request.send());
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteProduct(int id, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/menu/$id'),
        headers: {"Authorization": "Bearer $token"},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> _addFileToRequest(
      http.MultipartRequest request, File file, String name) async {
    String fileName = file.path.split('/').last;
    String extension = fileName.split('.').last.toLowerCase();
    if (extension.length > 4 || extension == 'cache' || extension == 'tmp') {
      extension = 'jpg';
      fileName = "upload_${name.replaceAll(' ', '_')}.$extension";
    }
    request.files.add(await http.MultipartFile.fromPath(
      'imageUrl',
      file.path,
      filename: fileName,
      contentType: MediaType('image', (extension == 'png') ? 'png' : 'jpeg'),
    ));
  }
}

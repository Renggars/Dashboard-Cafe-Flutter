import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  final String baseUrl = "http://10.0.2.2:4001/v1";

  // 1. GET ALL CATEGORIES
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/category'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        final List results = body['data']['categories'];
        return results.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      debugPrint("Error GetCategories: $e");
      return [];
    }
  }

  // 2. CREATE CATEGORY
  Future<bool> createCategory(String name, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/category'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"name": name}),
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // 3. UPDATE CATEGORY
  Future<bool> updateCategory(int id, String name, String token) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/category/$id'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"name": name}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // 4. DELETE CATEGORY
  Future<bool> deleteCategory(int id, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/category/$id'),
        headers: {"Authorization": "Bearer $token"},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

import 'dart:io';
import 'package:link_shortener/model/model.dart';
import 'package:dio/dio.dart';

class PostService {
  final Dio _dio = Dio();
  String? link;
  Future<void> postItemService(Model model) async {
    try {
      final response =
          await _dio.post('https://cleanuri.com/api/v1/shorten', data: model);
      if (response.statusCode == HttpStatus.ok) {
        final data = response.data;
        link = data['result_url'];
      }
    } catch (_) {
     
    }

 
  }
}

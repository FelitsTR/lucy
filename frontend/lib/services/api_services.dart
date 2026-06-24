import 'package:dio/dio.dart';

import '../models/analysis.dart';

class ApiService {

  final Dio dio = Dio();

  final String baseUrl =
      "http://192.168.1.76:8000";

  Future<Analysis> uploadFile(
    String filePath,
  ) async {

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        filePath,
      ),
    });

    Response response =
        await dio.post(
      "$baseUrl/analysis/upload/",
      data: formData,
    );

    print(response.data);

    return Analysis.fromJson(
      response.data,
    );
  }
}
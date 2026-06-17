import 'package:flutter/material.dart';
import '../models/analysis.dart';
import '../services/api_services.dart';
import 'package:file_picker/file_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {

  Analysis? analysis;
  bool isLoading = false;
  final ApiService apiService =
    ApiService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lucy Metronome",
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickAndUpload,
              child: const Text(
                "Seleccionar MP3",
              ),
            ),
            if (isLoading)
              const CircularProgressIndicator(),
            if (analysis != null) ...[
              Text(
                "BPM: ${analysis!.bpm}",
              ),

              Text(
                "Duración: ${analysis!.duration}",
              ),

              Text(
                "Beats: ${analysis!.beatsCount}",
              ),
            ]
          ],
        ),
      ),
    );
  }

  Future<void> pickAndUpload()
  async {

    final result =
        await FilePicker.platform
            .pickFiles(
      type: FileType.audio,
    );

    if (result == null) {
      return;
    }

    final path =
        result.files.single.path;

    if (path == null) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      final response =
          await apiService.uploadFile(
        path,
      );

      setState(() {
        analysis = response;
      });

    } catch (e) {

      print(e);

    } finally {

      setState(() {
        isLoading = false;
      });

    }
  }
}
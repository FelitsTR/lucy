import 'package:flutter/material.dart';
import '../models/analysis.dart';
import '../services/api_services.dart';
import 'package:file_picker/file_picker.dart';
import '../utils/time_formatter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {

  Analysis? analysis;
  String? selectedFileName;
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
            if (analysis != null)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "🎵 ${selectedFileName ?? ''}",
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 20),

                      Text(
                        "BPM",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),

                      Text(
                        analysis!.bpm.toString(),
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 16),

                      Text(
                        "Duración",
                      ),

                      Text(
                        TimeFormatter
                            .formatSeconds(
                          analysis!.duration,
                        ),
                      ),

                      SizedBox(height: 16),

                      Text(
                        "Beats detectados",
                      ),

                      Text(
                        analysis!.beatsCount.toString(),
                      ),
                    ],
                  ),
                ),
              ),
            if (analysis == null)
              ElevatedButton(
                onPressed: pickAndUpload,
                child: Text(
                  "Seleccionar MP3",
                ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickAndUpload() async {

  print("1. Entró al método");

  final result =
      await FilePicker.platform.pickFiles(
    type: FileType.audio,
  );

  print("2. Terminó FilePicker");

  if (result == null) {
    print("Usuario canceló");
    return;
  }

  final path = result.files.single.path;

  print("3. Path: $path");

  if (path == null) {
    print("Path nulo");
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {

    print("4. Subiendo archivo");

    final response =
        await apiService.uploadFile(path);

    print("5. Respuesta recibida");
    print(response);

    setState(() {
      analysis = response;
    });

  } catch (e) {

    print("ERROR:");
    print(e);

  } finally {

    print("6. Finalizó");

    setState(() {
      isLoading = false;
    });
  }

  setState(() {
    selectedFileName =
        result.files.single.name;
  });
}
}
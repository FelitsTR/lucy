import 'package:flutter/material.dart';
import '../models/analysis.dart';
import '../services/api_services.dart';
import 'package:file_picker/file_picker.dart';
import '../utils/time_formatter.dart';
import '../services/audio_player_service.dart';

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
  String? selectedFilePath;
  Duration currentPosition = Duration.zero;
  int nextBeatIndex = 0;
  
  final audioPlayerService =
    AudioPlayerService();
  final ApiService apiService =
    ApiService();

  @override
  void initState() {
    super.initState();

    audioPlayerService.positionStream.listen(
    (position) {

      if (analysis != null) {

        while (
          nextBeatIndex <
          analysis!.beats.length &&
          position.inMilliseconds / 1000 >=
              analysis!.beats[nextBeatIndex]
        ) {

          nextBeatIndex++;
        }
      }

      setState(() {
        currentPosition = position;
      });
    },
  );
}

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
                      Text(
                        "Beats recibidos: ${analysis!.beats.length}",
                      ),
                      Text(
                        analysis!.beats
                            .take(5)
                            .join(", "),
                      ),
                      Text(
                        "Posición actual",
                      ),

                      Text(
                        TimeFormatter.formatSeconds(
                          currentPosition.inSeconds.toDouble(),
                        ),
                      ),
                      Text(
                        "Beats recibidos: ${analysis!.beats.length}",
                      ),
                      if (analysis != null)
                        Text(
                          "Beat actual: $nextBeatIndex",
                        ),
                    ],
                  ),
                ),
              ),
            ElevatedButton(
              onPressed: () async {

                if (selectedFilePath == null) {
                  return;
                }

                await audioPlayerService.loadAudio(
                  selectedFilePath!,
                );

                await audioPlayerService.play();
              },
              child: const Text(
                "▶ Reproducir",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickAndUpload() async {

  final result =
      await FilePicker.platform.pickFiles(
    type: FileType.audio,
  );

  if (result == null) {
    return;
  }

  final path = result.files.single.path;

  selectedFilePath = path;

  if (path == null) {
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {

    final response =
        await apiService.uploadFile(path);

    setState(() {
      analysis = response;
    });

  } catch (e) {

    print("Error al subir el archivo: $e");

  } finally {

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
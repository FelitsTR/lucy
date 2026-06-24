class Analysis {

  final int id;
  final double bpm;
  final double duration;
  final int beatsCount;
  final List<double> beats;

  Analysis({
    required this.id,
    required this.bpm,
    required this.duration,
    required this.beatsCount,
    required this.beats,
  });

  factory Analysis.fromJson(
    Map<String, dynamic> json,
  ) {
    return Analysis(
      id: json["id"],
      bpm: json["bpm"].toDouble(),
      duration: json["duration"].toDouble(),
      beatsCount: (json["beats_count"] as num).toInt(),
      beats: List<double>.from(
        json["beats"].map(
          (x) => (x as num).toDouble(),
        ),
      ),
    );
  }
}
class TimeFormatter {

  static String formatSeconds(double seconds){
    
    final duration = Duration(seconds: seconds.round());
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds % 60;

    return "${minutes}m ${remainingSeconds}s";
  }
}
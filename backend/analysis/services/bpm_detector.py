import librosa

def analyze_audio(file_path):

    y, sr = librosa.load(file_path)

    tempo, beats = librosa.beat.beat_track(
        y=y,
        sr=sr
    )

    duration = librosa.get_duration(
        y=y,
        sr=sr
    )

    beat_times = librosa.frames_to_time(
        beats,
        sr=sr
    )

    return {
        "bpm": float(tempo.item()),
        "duration": float(duration),
        "beats": beat_times.tolist()
    }
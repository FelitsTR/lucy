import librosa

def detect_bpm(file_path):

    y, sr = librosa.load(file_path)

    tempo, beats = librosa.beat.beat_track(
        y=y, 
        sr=sr
    )

    beat_times = librosa.frames_to_time(
        beats, 
        sr=sr
        )

    return {
        'bpm': tempo,
        'beat_times': beat_times.tolist()
    }
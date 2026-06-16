from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.response import Response

from analysis.models import AudioAnalysis
from analysis.serializers import AudioAnalysisSerializer
from analysis.services.bpm_detector import analyze_audio


class AudioAnalysisViewSet(viewsets.ModelViewSet):

    queryset = AudioAnalysis.objects.all()
    serializer_class = AudioAnalysisSerializer

    @action(
        detail=False,
        methods=["post"]
    )
    def upload(self, request):

        file = request.FILES.get("file")

        if not file:
            return Response({
                "error": "No file provided"
            }, status=400)
        

        analysis = AudioAnalysis.objects.create(
            file=file
        )

        result = analyze_audio(analysis.file.path)

        analysis.bpm = result["bpm"]
        analysis.duration = result["duration"]
        analysis.beats = result["beats"]

        analysis.save()

        print("BPM:", result["bpm"])
        print("Duración:", result["duration"])
        print("Beats:", len(result["beats"]))

        return Response({
            "id": analysis.id,
            "bpm": analysis.bpm,
            "duration": analysis.duration,
            "beats": analysis.beats[:10]
        })
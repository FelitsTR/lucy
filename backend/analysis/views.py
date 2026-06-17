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

        analysis.bpm = round(result["bpm"], 2)
        analysis.duration = round(result["duration"], 2)
        analysis.beats = result["beats"]

        analysis.save()

        return Response({
            "id": analysis.id,
            "bpm": analysis.bpm,
            "duration": analysis.duration,
            "beats": analysis.beats[:10],
            "beats_count": len(analysis.beats),
        })
    
    @action(
        detail=True,
        methods=["get"],
        url_path="beats",
        url_name="beats"
    )
    def get_beats(self, request, pk=None):

        instance = self.get_object()

        return Response({
        "id": instance.id,
        "bpm": instance.bpm,
        "duration": instance.duration,
        "beats_count": len(instance.beats)
    })
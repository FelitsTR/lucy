from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.response import Response

from analysis.models import AudioAnalysis
from analysis.serializers import AudioAnalysisSerializer


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

        return Response({
            "id": analysis.id,
            "file": analysis.file.url
        })
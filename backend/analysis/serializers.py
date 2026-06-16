from analysis.models import AudioAnalysis
from rest_framework import serializers


class AudioAnalysisSerializer(serializers.ModelSerializer):

    class Meta:
        model = AudioAnalysis
        fields = [
            'id',
            'file',
            'bpm',
            'duration',
            'beats',
            'created_at'
        ]
        read_only_fields = [
            'id',
            'bpm',
            'duration',
            'beats',
            'created_at'
        ]
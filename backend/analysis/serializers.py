from analysis.models import AudioAnalysis
from rest_framework import serializers


class AudioAnalysisSerializer(serializers.ModelSerializer):
    class Meta:
        model = AudioAnalysis
        fields = '__all__'
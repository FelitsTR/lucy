from django.db import models

# Create your models here.
class AudioAnalysis(models.Model):

    file = models.FileField(upload_to='songs/')
    original_filename = models.CharField(max_length=255)
    bpm = models.FloatField(blank=True, null=True)
    duration = models.FloatField(null=True)
    beats = models.JSONField(default=list)

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Analysis {self.id}"
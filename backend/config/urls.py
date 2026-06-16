from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

from rest_framework.routers import DefaultRouter

from analysis.views import AudioAnalysisViewSet


router = DefaultRouter()

router.register(
    "analysis",
    AudioAnalysisViewSet,
    basename="analysis"
)

urlpatterns = [
    path("admin/", admin.site.urls),
    path("", include(router.urls)),
]

# Serve media files during development
urlpatterns += static(
    settings.MEDIA_URL,
    document_root=settings.MEDIA_ROOT
)
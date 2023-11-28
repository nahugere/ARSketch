from django.urls import path, include
from . import views as v

urlpatterns = [
    path("a/", v.get_sketches),
    path("s/", v.search_sketch),
    path("g/", v.get_sketch),
]
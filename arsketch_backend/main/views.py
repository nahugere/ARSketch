from django.shortcuts import render
from django.http import JsonResponse
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.authtoken.models import Token
from .models import *

# Fetch a specific sketch
@api_view(["GET"])
def get_sketch(request):
    slug = request.GET.get("slug")
    sketch = Sketch.objects.get(id=int(slug))
    response = {
        "name": sketch.name,
        "description": sketch.description,
        "date": f"{sketch.date.month}/{sketch.date.day}/{sketch.date.year}",
        "images": [ x.image.url for x in sketch.sketchimage_set.all() ]
    }
    return JsonResponse(response)

@api_view(["GET"])
def get_sketches(request):
    sketches = Sketch.objects.all()
    response = [
        {
            "name": sketch.name,
            "description": sketch.description,
            "thumbnail": sketch.thumbnail.url,
            "date": f"{sketch.date.month}/{sketch.date.day}/{sketch.date.year}",
            "images": [ x.image.url for x in sketch.sketchimage_set.all() ]
        } for sketch in sketches
    ]
    return JsonResponse(response, safe=False)


@api_view(["GET"])
def search_sketch(request):
    kw = request.GET.get("query")
    sketches = Sketch.objects.filter(name__icontains=kw)
    response = [
        {
            "name": sketch.name,
            "description": sketch.description,
            "thumbnail": sketch.thumbnail.url,
            "date": f"{sketch.date.month}/{sketch.date.day}/{sketch.date.year}",
        } for sketch in sketches
    ]
    return JsonResponse(response, safe=False)

from django.db import models
from django.contrib.auth.models import User
from datetime import datetime

class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    profile = models.ImageField(upload_to="profiles/", null=True, blank=True)

class Sketch(models.Model):
    name = models.CharField(max_length=200, null=False, blank=False)
    description = models.CharField(max_length=400, null=True, blank=True, default="")
    thumbnail = models.ImageField(upload_to="sketch_images/", null=True, blank=False)
    sketcher = models.ForeignKey(User, on_delete=models.CASCADE)
    date = models.DateTimeField(default=datetime.now, blank=True)

    def __str__(self):
        return f"{self.id} | {self.name}"

class SketchImage(models.Model):
    sketch = models.ForeignKey(Sketch, null=True, on_delete=models.CASCADE, blank=False)
    image = models.ImageField(upload_to="sketch_images/", null=True, blank=False)
    date = models.DateTimeField(default=datetime.now, blank=True)

class Progress(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    sketch = models.ForeignKey(Sketch, on_delete=models.CASCADE)
    progress = models.FloatField(default=0)
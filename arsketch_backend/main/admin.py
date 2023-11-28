from django.contrib import admin
from .models import *

class SketchImageInline(admin.TabularInline):
    extra = 0
    model = SketchImage
    
class SketchAdmin(admin.ModelAdmin):
    date_hierarchy = "date"
    list_per_page = 40
    inlines = [
        SketchImageInline,
    ]


admin.site.register(Profile)
admin.site.register(Sketch, SketchAdmin)

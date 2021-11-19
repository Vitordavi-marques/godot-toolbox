extends CollisionPolygon2D

export (Color) var graphics_color = Color.white
export (bool) var generate_graphics = true
export (bool) var generate_light_occluder = false
export (bool) var generate_on_ready = false

var graphics : Polygon2D
var light_occluder : LightOccluder2D

func _ready():
	if not generate_on_ready:
		return
	if generate_graphics:
		generate_graphics_polygon()
	if generate_light_occluder:
		generate_occluder_polygon()

func generate_graphics_polygon():
	graphics = Polygon2D.new()
	graphics.polygon = polygon
	graphics.color = graphics_color
	add_child(graphics)
	graphics.name = "_graphics"

func generate_occluder_polygon():
	light_occluder = LightOccluder2D.new()
	light_occluder.occluder.polygon = polygon
	add_child(light_occluder)
	light_occluder.name = "_occluder"

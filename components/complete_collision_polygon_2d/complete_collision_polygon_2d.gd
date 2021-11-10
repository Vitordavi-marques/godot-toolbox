extends CollisionPolygon2D

export (Color) var graphics_color = Color.white
export (bool) var generate_graphics = true
export (bool) var generate_light_occluder = false

var graphics : Polygon2D
var light_occluder : LightOccluder2D

func _ready():
	if generate_graphics:
		graphics = Polygon2D.new()
		graphics.polygon = polygon
		graphics.color = graphics_color
		add_child(graphics)
		graphics.name = "_graphics"
	if generate_light_occluder:
		light_occluder = LightOccluder2D.new()
		light_occluder.occluder.polygon = polygon
		add_child(light_occluder)
		light_occluder.name = "_occluder"

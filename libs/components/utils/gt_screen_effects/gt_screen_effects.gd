extends CanvasLayer

export (bool) var is_enabled = true
export (Color) var overlay_color setget set_overlay_color
export (Color) var overlay_modulate setget set_overlay_modulate

onready var overlay_rect = $root/overlay_rect
onready var tween = $Tween

func _ready():
	overlay_rect.color = overlay_color
	overlay_rect.modulate = overlay_modulate

func set_overlay_color(_value):
	overlay_color = _value

func set_overlay_modulate(_value):
	overlay_modulate = _value

func change_color(start_color: Color, end_color: Color, duration: float):
	if not is_enabled: return
	tween.interpolate_property(overlay_rect, "color", start_color, end_color, duration)
	tween.start()

func change_modulate(start_mod: Color, end_mod: Color, duration: float):
	if not is_enabled: return
	tween.interpolate_property(overlay_rect, "modulate", start_mod, end_mod, duration)
	tween.start()

func fade_to_transparent(duration: float = 0.2):
	change_modulate(Color.white, Color.transparent, duration)

func fade_from_transparent(duration: float = 0.2):
	change_modulate(Color.transparent, Color.white, duration)

extends Area2D
class_name GTPollableArea2D

var is_colliding_area : bool = false
var is_colliding_body : bool = false


func _on_area_entered(area):
	is_colliding_area = true


func _on_area_exited(area):
	is_colliding_area = false


func _on_body_entered(body):
	is_colliding_body = true


func _on_body_exited(body):
	is_colliding_body = false

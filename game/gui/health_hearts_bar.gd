extends Node2D

const HEARTS = preload("res://gui/heart.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_health(current_health,max_health):
	if max_health%2 == 0:
		for i in range(0,current_health/2):
			var sprite = CIRCLES
	else:

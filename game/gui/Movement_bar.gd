extends Node2D

const MOVEMENT_BAR = preload("res://gui/movement_indicator.tscn")

var hearts = []
func _ready():
	pass # Replace with function body.


func set_movement_bar(current_movement,max_movement):
	hearts.clear()
	
	for i in range(0,current_movement):
		var sprite = MOVEMENT_BAR.instance()
		hearts.append(sprite)
		sprite.animation = "movement";
		sprite.frame = 0;
		sprite.position = i*Vector2(32,0) + Vector2(16,44);
		add_child(sprite);
	for i in range(current_movement,max_movement):
		var sprite = MOVEMENT_BAR.instance()
		hearts.append(sprite)
		sprite.animation = "movement";
		sprite.frame = 1;
		sprite.position = i*Vector2(32,0) + Vector2(16,44);
		add_child(sprite);
	

func clear_movement_bar():
	delete_children(self);
		
static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()


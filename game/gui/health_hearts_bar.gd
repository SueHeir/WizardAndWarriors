extends Node2D

const HEARTS = preload("res://gui/heart.tscn")

var hearts = []
func _ready():
	pass # Replace with function body.


func set_health_bar(current_health,max_health):
	hearts.clear()
	if current_health%2 == 0:
		for i in range(0,current_health/2):
			var sprite = HEARTS.instance()
			hearts.append(sprite)
			sprite.animation = "hearts";
			sprite.frame = 0;
			sprite.position = i*Vector2(32,0) + Vector2(16,16);
			add_child(sprite);
		for i in range(current_health/2,max_health/2):
			var sprite = HEARTS.instance()
			hearts.append(sprite)
			sprite.animation = "hearts";
			sprite.frame = 2;
			sprite.position = i*Vector2(32,0) + Vector2(16,16);
			add_child(sprite);
	else:
		for i in range(0,(current_health-1)/2):
			var sprite = HEARTS.instance()
			hearts.append(sprite)
			sprite.animation = "hearts";
			sprite.frame = 0;
			sprite.position = i*Vector2(32,0) + Vector2(16,16);
			add_child(sprite);
		var sprit = HEARTS.instance()
		hearts.append(sprit)
		sprit.animation = "hearts";
		sprit.frame = 1;
		sprit.position = ((current_health-1)/2)*Vector2(32,0) + Vector2(16,16);
		add_child(sprit);
		for i in range((current_health+1)/2,max_health/2):
			var sprite = HEARTS.instance()
			hearts.append(sprite)
			sprite.animation = "hearts";
			sprite.frame = 2;
			sprite.position = i*Vector2(32,0) + Vector2(16,16);
			add_child(sprite);

func clear_health_bar():
	delete_children(self);
		
static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()


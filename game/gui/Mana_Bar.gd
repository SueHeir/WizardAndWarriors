extends Node2D

var mana_fram_colors = {'green':0,'blue':1,'red':2,'yellow':3,'orange':4,'purple':5};

var sprites1 = []
var sprites2 = []
const CIRCLES = preload("res://gui/circles.tscn")

func _ready():
	pass



func set_mana_bar_vertex(mana_list):
	sprites1.clear();
	for i in mana_list.size():
		var sprite = CIRCLES.instance();
		sprites1.append(sprite)
		if mana_list[i].used:
			sprite.animation = "Dark";
		else:
			sprite.animation = "Light";
		sprite.frame = mana_fram_colors[mana_list[i].mana_type];
		sprite.position = i*Vector2(0,-35) + Vector2(30,0);
		add_child(sprite);
		#print(sprite.position)
		

func set_mana_bar_grabbed(mana_list):
	sprites2.clear();
	for i in mana_list.size():
		var sprite = CIRCLES.instance();
		sprites2.append(sprite)
		if mana_list[i].grabbed_used:
			sprite.animation = "Dark";
		else:
			sprite.animation = "Light";
		sprite.frame = mana_fram_colors[mana_list[i].mana_type];
		sprite.position = i*Vector2(0,-35) + Vector2(65,0);
		add_child(sprite);
		#print(sprite.position)


func clear_mana_bar():
	delete_children(self);
		
static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

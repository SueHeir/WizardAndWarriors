extends Control

var mana_fram_colors = {'green':0,'blue':1,'red':2,'yellow':3,'orange':4,'purple':5};

var sprites = []

const CIRCLES = preload("res://gui/circles.tscn")

func _ready():
	pass

func _process(delta):
	if visible:
		for circle in sprites:
			if


func set_mana_bar(mana_type_list):
	sprites.clear();
	delete_children(self);
	for i in mana_type_list.size():
		var sprite = CIRCLES.instance();
		sprites.append(sprite)
		sprite.frame = mana_fram_colors[mana_type_list[i]];
		sprite.scale = Vector2(2,2)
		sprite.position = (i+1)*Vector2(70,0) - Vector2(70,0)*mana_type_list.size()/2;
		add_child(sprite);
		#print(sprite.position)
		
static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

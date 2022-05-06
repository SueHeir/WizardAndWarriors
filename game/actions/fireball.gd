extends Action_Spell


onready var FIREBALL_ANIMATION = load("res://actions/action_animations/fireball_animation.tscn")

func _ready():
	action_name = "FireBall"
	load_action_bar_texture("res://actions/action_bar_textures/fireball")
	mana_cost = ["red"]
	
func get_useable_map_spots(map, player):
	for vertex in map.vertexes:
		var distance = player.position - vertex.position;
		if distance.length() < 200 and vertex.holding_object:
			if vertex.holding_object != player:
				vertex.set_active_action(self)


func do_action(player, map_object):
	.do_action(player, map_object)
	var fireball = FIREBALL_ANIMATION.instance()
	fireball.set_start_and_end(player,map_object.holding_object)
	map_object.get_parent().add_child(fireball)
	
	
	

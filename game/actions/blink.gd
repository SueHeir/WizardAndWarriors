extends Action_Spell

func _ready():
	action_name = "Blink"
	load_action_bar_texture("res://actions/action_bar_textures/blink")
	mana_cost = ["blue"]
	
func get_useable_map_spots(map, player):
	for vertex in map.vertexes:
		var distance = player.position - vertex.position;
		if distance.length() < 140:
			vertex.set_active_action(self)


func do_action(player, map_object):
	.do_action(player, map_object)
	player.set_current_vertex(map_object)
	

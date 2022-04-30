extends Action_Spell

func _ready():
	action_name = "Dash"
	load_action_bar_texture("res://actions/action_bar_textures/dash")
	mana_cost = ["yellow"]
	
func get_useable_map_spots(map, player):
	for vertex in player.current_vertex.adjacent_vertexes:
		vertex.set_active_action(self)


func do_action(player, map_object):
	player.current_steps += 1
	player.walk_to_vertex(map_object)

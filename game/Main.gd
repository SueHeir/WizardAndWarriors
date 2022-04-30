extends Node2D


var current_action;

func _ready():
	$Player.set_current_vertex($Map.vertexes[5])
	$Camera2D.position = $Player.position
	$Camera2D/CanvasLayer/Action_bar.init_player_actions($Player)
	


func _process(delta):
	$Camera2D/CanvasLayer/Mana_bar/Mana_bar.clear_mana_bar()
	$Camera2D/CanvasLayer/Mana_bar/Mana_bar.set_mana_bar_vertex($Player.current_vertex.adjacent_mana)
	$Camera2D/CanvasLayer/Mana_bar/Mana_bar.set_mana_bar_grabbed($Player.grabbed_mana)
	


func _on_Next_released():
	next_turn();


func next_turn():
	$Map.next_turn();
	$Player.next_turn();


func set_current_action(action):
	current_action = action;
	if current_action:
		current_action.get_useable_map_spots($Map, $Player)
	else:
		$Map.clear_actions();

extends Node2D

var current_action;

func _ready():
	$Player.set_current_vertex($Map.vertexes[$Map.starting_vertex_index])
	$Camera2D.position = $Player.position
	$Camera2D/CanvasLayer/Action_bar.init_player_actions($Player)
	


func _process(delta):
	$Camera2D/CanvasLayer/Mana_bar/Mana_bar.clear_mana_bar()
	$Camera2D/CanvasLayer/Mana_bar/Mana_bar.set_mana_bar_vertex($Player.current_vertex.adjacent_mana)
	$Camera2D/CanvasLayer/Mana_bar/Mana_bar.set_mana_bar_grabbed($Player.grabbed_mana)
	
	if $Player.current_vertex == $Map.vertexes[$Map.vertexes.size()-1]:
		$Camera2D/CanvasLayer/Win.text = "You Win!"
		
		var file = File.new()
		file.open("res://saves/saves.json", File.READ_WRITE)
		var text = file.get_as_text()
		var result_json = JSON.parse(text)
		if result_json.error != OK:
			print("[load_json_file] Error loading JSON file '" + str("path") + "'.")
			print("\tError: ", result_json.error)
			print("\tError Line: ", result_json.error_line)
			print("\tError String: ", result_json.error_string)
			return null
		var obj = result_json.result
		var current_level = obj["current_level"]
		current_level +=1
		var save_dictionary = {"current_level":current_level}
		file.store_string(to_json(save_dictionary))
		file.close()
		reset_level()
		
	


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

func reset_level():
	get_tree().reload_current_scene();

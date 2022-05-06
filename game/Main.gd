extends Node2D

var current_action;
var monsters_done_processing = false;
var monster_processing = false;

var has_won_level = false


func _ready():
	var saved_game = ResourceLoader.load("user://save.tres")
	var level = saved_game.current_level
	
	var background_texture =  load("res://assets/Levels/Blue/Level_" + str(level) + ".png")
	
	if level == 1:
		$Background_1.visible = true
		$Background_2.visible = false
	elif level == 2:
		$Background_1.visible = false
		$Background_2.visible = true
	else:
		$Background_1.visible = false
		$Background_2.visible = false
	
	$Player.set_current_vertex($Map.vertexes[$Map.starting_vertex_index])
	$Camera2D.position = $Player.position
	$Camera2D/CanvasLayer/Action_bar.init_player_actions($Player)
	


func _process(delta):
	$Camera2D/CanvasLayer/Mana_bar/Mana_bar.clear_mana_bar()
	$Camera2D/CanvasLayer/Mana_bar/Mana_bar.set_mana_bar_vertex($Player.current_vertex.adjacent_mana)
	$Camera2D/CanvasLayer/Mana_bar/Mana_bar.set_mana_bar_grabbed($Player.grabbed_mana)
	$Camera2D/CanvasLayer/Health_bar/Hearts_Health_Bar.clear_health_bar()
	$Camera2D/CanvasLayer/Health_bar/Hearts_Health_Bar.set_health_bar($Player.current_health,$Player.max_health)
	$Camera2D/CanvasLayer/Movement_bar/Movement_bar.clear_movement_bar()
	$Camera2D/CanvasLayer/Movement_bar/Movement_bar.set_movement_bar($Player.current_steps,$Player.max_steps)
	
	$Camera2D/CanvasLayer/Label.text = "monster_proccessing: "+ str(monster_processing)
	
	
	if monsters_done_processing:
		monsters_done_processing = false;
		monster_processing = false;
		$Map.next_turn();
		$Player.next_turn();
	
	
	
	if has_won_level:
		var saved_game = ResourceLoader.load("user://save.tres")
		saved_game.current_level +=1
		ResourceSaver.save("user://save.tres",saved_game)
		reset_level()
	
		
	


func _on_Next_released():
	next_turn();
	

func next_turn():
	monster_processing = true
	$Map.process_monsters()
	
	


func set_current_action(action):
	current_action = action;
	if current_action:
		current_action.get_useable_map_spots($Map, $Player)
	else:
		$Map.clear_actions();

func reset_level():
	get_tree().change_scene("res://Main.tscn")

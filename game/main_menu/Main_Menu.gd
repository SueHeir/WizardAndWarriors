extends Control


export(Script) var game_save_class

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Quit_pressed():
	get_tree().quit()


func _on_Level_select_pressed():
	$Panel/Levels.visible = true
	$Panel/Main_Menu.visible = false


func _on_back_pressed():
	$Panel/Levels.visible = false
	$Panel/Main_Menu.visible = true


func _on_Level_1_pressed():
	var save_game = game_save_class.new()
	save_game.current_level = 1
	ResourceSaver.save("user://save.tres", save_game)
	get_tree().change_scene("res://Main.tscn")


func _on_Level_2_pressed():
	var save_game = game_save_class.new()
	save_game.current_level = 2
	ResourceSaver.save("user://save.tres", save_game)
	get_tree().change_scene("res://Main.tscn")


func _on_Level_3_pressed():
	var save_game = game_save_class.new()
	save_game.current_level = 3
	ResourceSaver.save("user://save.tres", save_game)
	get_tree().change_scene("res://Main.tscn")


func _on_Level_4_pressed():
	var save_game = game_save_class.new()
	save_game.current_level = 4
	ResourceSaver.save("user://save.tres", save_game)
	get_tree().change_scene("res://Main.tscn")

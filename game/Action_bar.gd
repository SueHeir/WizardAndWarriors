extends Control


var Actions = []
var Buttons = []

var active_button = false
var clear_action = false

onready var player = get_node("../../../Player")
onready var main = get_node("../../../../Main")



func _ready():
	pass # Replace with function body.
func _process(delta):
	if clear_action:
		main.set_current_action(null)
		clear_action = false
	
func _unhandled_input(event):
	if event is InputEventScreenTouch and active_button:
		if event.pressed:
			for but in Buttons:
				if but.toggle_mode:
					but.pressed = false
					but.toggle_mode = false
					active_button = false
					clear_action = true



func init_player_actions(playe):
	for action in playe.actions:
		Actions.append(action)
	init_action_bar();


func init_action_bar():
	for act in Actions:
		var action_button = TextureButton.new()
		
		action_button.expand = true
		action_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT
		action_button.size_flags_horizontal = TextureButton.SIZE_EXPAND_FILL
		action_button.size_flags_vertical = TextureButton.SIZE_EXPAND_FILL
		action_button.rect_min_size = Vector2(128,128)
		action_button.connect("pressed", self, "try_action", [action_button])
		
		Buttons.append(action_button)
		$HBox.add_child(action_button)
		action_button.texture_normal = act.action_bar_texture
		action_button.texture_pressed = act.action_bar_texture_clicked
		
		

func try_action(action_button):
	for i in range(len(Buttons)):
		if Buttons[i] == action_button:
			if Actions[i].check_mana_requirements(player):
				Buttons[i].toggle_mode = true
				Buttons[i].pressed = true
				active_button = true
				
				main.set_current_action(Actions[i])
				
			else:
				print("not enough mana")
				main.set_current_action(null)
		else:
			Buttons[i].pressed = false
			Buttons[i].toggle_mode = false


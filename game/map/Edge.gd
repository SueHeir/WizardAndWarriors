extends AnimatedSprite


onready var Hover = false;
var fram_colors = {'black':0,'yellow':1,'red':2};

var adjacent_vertexes = []
var adjacent_vertexes_drawn_edge = []
var adjacent_mana = []

var active_action;
var do_action;

func _ready():
	pass


func add_adjacent_vertex(vertex):
	if(!adjacent_vertexes.has(vertex)):
		adjacent_vertexes.append(vertex);
		adjacent_vertexes_drawn_edge.append(false);
		vertex.add_adjacent_vertex(self);


func add_adjacent_mana(mana):
	adjacent_mana.append(mana);


func set_pos(pos1,pos2):
	var center = (pos2 - pos1)/2 + pos1
	position = center;
	rotation = atan2(pos2.y-pos1.y,pos2.x-pos1.x)
	

func _on_Area2D_mouse_entered():
	Hover = true;
	frame = fram_colors['yellow'];
	do_action = active_action;


func _on_Area2D_mouse_exited():
	Hover = false;
	frame = fram_colors['black'];
	if active_action:
		frame = fram_colors['red'];
	do_action = null;


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch and event.is_pressed():
		do_action = active_action
		get_parent().clicked.append(self)
		get_parent().set_process(true)



func next_turn():
	pass


func set_active_action(action):
	active_action = action
	if active_action:
		frame = fram_colors['red'];
	else:
		frame = fram_colors['black'];
	
func clear_actions():
	active_action = null
	frame = fram_colors['black'];

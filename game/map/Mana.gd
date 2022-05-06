extends AnimatedSprite


onready var Hover = false;
var fram_colors = {'green':0,'blue':1,'red':2,'yellow':3,'orange':4,'purple':5};

var colors = {'green':Color("#6abe30"),'blue':Color("#306082"),'red':Color("#ac3232"),'yellow':Color("#fbf236"),'orange':Color("#df7126"),'purple':Color("#76428a")};

var mana_type
var adjacent_vertexes = []
var adjacent_vertexes_drawn_edge = []


var used = false;
var grabbed = false;
var grabbed_used = false;


var active_action;
var do_action;

func _ready():
	pass


func add_adjacent_vertex(vertex):
	if(!adjacent_vertexes.has(vertex)):
		adjacent_vertexes.append(vertex);
		update()


func set_grabbed(t_or_f):
	if t_or_f:
		grabbed = true;
		animation = mana_type+"_grabbed";
		
	else:
		grabbed = false;
		animation = mana_type;

func _draw():
	#for vertex in adjacent_vertexes:
		#print('test')
		#draw_line(Vector2(0,0), vertex.position - position, colors[mana_type], 1.1, true)
	pass

func set_mana_type(color):
	mana_type = color;
	animation = mana_type;
	$CPUParticles2D.texture = load("res://assets/map/"+mana_type+"_p.png")

func _on_Area2D_mouse_entered():
	Hover = true;


func _on_Area2D_mouse_exited():
	Hover = false;


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		get_parent().clicked.append(self)
		get_parent().set_process(true)



func next_turn():
	used = false;
	grabbed_used = false;

func clear_actions():
	active_action = null

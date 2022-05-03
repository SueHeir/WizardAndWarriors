extends AnimatedSprite

const VERTEX = preload("res://map/Vertex.tscn")
var current_vertex
var old_vertex

var angle = 0.0

var mana_fram_colors = {'green':0,'blue':1,'red':2,'yellow':3,'orange':4,'purple':5};
var walk_dictionary = {-3:"Walk_northwest",-2:"Walk_north",-1:"Walk_northeast",0:"Walk_east",1:"Walk_southeast",2:"Walk_south",3:"Walk_southwest",4:"Walk_west"}
var stand_dictionary = {-3:"Stand_northwest",-2:"Stand_north",-1:"Stand_northeast",0:"Stand_east",1:"Stand_southeast",2:"Stand_south",3:"Stand_southwest",4:"Stand_west"}

var max_steps;
var current_steps;

var max_health;
var current_health;

var grabbed_mana = []


var init_actions_list = ["dash.gd","blink.gd"]

var actions = []


onready var state_machine = $StateMachine;
func _ready():
	
	for action in init_actions_list:
		var Act = load("res://actions/"+ action)
		var act = Act.new()
		add_child(act)
		actions.append(act)
	max_steps = 3;
	max_health = 10;
	current_health = max_health
	turn_beginning();


func set_current_vertex(vert):
	if not vert.holding_object:
		if current_vertex:
			current_vertex.holding_object = null
		current_vertex = vert;
		position = current_vertex.position;
		vert.holding_object = self

func _process(delta):
	if current_health <= 0:
		get_parent().reset_level();

func walk_to_vertex(vert):
	if get_parent().monster_processing:
		return false
	
	if current_steps > 0 and not vert.holding_object:
		current_steps-=1;
		old_vertex = current_vertex;
		old_vertex.holding_object = null
		current_vertex = vert;
		current_vertex.holding_object = self
		
		angle = atan2(current_vertex.position.y-old_vertex.position.y,current_vertex.position.x-old_vertex.position.x)
		state_machine.set_state(state_machine.states.walk);


func walk_some():
	var delta = (current_vertex.position - old_vertex.position).normalized();
	position += delta*2
	if delta.x > 0 and position.x > current_vertex.position.x:
		position = current_vertex.position;
		state_machine.set_state(state_machine.states.idle);
	if delta.x < 0 and position.x < current_vertex.position.x:
		position = current_vertex.position;
		state_machine.set_state(state_machine.states.idle);
	if delta.y > 0 and position.y > current_vertex.position.y:
		position = current_vertex.position;
		state_machine.set_state(state_machine.states.idle);
	if delta.y < 0 and position.y < current_vertex.position.y:
		position = current_vertex.position;
		state_machine.set_state(state_machine.states.idle);


func walk_animation():
	while angle > 360/2:
		angle -= 360;
	while angle < -360/2:
		angle += 360;
	var int_angle = 0
	if angle > 0:
		int_angle = int(ceil(fmod(angle,360/8)))
	if angle < 0:
		int_angle = int(floor(fmod(angle,360/8)))
	play(walk_dictionary[int_angle])


func idle_animation():
	while angle > 360/2:
		angle -= 360;
	while angle < -360/2:
		angle += 360;
	var int_angle = 0
	if angle > 0:
		int_angle = int(ceil(fmod(angle,360/8)))
	if angle < 0:
		int_angle = int(floor(fmod(angle,360/8)))
	play(stand_dictionary[int_angle])


func spell_some():
	pass

func spell_animation():
	pass


func grab_mana(mana):
	if !grabbed_mana.has(mana):
		grabbed_mana.append(mana);
		mana.set_grabbed(true);
		get_parent().next_turn();

	
func turn_beginning():
	current_steps = max_steps;



func next_turn():
	current_steps = max_steps;


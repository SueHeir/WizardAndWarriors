extends AnimatedSprite

const VERTEX = preload("res://map/Vertex.tscn")
var current_vertex
var old_vertex

var angle = 0.0

var mana_fram_colors = {'green':0,'blue':1,'red':2,'yellow':3,'orange':4,'purple':5};
var walk_dictionary = {-3:"Walk_northwest",-2:"Walk_north",-1:"Walk_northeast",0:"Walk_east",1:"Walk_southeast",2:"Walk_south",3:"Walk_southwest",4:"Walk_west"}
var stand_dictionary = {-3:"Stand_northwest",-2:"Stand_north",-1:"Stand_northeast",0:"Stand_east",1:"Stand_southeast",2:"Stand_south",3:"Stand_southwest",4:"Stand_west"}
var melee_dictionary = {-3:"Melee_northwest",-2:"Melee_north",-1:"Melee_northeast",0:"Melee_east",1:"Melee_southeast",2:"Melee_south",3:"Melee_southwest",4:"Melee_west"}


var monster_type
var attack_list = ["melee"]
var attacks_left_this_turn 
var max_steps;
var current_steps;
var walk_path = []
var walk_queue = []

var max_health;
var current_health;


var grabbed_mana = []


var actions = []
var current_action
var current_action_on_obejct
var current_action_timer = 0

onready var state_machine = $StateMachine;
func _ready():
	max_steps = 5;
	max_health = 10;
	current_health = max_health
	attacks_left_this_turn = [] +attack_list
	turn_beginning();

func set_type(type):
	monster_type = type;


func set_current_vertex(vert):
	if not vert.holding_object:
		if current_vertex:
			current_vertex.holding_object = null
		current_vertex = vert;
		position = current_vertex.position;
		vert.holding_object = self


func _process(delta):
	pass
	
	
func process_turn(player):
	attacks_left_this_turn = [] + attack_list
	go_to_vertex(player.current_vertex)
	

func handle_attack_que():
	if attacks_left_this_turn.size() == 0:
		return false
		
	if attacks_left_this_turn[0] == "melee":
		for vert in current_vertex.adjacent_vertexes:
			if vert.holding_object:
				if vert.holding_object.is_in_group("friendly"):
					attacks_left_this_turn.remove(0)
					angle = atan2(vert.position.y-current_vertex.position.y,vert.position.x-current_vertex.position.x)
					state_machine.set_state(state_machine.states.action);
					current_action = "melee"
					current_action_on_obejct = vert.holding_object
					return true
	return false
				


func handle_walk_que():
	if walk_queue.size() > 0:
		var vertex = walk_queue[0]
		walk_queue.remove(0)
		walk_to_vertex(vertex)

func walk_to_vertex(vert):
	if not vert.holding_object:
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


func action_some(delta):
	pass

func action_animation():
	while angle > 360/2:
		angle -= 360;
	while angle < -360/2:
		angle += 360;
	var int_angle = 0
	if angle > 0:
		int_angle = int(ceil(fmod(angle,360/8)))
	if angle < 0:
		int_angle = int(floor(fmod(angle,360/8)))
	
	play(melee_dictionary[int_angle])

func _on_Monster_animation_finished():
	if current_action and state_machine.state == state_machine.states["action"]:
		current_action = null
		current_action_on_obejct.current_health -= 8
		current_action_on_obejct = null
		state_machine.set_state(state_machine.states.idle);
		
		


func grab_mana(mana):
	if !grabbed_mana.has(mana):
		grabbed_mana.append(mana);
		mana.set_grabbed(true);
		get_parent().next_turn();

	
func turn_beginning():
	current_steps = max_steps;



func next_turn():
	current_steps = max_steps;


func go_to_vertex(vertex_goal):
	#print("Next Turn")
	var path = search_path_to_vertex(vertex_goal,[], current_vertex)
	print(path)
	var walk_distance = min(path.size()-1, max_steps)
	for i in range(walk_distance):
		walk_queue.append(path[i])
	handle_walk_que()
	get_parent().clear_vertex_visited_data();


func search_path_to_vertex(vertex_goal, paths_to_search, current_position):
	
	#print("current position: "+str(current_position))
	var current_path_index = null
	var current_path
	
	#First Call of Function
	if paths_to_search.size() == 0 and current_position == current_vertex:
		current_vertex.monster_visited = true
		var new_paths_to_search = []
		for vert in current_position.adjacent_vertexes:
			new_paths_to_search.append([vert])
			vert.monster_visited = true
		for vert in current_position.adjacent_vertexes:
			var returned_paths = search_path_to_vertex(vertex_goal,new_paths_to_search,vert)
			for path in returned_paths:
				if path[path.size()-1] == vertex_goal:
					return path
		
	
	#resursive calls to function
	
	
	else:
		for i in range(paths_to_search.size()):
			if paths_to_search[i][paths_to_search[i].size()-1] == current_position:
				current_path = paths_to_search[i]
				current_path_index = i
				
				#print("has_current_path_index")
		paths_to_search.remove(current_path_index)
	
	var returned_paths 
	for vert in current_position.adjacent_vertexes:
		if vert.monster_visited:
			continue
		else:
			if current_path_index != null:
				#print("appending_adjacent_vertex")
				var new_path = []+current_path
				new_path.append(vert)
				paths_to_search.append(new_path)
				vert.monster_visited = true
				if vert == vertex_goal:
					#print("Found vertex_goal")
					return [new_path]
				else:
					#print("another_resursive_call")
					returned_paths = search_path_to_vertex(vertex_goal,paths_to_search,vert)
					
					for i in range(returned_paths.size()-1,-1,-1):
						if returned_paths[i][returned_paths[i].size()-1] == vertex_goal:
							return [returned_paths[i]]
						if returned_paths[i][returned_paths[i].size()-1] == vert:
							returned_paths.remove(i)
					
	#print("no adjacent_vertex were used")
	return paths_to_search




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
var walk_target
var walk_target_location
var at_target = false

var is_processing_turn


var max_health;
var current_health;
var last_checked_health = -1;

var melee_damage

var grabbed_mana = []


var actions = []
var current_action
var current_action_on_obejct


onready var state_machine = $StateMachine;
func _ready():
	max_steps = 5;
	current_steps = max_steps
	max_health = 4;
	current_health = max_health
	melee_damage = 7;
	attacks_left_this_turn = [] +attack_list
	$Hearts_Health_Bar.scale = Vector2(0.25,0.25)
	$Hearts_Health_Bar.position = $Hearts_Health_Bar.position + Vector2(-8,-34)
	
	

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
	if current_health <= 0:
		get_parent().dead_monsters.append(self)
		
	$Hearts_Health_Bar.set_health_bar(current_health,max_health)
	if last_checked_health != current_health:
		last_checked_health = current_health
		$Hearts_Health_Bar.visible = true
		$Hearts_Health_Bar/Health_display_timer.start()
	

	
func process_turn(player):
	is_processing_turn = true
	walk_target = player
	walk_target_location = player.current_vertex
	current_steps = max_steps
	attacks_left_this_turn = [] + attack_list	
	handle_attack_que()
	go_to_vertex(walk_target_location)
	

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
		return true
	else:
		if walk_target:
			if walk_target_location != walk_target.current_vertex:
				if is_processing_turn:
					walk_target_location = walk_target.current_vertex
					go_to_vertex(walk_target_location)
					return true
		return false

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
		if current_action == "melee":
			current_action_on_obejct.current_health -= melee_damage
		current_action = null
		current_action_on_obejct = null
		state_machine.set_state(state_machine.states.idle);
		
		


func grab_mana(mana):
	if !grabbed_mana.has(mana):
		grabbed_mana.append(mana);
		mana.set_grabbed(true);
		get_parent().next_turn();




func next_turn():
	current_steps = max_steps;



func go_to_vertex(vertex_goal):
	walk_queue.clear()
	var path = breath_first_search_to_vertex(vertex_goal,current_vertex)
	var walk_distance = min(path.size()-1, current_steps)
	#print("next_search")
	for i in range(walk_distance):
		walk_queue.append(path[i])
	#print(walk_queue)
	get_parent().clear_vertex_visited_data();
	handle_walk_que()


func breath_first_search_to_vertex(vertex_goal,current_position):
	
	
	current_position.monster_visited = true
	var possible_paths = []
	for vert in current_position.adjacent_vertexes:
		vert.monster_visited = true
		possible_paths.append([vert])
	
	
	while(true):
		
		#print(possible_paths)
		var paths_to_add = []
		for path in possible_paths:
			if path.back() == vertex_goal:
				return path
			var non_visited_verts = []
			for vert in path.back().adjacent_vertexes:
				if vert.monster_visited == false:
					vert.monster_visited = true
					non_visited_verts.append(vert)
			var orignial_path = [] + path
			for i in range(0,non_visited_verts.size()):
				if i == 0:
					path.append(non_visited_verts[i])
				else:
					var new_path = [] + orignial_path
					new_path.append(non_visited_verts[i])
					paths_to_add.append(new_path)
		for path in paths_to_add:
			possible_paths.append(path)
	pass


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
			
		var all_returned_paths = []
		for vert in current_position.adjacent_vertexes:
			var returned_paths = search_path_to_vertex(vertex_goal,new_paths_to_search,vert)
			print(vert)
			print(returned_paths)
			for path in returned_paths:
				all_returned_paths.append(path)
		var min_length_index
		var min_length = 10000
		#print(all_returned_paths)
		for i in range(all_returned_paths.size()):
			print(str(i))
			if all_returned_paths[i][all_returned_paths[i].size()-1] == vertex_goal:
				
				if all_returned_paths[i].size() < min_length:
					min_length_index = i
					min_length = all_returned_paths[i].size()
		if min_length_index != null:
			return all_returned_paths[min_length_index]
	
	#resursive calls to function
	
	
	else:
		print(current_position)
		for i in range(paths_to_search.size()):
			if paths_to_search[i][paths_to_search[i].size()-1] == current_position:
				current_path = paths_to_search[i]
				current_path_index = i
				
				#print("has_current_path_index")
		paths_to_search.remove(current_path_index)
	
	var returned_paths 
	var paths_with_vertex_goal = []
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
					paths_with_vertex_goal.append(new_path)
				else:
					#print("another_resursive_call")
					returned_paths = search_path_to_vertex(vertex_goal,paths_to_search,vert)
					
					
					for i in range(returned_paths.size()-1,-1,-1):
						if returned_paths[i][returned_paths[i].size()-1] == vertex_goal:
							paths_with_vertex_goal.append(returned_paths[i])
						if returned_paths[i][returned_paths[i].size()-1] == vert:
							returned_paths.remove(i)
	if paths_with_vertex_goal.size() > 0:
		return paths_with_vertex_goal
	#print("no adjacent_vertex were used")
	return paths_to_search




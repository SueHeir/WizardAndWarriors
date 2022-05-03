extends Node2D



onready var player = get_node("../Player")
onready var main = get_node("../../Main")

const VERTEX = preload("res://map/Vertex.tscn")
const EDGE = preload("res://map/Edge.tscn")
const MANA = preload("res://map/Mana.tscn")

const MONSTER = preload("res://monsters/Monster.tscn")

var map_json_dict = {}

var vertexes = []
var edges = []
var mana = []
var monsters = []

var vertex_positons = [];
var vertex_connections = [];
var monster_positions = [];
var monster_names = [];
var starting_vertex_index


var mana_positions = [];
var mana_colors = [];
var mana_connections = [];

var clicked = []



func _ready():
	
	var saved_game = ResourceLoader.load("user://save.tres")
	var level = saved_game.current_level
	
	#var save_json = "res://saves/saves.json";
	#var save_json_dict = load_json_file(save_json);
	
	#var level = save_json_dict["current_level"]
	
	var default_json_map = "res://levels/blue/level_"+str(level)+".json";
	map_json_dict = load_json_file(default_json_map);
	
	create_map();
	
	
func load_json_file(path):
	"""Loads a JSON file from the given res path and return the loaded JSON object."""
	var file = File.new()
	file.open(path, file.READ)
	var text = file.get_as_text()
	var result_json = JSON.parse(text)
	if result_json.error != OK:
		print("[load_json_file] Error loading JSON file '" + str(path) + "'.")
		print("\tError: ", result_json.error)
		print("\tError Line: ", result_json.error_line)
		print("\tError String: ", result_json.error_string)
		return null
	var obj = result_json.result
	file.close();
	return obj
	
func create_map():
	
	starting_vertex_index = map_json_dict["map_start_vertex"]
	
	#Loads Data from Json Dictionary into Vectors for creating the map
	for obj in map_json_dict["vertex_positions"]:
		vertex_positons.append(Vector2(obj["x"],obj["y"]))
	for obj in map_json_dict["vertex_connections"]:
		vertex_connections.append(Vector2(obj["A"],obj["B"]))
	for obj in map_json_dict["mana_points"]:
		mana_positions.append(Vector2(obj["x"],obj["y"]))
		mana_colors.append(obj["color"])
	for obj in map_json_dict["mana_connections"]:
		mana_connections.append(Vector2(obj["A"],obj["B"]))
	for obj in map_json_dict["monster_positions"]:
		monster_positions.append(obj["Vertex"])
	for obj in map_json_dict["monster_names"]:
		monster_names.append(obj["monster_name"])
	
	#Creates Vertex scene and sets it's poition
	for i in vertex_positons.size():
		var vertex_inst = VERTEX.instance();
		vertex_inst.position = vertex_positons[i];
		vertexes.append(vertex_inst);
		add_child(vertex_inst);
		
	#Connects all the vertexes
	for i in vertex_connections.size():
		vertexes[vertex_connections[i].x].add_adjacent_vertex(vertexes[vertex_connections[i].y])
	
	#Creates all the Edges based on the connected Vertexes 
	for vertex in vertexes:
		for i in vertex.adjacent_vertexes.size():
			#if the vertex's edge hasn't been made yet make it
			if(!vertex.adjacent_vertexes_drawn_edge[i]):
				#Set Vertex A and Vertex B so that they have "made" their edge
				vertex.adjacent_vertexes_drawn_edge[i] = true;
				for j in vertex.adjacent_vertexes[i].adjacent_vertexes.size():
					if(vertex.adjacent_vertexes[i].adjacent_vertexes[j]==vertex):
						vertex.adjacent_vertexes[i].adjacent_vertexes_drawn_edge[j] = true;
				var edge_inst = EDGE.instance();
				edge_inst.set_pos(vertex.position,vertex.adjacent_vertexes[i].position);
				edges.append(edge_inst);
				add_child(edge_inst);
	
	#Creates Mana scene and sets each poititon
	for i in mana_positions.size():
		var mana_inst = MANA.instance();
		mana_inst.position = mana_positions[i];
		mana_inst.set_mana_type(mana_colors[i]);
		mana.append(mana_inst);
		add_child(mana_inst);
	
	#Gives each vertex the connected mana, and each mana the connected Vertex
	for i in mana_connections.size():
		vertexes[mana_connections[i].y].add_adjacent_mana(mana[mana_connections[i].x])
		mana[mana_connections[i].x].add_adjacent_vertex(vertexes[mana_connections[i].y])
		
	
	for i in monster_positions.size():
		var monster = MONSTER.instance();
		monster.set_type(monster_names[i])
		monster.set_current_vertex(vertexes[monster_positions[i]])
		monsters.append(monster)
		add_child(monster)



func _process(delta):
	
	var all_false = true
	for monster in monsters:
		if monster.is_processing_turn:
			all_false = false
	if all_false and get_parent().monster_processing:
		get_parent().monsters_done_processing = true;
	
	for map_object in clicked:
		if map_object.do_action:
			#print("did action")
			map_object.do_action.do_action(player, map_object);
			break
		
		
		for vert in player.current_vertex.adjacent_vertexes:
			if vert == map_object:
				if(player.state_machine.state==player.state_machine.states.idle):
					player.walk_to_vertex(vert);
		for man in player.current_vertex.adjacent_mana:
			if man == map_object:
				if(player.state_machine.state==player.state_machine.states.idle):
					player.grab_mana(man);
	clicked.clear();


func process_monsters():
	for monster in monsters:
		monster.process_turn(player);

func next_turn():
	for ma in mana:
		ma.next_turn();
	for vertex in vertexes:
		vertex.next_turn();
	for edge in edges:
		edge.next_turn();
	
func clear_actions():
	for ma in mana:
		ma.clear_actions();
	for vertex in vertexes:
		vertex.clear_actions();
	for edge in edges:
		edge.clear_actions();
		
func clear_vertex_visited_data():
	for vertex in vertexes:
		vertex.monster_visited = false;

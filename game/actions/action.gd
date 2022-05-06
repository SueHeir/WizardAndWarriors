extends Node
class_name Action_Spell

var action_name = "blank";

var action_bar_texture;
var action_bar_texture_clicked;
var action_bar_texture_path;


var mana_cost = []


func _ready():
	pass


func load_action_bar_texture(action_bar_texture_path):
	action_bar_texture = load(action_bar_texture_path+".png")
	action_bar_texture_clicked = load(action_bar_texture_path+"_clicked.png")

func do_action(player, map_object):
	#print("spentMana")
	spend_mana(player)
	map_object.do_action = null
	


func check_mana_requirements(player):
	var uncheck_mana = [] + mana_cost
	for mana in player.current_vertex.adjacent_mana:
		for i in range(mana_cost.size()-1, -1, -1):
			if mana_cost[i] == mana.mana_type and mana.used == false:
				uncheck_mana.remove(i)
	for mana in player.grabbed_mana:
		for i in range(mana_cost.size()-1, -1, -1):
			if mana_cost[i] == mana.mana_type and mana.grabbed_used == false:
				uncheck_mana.remove(i)
				
	if uncheck_mana.size() == 0:
		return true
	else:
		return false

func get_useable_map_spots(map, player):
	pass


func spend_mana(player):
	var temp_mana_cost = [] + mana_cost
	
	while(temp_mana_cost.size()>0):
		for i in range(temp_mana_cost.size()-1,-1,-1):
			for mana in player.current_vertex.adjacent_mana:
				if temp_mana_cost[i] == mana.mana_type and mana.used == false:
					mana.used = true
					temp_mana_cost.remove(i)
					if temp_mana_cost.size()==0:
						return
					continue
			
			for mana in player.grabbed_mana:
				if temp_mana_cost[i] == mana.mana_type and mana.grabbed_used == false:
					mana.grabbed_used = true
					temp_mana_cost.remove(i)
					if temp_mana_cost.size()==0:
						return
					continue


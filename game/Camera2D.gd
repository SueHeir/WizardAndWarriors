extends Camera2D
var first_distance =0
var events={}
var percision = 10
var current_zoom
var maximum_zoomin = Vector2(0.5,0.5)
var minimum_zoomout = Vector2(3,3)
var center
onready var player = get_node("../Player")



func _ready():
	set_process_unhandled_input(true)
	zoom = Vector2(0.4,0.4)
	
	pass

func is_zooming():
	return events.size()>1

func dist():
	var first_event =null
	var result 
	for event in events:
		if first_event!=null:
			result = events[event].get_position().distance_to(first_event.get_position())
			break
		first_event = events[event]
	return result

func centerino():
	var first_event =null
	var result 
	for event in events:
		if first_event!=null:
			result = (map_pos(events[event].get_position()) + map_pos(first_event))/2
			break
		first_event = events[event].get_position()
	return result

func map_pos(pos):
	var mtx = get_viewport().get_canvas_transform()
	var mt = mtx.affine_inverse()
	var p = mt.xform(pos)
	return p 
func _unhandled_input(event):
		if event is InputEventScreenTouch and event.is_pressed():
			events[event.index]=event

			if events.size()>1:
				current_zoom=get_zoom()
				first_distance = dist()
				center = centerino()
		elif event is InputEventScreenTouch and not event.is_pressed():
			events.erase(event.index)
		elif event is InputEventScreenDrag :
			events[event.index] = event

			if events.size()>1:
				var second_distance = dist()
				if abs(first_distance-second_distance)>percision:
					var new_zoom =Vector2(first_distance/second_distance,first_distance/second_distance)
					var zoom = new_zoom*current_zoom
					if zoom<minimum_zoomout and zoom>maximum_zoomin:
						set_zoom(zoom)
					elif zoom>minimum_zoomout:
						set_zoom(minimum_zoomout)
					elif zoom<maximum_zoomin:
						set_zoom(maximum_zoomin)
					set_global_position(center)
			elif events.size()==1:
				set_global_position(get_global_position()-event.get_relative()*get_zoom()*1)

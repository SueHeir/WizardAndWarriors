extends StateMachine


func _ready():
	add_state("idle")
	add_state("walk")
	add_state("action")
	call_deferred("set_state", states.idle)
	
	
func _state_logic(delta):
	
	match state:
		states.walk:
			parent.walk_some();
		states.action:
			parent.action_some(delta);

func _get_transition(delta):
	pass
	#match state:
		#states.idle:
			#if parent._should_walk():
			#	return states.walk;
		#states.walk:
			#if parent._should_idle():
			#	return states.idle;


func _enter_state(new_state,old_state):
	match state:
		states.idle:
			parent.idle_animation();
			if parent.handle_attack_que():
				continue
			elif parent.handle_walk_que():
				continue
			else:
				parent.walk_target = null
				parent.walk_target_location = null
				parent.is_processing_turn = false
		states.walk:
			parent.walk_animation();
		states.action:
			parent.action_animation();


func _exit_state(old_state,new_state):
	pass

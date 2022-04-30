extends StateMachine


func _ready():
	add_state("idle")
	add_state("walk")
	add_state("spell")
	call_deferred("set_state", states.idle)
	
	
func _state_logic(delta):
	
	match state:
		states.walk:
			parent.walk_some();
		states.spell:
			parent.spell_some();

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
		states.walk:
			parent.walk_animation();
		states.spell:
			parent.spell_animation();


func _exit_state(old_state,new_state):
	pass

extends AnimatedSprite

var start 
var end

var SPEED = 4

func _ready():
	pass # Replace with function body.

func set_start_and_end(star,en):
	start = star;
	end = en
	position = start.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if start and end:
		var del = (end.position - start.position).normalized();
		position += del*SPEED
		if del.x > 0 and position.x > end.position.x:
			position = end.position;
			end.current_health -= 2
			queue_free()
		if del.x < 0 and position.x < end.position.x:
			position = end.position;
			end.current_health -= 2
			queue_free()
		if del.y > 0 and position.y > end.position.y:
			position = end.position;
			end.current_health -= 2
			queue_free()
		if del.y < 0 and position.y < end.position.y:
			position = end.position;
			end.current_health -= 2
			queue_free()

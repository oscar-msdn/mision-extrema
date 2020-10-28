extends CPUParticles2D

export(float) var FREEZE_TIMER = 0.15
export(float) var KILL_TIMER = 10.0
var time_life_counter := 0.0
var is_alive := true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if is_alive:
		time_life_counter += delta
		if time_life_counter >= FREEZE_TIMER:
			is_alive = false
			_freeze_()

func _freeze_():
	speed_scale = 0.0
	Helper.set_enabler_entity(self,false)
	yield(get_tree().create_timer(KILL_TIMER),"timeout")
	_drop_()

func _drop_():
	queue_free()

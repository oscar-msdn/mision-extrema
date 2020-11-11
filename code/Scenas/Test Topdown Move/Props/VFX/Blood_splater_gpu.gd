extends Particles2D

export(float) var FREEZE_TIMER = 0.15
export(float) var KILL_TIMER = 0.0

var time_life_counter := 0.0
var is_alive := true

func _ready():
	z_index = 1
	z_as_relative = false

func _process(delta):
	if is_alive:
		time_life_counter += delta
		if time_life_counter >= FREEZE_TIMER:
			is_alive = false
			_freeze_()

func _freeze_():
	speed_scale = 0.0
	Helper.set_enabler_entity(self,false)
	if KILL_TIMER > 0:
		yield(get_tree().create_timer(KILL_TIMER),"timeout")
		_drop_()

func _drop_():
	queue_free()

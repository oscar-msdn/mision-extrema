extends Particles2D

export(float) var KILL_TIMER = 0.5
var time_life_counter := 0.0
var is_alive := true
var is_smoke := true

func _ready():
	z_index = Util.ZINDEX_BULLET + 1
	z_as_relative = false
	_ready_()

func _ready_():
	if is_smoke:
		var smoke = Helper.smoke(global_position)
		smoke.scale *= 0.2
	emitting = true

func _process(delta):
	if is_alive:
		time_life_counter += delta
		if time_life_counter >= KILL_TIMER:
			_drop_()

func _drop_():
	if is_alive:
		is_alive = false
		queue_free()

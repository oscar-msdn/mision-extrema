extends Particles2D

export(float) var KILL_TIMER = 0.5
var time_life_counter := 0.0
var is_alive := true

func _init():
	z_index = Util.ZINDEX_BULLET + 1
	z_as_relative = false

func _ready():
	var smoke = Helper.smoke($Position2D.global_position)
	smoke.scale *= 0.25
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

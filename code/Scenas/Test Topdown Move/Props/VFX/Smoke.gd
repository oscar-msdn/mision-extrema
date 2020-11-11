extends Particles2D

export(float) var LIFE_TIME = 10.0
export(float) var KILL_TIMER = 1.0
export(float) var SPEED_SCALE = 10.0
export(float) var FACTOR = 1.0
var time_life_counter := 0.0
var is_alive := true
var _killer_timer := 0.0

#func _init():
#	lifetime = LIFE_TIME
#	speed_scale = SPEED_SCALE * FACTOR
#	_killer_timer = KILL_TIMER / FACTOR
#	z_index = Util.ZINDEX_BULLET + 1
#	z_as_relative = false

# Called when the node enters the scene tree for the first time.
func _ready():
	lifetime = LIFE_TIME
	speed_scale = SPEED_SCALE * FACTOR
	_killer_timer = KILL_TIMER / FACTOR
	z_index = Util.ZINDEX_BULLET + 1
	z_as_relative = false
	emitting = true

func _process(delta):
	if is_alive:
		time_life_counter += delta
		if time_life_counter >= _killer_timer:
			_drop_()

func _drop_():
	if is_alive:
		is_alive = false
		queue_free()

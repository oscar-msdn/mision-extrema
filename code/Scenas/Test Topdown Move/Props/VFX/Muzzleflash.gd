extends Particles2D

const KILL_TIMER = 0.3
var time_life_counter := 0.0
var is_alive := true

func _init():
	z_index = Util.ZINDEX_BULLET + 1
	z_as_relative = false

func _ready():
	$Smoke.z_as_relative = false
	$Smoke.z_index = Util.ZINDEX_BULLET
	emitting = true
	$Smoke.emitting = true
	
func _physics_process(delta):
	if is_alive:
		time_life_counter += delta
		if time_life_counter >= KILL_TIMER:
			_drop_()

func _drop_():
	if is_alive:
		is_alive = false
		queue_free()

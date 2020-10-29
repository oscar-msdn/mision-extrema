extends Particles2D

export(float) var FREEZE_TIMER = 1.0
export(float) var KILL_TIMER = 10.0
var time_life_counter := 0.0
var is_alive := true

func _init():
	z_index = Util.ZINDEX_BULLET + 1
	z_as_relative = false

func _ready():
	$Blood_sparks_sub.z_index = Util.ZINDEX_BULLET + 1
	$Blood_sparks_sub.z_as_relative = false
	$Blood_sparks_sub.emitting = true

func _process(delta):
	if is_alive:
		time_life_counter += delta
		if time_life_counter >= FREEZE_TIMER:
			is_alive = false
			_drop_()

func _freeze_():
	speed_scale = 0.0
	Helper.set_enabler_entity(self,false)
	yield(get_tree().create_timer(KILL_TIMER),"timeout")
	_drop_()

func _drop_():
	queue_free()


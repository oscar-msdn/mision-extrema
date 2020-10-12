extends Area2D
class_name Bullet

export(float) var speed = 4000
export(float) var damage = 100

const KILL_TIMER = 1.0

var direction := Vector2.ZERO
var velocity := Vector2.ZERO
var current_damage := 0

var time_life_counter := 0.0
var is_alive := true

func _init():
	collision_layer = Util.LAYER_BULLET
	collision_mask = Util.MASK_BULLET
	z_index = Util.ZINDEX_BULLET
	z_as_relative = false

func set_values(origin, target):
	direction = origin.direction_to(target)
	rotation = direction.angle() - PI / 2
	global_position = origin
	current_damage = damage
	is_alive = true

func _physics_process(delta):
	if is_alive:
		global_translate(direction * speed * delta)
		time_life_counter += delta
		if time_life_counter >= KILL_TIMER:
			call_deferred("drop_bullet")

func drop_bullet():
	if is_alive:
		is_alive = false
		queue_free()

# warning-ignore:unused_argument
func _on_Bullet_area_entered(area):
	pass # Replace with function body.

# warning-ignore:unused_argument
func _on_Bullet_area_exited(area):
	pass # Replace with function body.

func _on_Bullet_body_entered(body):
	if is_alive:
		if body:
			var shield := 0
			if body.has_method("get_shield"):
				shield = body.get_shield()
			if body.has_method("give_damage"):
				body.give_damage(current_damage,global_transform)
				current_damage -= shield
				if current_damage <= 0:
					call_deferred("drop_bullet")

# warning-ignore:unused_argument
func _on_Bullet_body_exited(body):
	pass # Replace with function body.

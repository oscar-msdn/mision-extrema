extends EntityBase
#Clase base de gestion de movimiento
class_name EntityController

export(float) var Velocity = 1000.0
export(float) var Mouse_Sensibility:float = 10.0
export(float) var Sensibility:float = 10.0

var direction :Vector2 = Vector2.ZERO
var lookat_position : Vector2 = Vector2.ZERO
var velocity_lineal :Vector2 = Vector2.ZERO

func _physics_process(delta):
	make_move(delta)

func make_move(delta):
	_move_entity(delta)
	_get_look_at(delta)

var old_velocity_lineal := Vector2.ZERO
func _move_entity(delta):
	var vel_lineal_temp = direction.normalized() * Velocity
	if vel_lineal_temp != Vector2.ZERO or velocity_lineal != Vector2.ZERO:
		velocity_lineal = velocity_lineal.linear_interpolate(vel_lineal_temp,delta*Sensibility)
		velocity_lineal = velocity_lineal.clamped(Velocity)
		velocity_lineal = velocity_lineal.ceil()
		if vel_lineal_temp == Vector2.ZERO:
			if old_velocity_lineal == velocity_lineal:
				velocity_lineal = Vector2.ZERO
				
		old_velocity_lineal = velocity_lineal
		if velocity_lineal != Vector2.ZERO:
			var old_position = global_position
			velocity_lineal = move_and_slide(velocity_lineal)
			old_position = global_position - old_position 
			_position_changed(old_position)

var old_lookat_position := Vector2.ZERO
var rotation_to :float = 0
func _get_look_at(delta):
	if old_lookat_position != lookat_position or velocity_lineal != Vector2.ZERO:
		old_lookat_position = lookat_position
		rotation_to =  lookat_position.angle_to_point(position)
		_custom_look_at(delta)

func _custom_look_at(delta):
	if rotation_to != rotation:
		var rot = lerp_angle(rotation, rotation_to, delta * Mouse_Sensibility)
		var diff = abs(rot - rotation_to)
		if diff < 0.01:
			rotation = rotation_to
		else:
			rotation = rot

func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference

# warning-ignore:unused_argument
func _position_changed(value):
	pass

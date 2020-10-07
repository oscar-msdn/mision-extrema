extends KinematicBody2D
#Clase base de gestion de movimiento
class_name EntityController

export(float) var Velocity = 500.0
export(float) var Sensibility:float = 15.0

var direction :Vector2 = Vector2.ZERO
var lookat_position : Vector2 = Vector2.ZERO
var velocity_lineal :Vector2 = Vector2.ZERO

func _ready():
	_init_entity()

func _process(delta):
	_loop_process_render(delta)

func _physics_process(delta):
	make_move(delta)
	_loop_process(delta)

func make_move(delta):
	get_look_at(delta)
	move_entity(delta)

func move_entity(delta):
	var vel_lineal_temp = direction.normalized() * Velocity
	velocity_lineal = velocity_lineal.linear_interpolate(vel_lineal_temp,delta*Sensibility)
	velocity_lineal = velocity_lineal.clamped(Velocity)
	velocity_lineal = move_and_slide(velocity_lineal)

func get_look_at(delta):
	var rotation_to =  lookat_position.angle_to_point(position)
	rotation = lerp_angle(rotation, rotation_to, delta * Sensibility)

func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference

#Metodos a Heredar

#Incializacion de entidades. _ready
func _init_entity():
	pass

#Loop general. _physics_process
# warning-ignore:unused_argument
func _loop_process(delta):
	pass

#Loop de render. _process
# warning-ignore:unused_argument
func _loop_process_render(delta):
	pass

